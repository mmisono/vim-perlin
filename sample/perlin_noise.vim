
let char = [
			\'!','"','#','$','%','&',"'",
			\'(',')','*','+',',','-','.','/',
			\'0','1','2','3','4','5','6','7',
			\'8','9',':',';','<','=','>','?',
			\'@','A','B','C','D','E','F','G',
			\'H','I','J','K','L','M','N','O',
			\'P','Q','R','S','T','U','V','W',
			\'X','Y','Z','[','\',']','^','_',
			\'`','a','b','c','d','e','f','g',
			\'h','i','j','k','l','m','n','o',
			\'p','q','r','s','t','u','v','w',
			\'x','y','z','{','|','}','~']

edit `='==perlin noise=='`
setl buftype=nowrite
setl noswapfile
setl bufhidden=wipe
setl nonumber

let perlin = perlin#perlin()

let buf = []
for i in range(50)
	call add(buf,[])
	for j in range(101)
		call add(buf[i],' ')
	endfor
endfor

for i in range(50)
	for j in range(100)
		let buf[i][j+1] = char[float2nr(((1+perlin.noise2(i/50.0*5,j/100.0*5))/2)*len(char))]
	endfor
	call setline(i+1,join(buf[i],""))
endfor

for i in range(len(char))
	let c = char[i]
	let name = 'Noise'.char2nr(c)
	let color = repeat(printf("%02x",float2nr((255.0/len(char))*i)),3)
	exe 'syntax match '.name.' "'.escape(c,'\[~^".*$').'"'
	exe 'highlight '.name.' guifg=#'.color
	exe 'highlight '.name.' guibg=#'.color
endfor



