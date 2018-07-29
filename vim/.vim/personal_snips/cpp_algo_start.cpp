#include <bits/stdc++.h>

#define mod 1000000007LL
#define inf(T) std::numeric_limits<T>::max()
#define ninf(T) std::numeric_limits<T>::min()
#define eps 1e-9
#define all(x) x.begin(),x.end()
#define mp(x,y) std::make_pair(x,y)
#define mem(a,val) memset(a,val,sizeof(a))
#define eb emplace_back
#define f first
#define s second
#define endl "\n"
#define _for(i, a, b)   for(int i=(a) ;i<(b) ;i++)
#define _fore(i, a, b)  for(int i=(a) ;i<=(b) ;i++)
#define _forr(i, a, b)  for(int i=(a) ;i>(b) ;i--)
#define _forre(i, a, b) for(int i=(a) ;i>=(b) ;i--)
#define sf              scanf
#define pf              printf
#define sf1(a)          scanf("%d",&a)
#define sf2(a,b)        scanf("%d %d",&a,&b)
#define sf3(a,b,c)      scanf("%d %d %d",&a,&b,&c)
#define sf4(a,b,c,d)    scanf("%d %d %d %d",&a,&b,&c,&d)
#define sf1ll(a)        scanf("%I64d",&a)
#define sf2ll(a,b)      scanf("%I64d %I64d",&a,&b)
#define sf3ll(a,b,c)    scanf("%I64d %I64d %I64d",&a,&b,&c)
#define sf4ll(a,b,c, d) scanf("%I64d %I64d %I64d %I64d",&a,&b,&c,&d)
#define par(i) (i-1) >> 1
#define lt(i) i<<1 + 1
#define rt(i) i<<1 + 2

using ll=int64_t;
using ull=uint64_t;
using vi=std::vector<int>;
using vl=std::vector<int64_t>;
using vvi=std::vector<vi>;
using vvl=std::vector<vl>;
using vs=std::vector<std::string>;
using mii=std::map<int, int>;
using mll=std::map<int64_t, int64_t>;
using msi=std::map<std::string, int>;
using msl=std::map<std::string, int64_t>;
using pii=std::pair<int, int>;
using pll=std::pair<int64_t, int64_t>;
using vpii=std::vector<pii>;
using vpll=std::vector<pll>;
using namespace std;

inline bool eq(double a, double b) { return fabs(a-b) < 1e-9; }

//fast io <++>

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(0);

  #ifdef fio
    freopen("<++>","r" ,stdin ) ;
    //freopen("<++>","w" ,stdout ) ;
    std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
    start = std::chrono::high_resolution_clock::now();
  #endif

  int t;
  cin>>t;
  while(t--) {
    // code here... <++>
  }

  #ifdef fio
    fprintf(stdout,"\nTIME: %.3lf sec\n", (double)clock()/(CLOCKS_PER_SEC));
    end = std::chrono::high_resolution_clock::now();
    ll elapsed_time = std::chrono::duration_cast<std::chrono::milliseconds>(end-start).count();
    cout << "\nElapsed Time: " << elapsed_time << "ms\n";
  #endif
  return 0;
}
