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

void constrWords(int[] m,int level, int mlen, mob_matrix[] mm, pen[] colors, pair[] z,int j, pair[] oldp, mob_matrix u) {
     int i,k,l; pair tmp,tmp1,tmp2;
     for(k = 1; k < 5;++k) { i = m.pop();
	   if(i == (k%4))  { m.push((int)k%4); u = mult(u,mm[(k-1)%4]);
		tmp1 = z[(j-2)%4]; tmp2 = z[j%4];
        z[(j-2)%4] = TxPoint(u,z[(j-2)%4]); z[j%4] = TxPoint(u,z[j%4]);
        tmp = oldp.pop();
        if(fabs(tmp.x) > 10.^(-7) && fabs(tmp.y) > 10.^(-7) && dist(tmp,z[(j-2)%4])<0.0001) { draw(tmp--z[(j-2)%4],colors[rand()%colors.length]);
        oldp.push(z[j%4]); 
        z[(j-2)%4] = tmp1; z[j%4] = tmp2;
        } else { oldp.push(z[j%4]);  
        z[(j-2)%4] = tmp1; z[j%4] = tmp2;
		if(level < mlen) { ++level;
			m.push((int) (k-1)%4); constrWords(m,level,mlen,mm,colors,z,j,oldp,u);
			m.push((int)(k)%4); constrWords(m,level,mlen,mm,colors,z,j,oldp,u);
			m.push((int)(k+1)%4); constrWords(m,level,mlen,mm,colors,z,j,oldp,u);
		  }
         }
	    } else m.push(i);
    } i = m.pop();
    u = mult(u,mm[(i+1)%4]);
}

size(10cm);
real p = 0.5; real q = 0.9;
real c = sqrt(1+p^2); real d = sqrt(1+q^2);
real k = (1 + sqrt(1-p^2*q^2))/(p*q);
int i; 
int j;
int[] m;
circle[] circ;
mob_matrix[] mm;
pair[] z;
pair[] oldp;
pen[] pens = {red+0.35,blue+0.35,green+0.35,cyan+0.35,magenta+0.35,yellow+0.35};
circle C_B = circle((-c/p,0),1/p);
circle C_a = circle((0,k*d/q),k/q);
circle C_A = circle((0,-k*d/q),k/q);
circle C_b = circle((c/p,0),1/p);
//real[] centas; //real[] radiuses;
mob_matrix a = mob_matrix((d,0),(0,k*q),(0,(-1)*q/k),(d,0));
mob_matrix b = mob_matrix((c,0),(p,0),(p,0),(c,0));
mob_matrix A = mob_matrix((d,0),(0,(-1)*k*q),(0,q/k),(d,0));
mob_matrix B = mob_matrix((c,0),((-1)*p,0),((-1)*p,0),(c,0));
mob_matrix tr = mob_matrix((1,0),(0,0),(0,0),(1,0));
oldp.push((0,0));

mm.push(a); mm.push(b); mm.push(A); mm.push(B);
mob_matrix c1 = mm[0]; mob_matrix c2 = mm[1]; mob_matrix c3 = mm[2]; mob_matrix c4 = mm[3];
for(i=0;i<3;++i) { c1 = mult(c1,mm[i+1]); c2 = mult(c2,mm[(i+2)%4]); c3 = mult(c3,mm[(i+3)%4]); c4 = mult(c4,mm[i%4]); }
z.push(Fix(c1)); z.push(Fix(c2)); z.push(Fix(c3)); z.push(Fix(c4)); 
for(i=1; i<5;++i) { m.push((int)i%4); constrWords(m,1,N_ITER,mm,pens,z,(int)i%4,oldp,tr); } 
