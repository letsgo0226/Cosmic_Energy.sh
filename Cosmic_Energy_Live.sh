#!/bin/sh
command -v python3 >/dev/null 2>&1 || { echo python3_required >&2; exit 127; }
exec python3 -u - "${1:-letsgo0226}" "$0" <<'PY'
import sys,json,urllib.request,urllib.parse,os,base64
owner=sys.argv[1]; self_path=sys.argv[2]
target=f"{owner}/Cosmic_Energy.sh"; workflow_path=".github/workflows/cosmic-energy.yml"
H={"User-Agent":"Cosmic-Energy-Live"}; tok=os.getenv("GITHUB_TOKEN") or os.getenv("GH_TOKEN")
if tok:H["Authorization"]="Bearer "+tok
def get(url):
    req=urllib.request.Request(url,headers=H)
    with urllib.request.urlopen(req,timeout=30) as f:return json.loads(f.read())
def content(repo,path,ref):
    u="https://api.github.com/repos/%s/contents/%s?ref=%s"%(repo,urllib.parse.quote(path,safe="/"),urllib.parse.quote(ref,safe=""))
    return base64.b64decode(get(u)["content"])
def E(b):return int.from_bytes(b"\1"+b,"big")
def D(n):return n.to_bytes((n.bit_length()+7)//8,"big")[1:]
def rev(b):return D(E(b))==b
def coord(b):
    g=0
    for x in b:g=(g*257+x+1)%1000000007
    return g
repos=[]; page=1
while True:
    a=get(f"https://api.github.com/users/{urllib.parse.quote(owner)}/repos?type=public&per_page=100&page={page}")
    a=[r for r in a if not r.get("private")]; repos+=a
    if len(a)<100:break
    page+=1
manifest=[]; errors=[]; truncated=False
for r in repos:
    try:
        branch=r["default_branch"]
        url="https://api.github.com/repos/%s/git/trees/%s?recursive=1"%(r["full_name"],urllib.parse.quote(branch,safe=""))
        z=get(url); truncated|=bool(z.get("truncated"))
        manifest += [[r["full_name"],branch,x["path"],x.get("size",0),x.get("sha","")] for x in z.get("tree",[]) if x.get("type")=="blob"]
    except Exception as e:errors.append([r.get("full_name"),type(e).__name__])
manifest.sort(); mb=json.dumps(manifest,separators=(",",":"),ensure_ascii=False).encode()
self_bytes=open(self_path,"rb").read(); workflow_bytes=open(workflow_path,"rb").read() if os.path.exists(workflow_path) else b""
repo_meta=next((r for r in repos if r.get("full_name")==target),None); default_ref=repo_meta.get("default_branch","main") if repo_meta else "main"
run_ref=os.getenv("GITHUB_SHA") or default_ref
remote_self=remote_workflow=b""; remote_error=None
try:
    remote_self=content(target,"Cosmic_Energy_Live.sh",run_ref)
    remote_workflow=content(target,workflow_path,run_ref)
except Exception as e:remote_error=type(e).__name__
paths={(r,p) for r,_,p,_,_ in manifest}
self_in_manifest=(target,"Cosmic_Energy_Live.sh") in paths
workflow_in_manifest=(target,workflow_path) in paths
self_rev=rev(self_bytes); workflow_rev=bool(workflow_bytes) and rev(workflow_bytes); manifest_rev=rev(mb)
system_bytes=mb+b"\0SELF\0"+self_bytes+b"\0WORKFLOW\0"+workflow_bytes
system_rev=rev(system_bytes)
self_remote_match=(remote_self==self_bytes) if remote_self else False
workflow_remote_match=(remote_workflow==workflow_bytes) if remote_workflow else False
ok=all((manifest_rev,self_rev,workflow_rev,system_rev,self_in_manifest,workflow_in_manifest,self_remote_match,workflow_remote_match,not truncated,not errors,remote_error is None))
out={"MODEL":"COSMIC_ENERGY_LIVE_SELF_REFERENTIAL","OWNER":owner,"TARGET_REPO":target,"RUN_REF":run_ref,"REPOS":len(repos),"BLOBS":len(manifest),"MANIFEST_BYTES":len(mb),"SYSTEM_BYTES":len(system_bytes),"MANIFEST_COORD":coord(mb),"SYSTEM_COORD":coord(system_bytes),"COORD_ONLY":True,"MANIFEST_REV":manifest_rev,"SELF_REV":self_rev,"WORKFLOW_REV":workflow_rev,"SYSTEM_REV":system_rev,"SELF_IN_PUBLIC_MANIFEST":self_in_manifest,"WORKFLOW_IN_PUBLIC_MANIFEST":workflow_in_manifest,"SELF_REMOTE_MATCH":self_remote_match,"WORKFLOW_REMOTE_MATCH":workflow_remote_match,"PROGRAM_IN_SYSTEM_BYTES":True,"TRUNCATED":truncated,"ERRORS":errors,"REMOTE_ERROR":remote_error,"CORPUS_OK":ok,"BOUNDARY":"formal self-inclusive GitHub/runtime certificate; no external physical-law claim"}
print(json.dumps(out,separators=(",",":"),sort_keys=True));sys.exit(0 if ok else 1)
PY
