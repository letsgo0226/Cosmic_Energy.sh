command -v python3>/dev/null||{ echo python3_required >&2;exit 127;};python3 -u -c 'import sys,json as j,urllib.request as u,urllib.parse as q,os;o=sys.argv[1]if len(sys.argv)>1 else"letsgo0226";H={"User-Agent":"Cosmic-Energy-Live"};t=os.getenv("GITHUB_TOKEN")or os.getenv("GH_TOKEN");t and H.update(Authorization="Bearer "+t);G=lambda z:j.loads(u.urlopen(u.Request(z,headers=H),timeout=30).read());R=[];p=1
while 1:
 a=G(f"https://api.github.com/users/{q.quote(o)}/repos?type=public&per_page=100&page={p}");a=[r for r in a if not r.get("private")];R+=a
 if len(a)<100:break
 p+=1
M=[];X=[];tr=False
for r in R:
 try:
  z=G(f"https://api.github.com/repos/{r['"'"'full_name'"'"']}/git/trees/{q.quote(r['"'"'default_branch'"'"'],safe='"'"''"'"')}?recursive=1");tr|=bool(z.get("truncated"));M += [[r["full_name"],r["default_branch"],x["path"],x.get("size",0),x.get("sha","")]for x in z.get("tree",[])if x.get("type")=="blob"]
 except Exception as e:X.append([r.get("full_name"),type(e).__name__])
M.sort();b=j.dumps(M,separators=(",",":"),ensure_ascii=False).encode();E=lambda x:int.from_bytes(b"\1"+x,"big");D=lambda g:g.to_bytes((g.bit_length()+7)//8,"big")[1:];rv=D(E(b))==b;g=0
for x in b:g=(g*257+x+1)%1000000007
ok=rv and not tr and not X;print(j.dumps({"MODEL":"COSMIC_ENERGY_LIVE_GITHUB","OWNER":o,"REPOS":len(R),"BLOBS":len(M),"MANIFEST_BYTES":len(b),"COORD_MOD_1E9P7":g,"COORD_ONLY":True,"REV":rv,"TRUNCATED":tr,"ERRORS":X,"CORPUS_OK":ok},separators=(",",":"),sort_keys=True));sys.exit(0 if ok else 1)' "${1:-letsgo0226}"
