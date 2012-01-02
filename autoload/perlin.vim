let s:save_cpo = &cpo
set cpo&vim
" ----------------------------------------------------------------------------

let s:Perlin = {'SIZE':256}

function! s:Perlin.new(...)
	let obj = deepcopy(self)
    if a:0 >= 1
        let obj.SIZE = a:1
	endif
	call obj.init()
	call remove(obj,"new")
	call remove(obj,"init")
    lockvar obj.SIZE
    lockvar obj.p
    lockvar obj.gx
    lockvar obj.gy
	return obj
endfunction

" lenear inter poration
function! s:Perlin.lerp(t,a,b)
	return a:a + a:t*(a:b - a:a)
endfunction

" smoothing function
function! s:Perlin.s_curve(t)
	return a:t*a:t*(3.0-2.0*a:t)
endfunction

function! s:Perlin.init()
	let self.p = []
	let self.gx = []
	let self.gy = []

	for i in range(self.SIZE)
		call add(self.p,i)
	endfor

	for i in range(self.SIZE)
		let j = random#randint(0,self.SIZE-1)
		let tmp = self.p[i]
		let self.p[i] = self.p[j]
		let self.p[j] = tmp
	endfor

	for i in range(self.SIZE)
		call add(self.gx,1 - 2*random#random())  " gx[i] = 1-2*random#random()
		call add(self.gy,1 - 2*random#random())  " gy[i] = 1-2*random#random()
	endfor
endfunction

function! s:Perlin.noise2(x,y)
	" the 4 grid points bounding (x,y)
	let qx0 = float2nr(floor(a:x))
	let qx1 = qx0 + 1
	let qy0 = float2nr(floor(a:y))
	let qy1 = qy0 + 1

	" index of gradient vectors
	let q00 = self.p[(qy0 + self.p[qx0 % self.SIZE]) % self.SIZE]
	let q01 = self.p[(qy0 + self.p[qx1 % self.SIZE]) % self.SIZE]
	let q10 = self.p[(qy1 + self.p[qx0 % self.SIZE]) % self.SIZE]
	let q11 = self.p[(qy1 + self.p[qx1 % self.SIZE]) % self.SIZE]

	" calculate vectors from the grid points to (x,y)
	let tx0 = a:x - floor(a:x)
	let tx1 = tx0 - 1
	let ty0 = a:y - floor(a:y)
	let ty1 = ty0 - 1

	" calculate influences from the grid points
	let v00 = self.gx[q00]*tx0 + self.gy[q00]*ty0
	let v01 = self.gx[q01]*tx1 + self.gy[q01]*ty0
	let v10 = self.gx[q10]*tx0 + self.gy[q10]*ty1
	let v11 = self.gx[q11]*tx1 + self.gy[q11]*ty1

	let wx = self.s_curve(tx0)
	let v0 = self.lerp(wx,v00,v01)
	let v1 = self.lerp(wx,v10,v11)
	let wy = self.s_curve(ty0)
	let v = self.lerp(wy,v0,v1)

	return v
endfunction

function! perlin#perlin(...)
	return call(s:Perlin.new,a:000,s:Perlin)
endfunction

" ----------------------------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
