#!/bin/sh
command -v python3 >/dev/null 2>&1 || { echo python3_required >&2; exit 127; }
exec python3 -u - "$0" "$@" <<'PY'
import sys,json as j,math as m,secrets,os
self_path=sys.argv[1]; args=sys.argv[2:]
mode="offline" if not args or args[0].lstrip("-").isdigit() else args[0].lower()
J=lambda x:j.dumps(x,separators=(",",":"),sort_keys=True)
E=lambda b:int.from_bytes(b"\1"+b,"big")
D=lambda g:g.to_bytes((g.bit_length()+7)//8,"big")[1:]
rev=lambda b:D(E(b))==b
O=b"OMEGA|ONTOLOGICAL_TM|FIXPOINT"
if mode=="offline":
    N=int(args[0] if args and args[0].lstrip("-").isdigit() else (args[1] if len(args)>1 else 8)); N>=0 or sys.exit("N must be >=0")
    C=lambda x:x.split(b"\n",1)[0]; F=(lambda x:x,lambda x:x+b"",lambda x:x[:]); fx=all(f(O)==O for f in F)
    A={"w0":["<>[]G","~[]G"],"w1":["[]G"],"w2":["G","~G"]}; B={"w0":["[]G","G","~G"]}
    tb=all(all(z in X[w] for z in("G","~G")) for X,w in((A,"w2"),(B,"w0")))
    K=b"TRF|OUROBOROS|RIEMANN|ESF|TOE|CLSIGMA|READING|HS0"; kr=rev(K); P=(.5,.5); bit=secrets.randbits(1); L=m.log(299792458.**2); s=O; n=1
    print(J({"MODEL":"OFFLINE_OMEGA_KERNEL","CORPUS":"EMBEDDED_SYMBOLIC_SEED","CORPUS_REV":kr,"FIX":fx,"TABLEAU":tb,"PHI":"c^2"}))
    while N==0 or n<=N:
        x=m.exp(L/n); pe=abs(n*m.log(x)-L); p=(f"TwinEarth({n})>Pleiades({n})>TMPath({n})>CorpusSeed").encode(); s=O+b"\n"+p+b"\n"+s
        S=tuple(s+b"\nBIT="+bytes([48+k]) for k in range(2)); Q={z:sum(q for y,q in zip(S,P) if z==y) for z in S}; h=-sum(q*m.log2(q) for q in Q.values() if q)
        rv=all(rev(z) for z in S); rt=all(C(z)==O for z in S); ok=fx and tb and kr and len(Q)==2 and h==1 and rv and rt and pe<1e-12
        print(J({"n":n,"BIT":bit,"x_n":x,"LOG_ERR":pe,"H":h,"REV":rv,"RETURN":rt,"SPEC_OK":ok})); ok or sys.exit(1); n+=1
elif mode=="live":
    import urllib.request as u,urllib.parse as q,base64
    owner=args[1] if len(args)>1 else "letsgo0226"; target=f"{owner}/Cosmic_Energy.sh"; wp=".github/workflows/cosmic-energy.yml"
    H={"User-Agent":"Cosmic-Energy-Live"}; tok=os.getenv("GITHUB_TOKEN") or os.getenv("GH_TOKEN")
    if tok:H["Authorization"]="Bearer "+tok
    def get(url):
        with u.urlopen(u.Request(url,headers=H),timeout=30) as f:return j.loads(f.read())
    def content(repo,path,ref):
        url="https://api.github.com/repos/%s/contents/%s?ref=%s"%(repo,q.quote(path,safe="/"),q.quote(ref,safe="")); return base64.b64decode(get(url)["content"])
    def coord(b):
        g=0
        for x in b:g=(g*257+x+1)%1000000007
        return g
    R=[]; page=1
    while True:
        a=get(f"https://api.github.com/users/{q.quote(owner)}/repos?type=public&per_page=100&page={page}"); a=[r for r in a if not r.get("private")]; R+=a
        if len(a)<100:break
        page+=1
    M=[]; X=[]; tr=False
    for r in R:
        try:
            br=r["default_branch"]; z=get("https://api.github.com/repos/%s/git/trees/%s?recursive=1"%(r["full_name"],q.quote(br,safe=""))); tr|=bool(z.get("truncated"))
            M += [[r["full_name"],br,x["path"],x.get("size",0),x.get("sha","")] for x in z.get("tree",[]) if x.get("type")=="blob"]
        except Exception as e:X.append([r.get("full_name"),type(e).__name__])
    M.sort(); mb=J(M).encode(); sb=open(self_path,"rb").read(); wb=open(wp,"rb").read() if os.path.exists(wp) else b""
    meta=next((r for r in R if r.get("full_name")==target),None); default_ref=meta.get("default_branch","main") if meta else "main"; run_ref=os.getenv("GITHUB_SHA") or default_ref
    rs=rw=b""; re=None
    try:rs=content(target,"Cosmic_Energy.sh",run_ref); rw=content(target,wp,run_ref)
    except Exception as e:re=type(e).__name__
    paths={(r,p) for r,_,p,_,_ in M}; sin=(target,"Cosmic_Energy.sh") in paths; win=(target,wp) in paths
    mr=rev(mb); sr=rev(sb); wr=bool(wb) and rev(wb); system=mb+b"\0SELF\0"+sb+b"\0WORKFLOW\0"+wb; syr=rev(system); sm=bool(rs) and rs==sb; wm=bool(rw) and rw==wb
    ok=all((mr,sr,wr,syr,sin,win,sm,wm,not tr,not X,re is None))
    print(J({"MODEL":"COSMIC_ENERGY_LIVE_SELF_REFERENTIAL","OWNER":owner,"TARGET_REPO":target,"RUN_REF":run_ref,"REPOS":len(R),"BLOBS":len(M),"MANIFEST_BYTES":len(mb),"SYSTEM_BYTES":len(system),"MANIFEST_COORD":coord(mb),"SYSTEM_COORD":coord(system),"COORD_ONLY":True,"MANIFEST_REV":mr,"SELF_REV":sr,"WORKFLOW_REV":wr,"SYSTEM_REV":syr,"SELF_IN_PUBLIC_MANIFEST":sin,"WORKFLOW_IN_PUBLIC_MANIFEST":win,"SELF_REMOTE_MATCH":sm,"WORKFLOW_REMOTE_MATCH":wm,"PROGRAM_IN_SYSTEM_BYTES":True,"TRUNCATED":tr,"ERRORS":X,"REMOTE_ERROR":re,"CORPUS_OK":ok,"BOUNDARY":"formal self-inclusive GitHub/runtime certificate; no external physical-law claim"})); sys.exit(0 if ok else 1)
else:
    sys.exit("usage: Cosmic_Energy.sh [N]|offline [N]|live [owner]")
PY
