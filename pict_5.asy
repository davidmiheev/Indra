import math;
import settings;
outformat = "pdf";
//==NUMBER OF LEVELS==
int N_ITER = 500;
//====================
struct circle { 
    pair C; 
    real r; 
    void operator init(pair p, real R) {
    this.C=p;
    this.r=R;
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
real dist(pair p, pair q) {
    return sqrt((p.x-q.x)^2+(p.y-p.y)^2);
}
real cxabs(pair z) { return sqrt(z.x*z.x+z.y*z.y); }

pair TxPoint(mob_matrix T, pair p) { return (T.a*p + T.b)/(T.c*p+T.d); }

circle TxCirc(mob_matrix T, circle c) {
    circle res;
    pair z;
    z=c.C-(c.r^2,0)/conj(T.d/T.c+c.C);
    res.C=TxPoint(T,z);
    res.r=cxabs(res.C-TxPoint(T,c.C+c.r));
    return res;
}

pair Fix(mob_matrix T) {
	if(cxabs(((T.a+T.d+sqrt((T.a+T.d)^2-4))/2)^2)>1)
	return (T.a-T.d+sqrt((T.a+T.d)^2-4))/2*T.c;
	else return (T.a-T.d-sqrt((T.a+T.d)^2-4))/2*T.c;
}

void constrWords(int[] m,int level, int mlen, mob_matrix[] mm, pen[] colors, pair[] z, mob_matrix u) {
     int i,k,l,s;  pair[] tmp1;
     for(k = 1; k < 5;++k) { i = m.pop();
	   if(i == (k%4))  {
		m.push((int)k%4); u = mult(u,mm[(k-1)%4]);
		    for(i = 0; i < 12; ++i) tmp1.push(z[i]); 
            for(s=3*(k-1)%4;s < 3*(k-1)%4 + 3;++s) z[s] = TxPoint(u,z[s]);
            if((dist(z[3*(k-1)%4],z[3*(k-1)%4 + 1]) < 0.0001 && dist(z[3*(k-1)%4+1],z[3*(k-1)%4 + 2]) < 0.0001)) { 
              for(s=3*(k-1)%4;s < 3*(k-1)%4 + 2;++s) draw(z[s]--z[s+1],colors[rand()%colors.length]);  
              for(i = 11; i > -1; --i) z[i] = tmp1.pop(); 
              } else {
            for(i = 11; i > -1; --i) z[i] = tmp1.pop();
            if(level < mlen) { ++level;
            if(k%2 == 1) {
			m.push((int) (k-2)%4); constrWords(m,level,mlen,mm,colors,z,u);
			m.push((int)(k-1)%4); constrWords(m,level,mlen,mm,colors,z,u);
			m.push((int)(k)%4); constrWords(m,level,mlen,mm,colors,z,u);
          }
          else {
            m.push((int) (k)%4); constrWords(m,level,mlen,mm,colors,z,u);
			m.push((int)(k+1)%4); constrWords(m,level,mlen,mm,colors,z,u);
			m.push((int)(k+2)%4); constrWords(m,level,mlen,mm,colors,z,u);
         }
		}
       } 
    } else m.push(i);
    } i = m.pop();
    if(i%2 == 1) u = mult(u,mm[i%4]); else u = mult(u,mm[(i+2)%4]);
}

size(10cm); 
int i; 
int j;
int[] m;
circle[] circ;
mob_matrix[] mm;
mob_matrix[] c; mob_matrix[] d;
pen[] pens = {red+0.25,blue+0.25,green+0.25,cyan+0.25,magenta+0.25,yellow+0.25};
pair[] z;
//real[] centas; //real[] radiuses;
mob_matrix a = mob_matrix((1,0),(0,0),(0,(-2)),(1,0));
mob_matrix b = mob_matrix((1,-1),(1,0),(1,0),(1,1));
mob_matrix A = mob_matrix((1,0),(0,0),(0,2),(1,0));
mob_matrix B = mob_matrix((1,1),((-1),0),((-1),0),(1,-1));
mob_matrix tr = mob_matrix((1,0),(0,0),(0,0),(1,0));

mm.push(A); mm.push(a); mm.push(B); mm.push(b); 
c.push(a); c.push(b); c.push(A); c.push(B); d.push(a); d.push(B); d.push(A); d.push(b); 
mob_matrix c1 = a; mob_matrix c2 = b; mob_matrix c3 = A; mob_matrix c4 = B; mob_matrix d1 = a; mob_matrix d2 = B; mob_matrix d3 = A; mob_matrix d4 = b;
for(i=0;i<3;++i) { c1 = mult(c1,c[i+1]); c2 = mult(c2,c[(i+2)%4]); c3 = mult(c3,c[(i+3)%4]); c4 = mult(c4,c[i%4]); }
for(i=0;i<3;++i) { d1 = mult(d1,d[i+1]); d2 = mult(d2,d[(i+2)%4]); d3 = mult(d3,d[(i+3)%4]); d4 = mult(d4,d[i%4]); }
z.push(Fix(c2)); z.push(Fix(a)); z.push(Fix(d2)); z.push(Fix(c3)); z.push(Fix(b)); z.push(Fix(d1)); z.push(Fix(c4)); z.push(Fix(A));  z.push(Fix(d4)); z.push(Fix(c1));  z.push(Fix(B));  z.push(Fix(d3));
for(i=1; i<5;++i) { m.push((int)i%4); constrWords(m,1,N_ITER,mm,pens,z,tr); } 
