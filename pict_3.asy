import math;
import settings;
outformat = "pdf";
//==NUMBER OF LEVELS==
int N_ITER = 13;
//====================
struct circle { 
    pair C; 
    real r;
    int id;
    void operator init(pair p, real R, int i) {
    this.C=p;
    this.r=R;
    this.id=i;
    }
}

struct mob_matrix { pair a; pair b; pair c; pair d; 
    void operator init(pair A, pair B,pair C,pair D) {
    this.a=A;
    this.b=B;
    this.c=C;
    this.d=D;
    }
}

mob_matrix mult(mob_matrix A, mob_matrix B) { 
    return (mob_matrix(A.a*B.a+A.b*B.c, A.a*B.b+A.b*B.d, A.c*B.a+A.d*B.c, A.c*B.b+A.d*B.d));
}

real cxabs(pair z) { return sqrt(z.x*z.x+z.y*z.y); }

pair TxPoint(mob_matrix T, pair p) { return (T.a*p + T.b)/(T.c*p+T.d); }

circle TxCirc(mob_matrix T, circle c) {
    circle res;
    pair z; pair w;
    if(c.id == 0) {
    z=c.C-(c.r^2,0)/conj(T.d/T.c+c.C);
    res.C=TxPoint(T,z);
    res.r=cxabs(res.C-TxPoint(T,c.C+c.r));
    res.id=0;
    }
    if(c.id == 1) {
       z = -T.d/T.c+2*(c.r-((c.C).x*((-T.d/T.c).x)+((c.C).y)*((-T.d/T.c).y)))*c.C;
       w = -T.d/T.c+(c.r-((c.C).x*((-T.d/T.c).x)+((c.C).y)*((-T.d/T.c).y)))*c.C;
       res.C = TxPoint(T,z);
       res.r = cxabs(res.C-TxPoint(T,w));
       res.id = 0; 
    }
    return res;
}

void constrWords(int[] m,int level, int mlen, mob_matrix[] mm, pen[] colors, circle[] circ,int j) {
     int i,k; 
     for(k = 1; k < 5;++k) { i = m.pop();
	   if(i == (k%4))  { 
	   m.push((int)k%4);
        for(i=j;i<j+3;++i) { circ[i%4] = TxCirc(mm[(k-1)%4],circ[i%4]); 
        if(circ[i%4].r > (real)10^(-3))  draw(shift(circ[i%4].C)*scale(circ[i%4].r)*unitcircle,colors[level%colors.length]+(real)10^(-level)); 
        } if(level < mlen) { ++level;
		if(k%2 == 1) {
			m.push((int) (k-2)%4); constrWords(m,level,mlen,mm,colors,circ,j);
			m.push((int) (k-1)%4); constrWords(m,level,mlen,mm,colors,circ,j);
			m.push((int)(k)%4); constrWords(m,level,mlen,mm,colors,circ,j);
		 } else {
		   m.push((int) (k)%4); constrWords(m,level,mlen,mm,colors,circ,j);
			m.push((int) (k+1)%4); constrWords(m,level,mlen,mm,colors,circ,j);
			m.push((int)(k+2)%4); constrWords(m,level,mlen,mm,colors,circ,j); 
			}
		 }
        } else m.push(i);
    } i = m.pop();
    for(k = j;k < j+3; ++k) { if(i%2 == 1) circ[k%4] = TxCirc(mm[i%4],circ[k%4]); else circ[k%4] = TxCirc(mm[(i+2)%4],circ[k%4]); }
}

size(10cm);
int i; 
int j;
int[] m;
circle[] circ;
mob_matrix[] mm;
pen[] colors = {red,blue,green,cyan,magenta,yellow};
circle C_B = circle((-1,-1),1,0);
circle C_a = circle((0,1),0,1);
circle C_A = circle((0,-0.25),0.25,0);
circle C_b = circle((1,-1),1,0);
//real[] centas; //real[] radiuses;
mob_matrix a = mob_matrix((1,0),(0,0),(0,(-2)),(1,0));
mob_matrix b = mob_matrix((1,-1),(1,0),(1,0),(1,1));
mob_matrix A = mob_matrix((1,0),(0,0),(0,2),(1,0));
mob_matrix B = mob_matrix((1,1),((-1),0),((-1),0),(1,-1));

draw(shift(C_B.C)*scale(C_B.r)*unitcircle,red);
draw((-2,0)--(2,0),red);
draw(shift(C_A.C)*scale(C_A.r)*unitcircle,red);
draw(shift(C_b.C)*scale(C_b.r)*unitcircle,red);
mm.push(A); mm.push(a); mm.push(B); mm.push(b); 
for(i=1; i<5; ++i) { m.push((int)i%4); circ.push(C_a); circ.push(C_A); circ.push(C_b); circ.push(C_B); constrWords(m,1,N_ITER,mm,colors,circ,(int)i%4); circ.pop(); circ.pop(); circ.pop(); circ.pop();  }
