require 'nokogiri'
require 'httparty'
require 'byebug'
require 'down'

url = "https://www.drumeo.com/beat/rudiments/"	#passo a url da página numa variável

def rudimentos	#declaro a função
	puts "\e[H\e[2J"	#clear no terminal
	print "Qual tipo de rudimento quer aprender hoje? (rulos, paradiddles, flams) "
	tipo = gets.chomp	#capturo o tipo de rudimento o usuário quer aprender

	if tipo == "rulos"	#adiciono o tipo de rudimento na url dependendo do input do usuário
		url += "rolls/"	
	elsif tipo == "paradiddles"
		url += "paradiddles/"
	elsif tipo == "flams"
		url += "flams/"
	end

	unparsed = HTTParty.get(url)	#utilizando HTTParty para capturar a unparsed_page
	parsed = Nokogiri::HTML(unparsed)	#utilizando Nokogiri para analisar o HTML da página (parsed_page)

	if tipo == "rulos"
		rudimentos = parsed.css('a.post-tile.Rolls')	#capturo num array a todos os exercicios do tipo escolhido
	elsif tipo == "paradiddles"
		rudimentos = parsed.css('a.post-tile.Paradiddles')
	elsif tipo == "flams"
		rudimentos = parsed.css('a.post-tile.Flams')
	end

	$random = []	#declaro meu array de exercicios
	rudimentos.each {|exercicio|	#utilizando um .each, percorro cada exercicio do array rudimentos
		nome = exercicio.css('p.text-wrap').text 	#armazendo o nome e url da imagem no array $random
		urlimagem = exercicio.css('img.show-for-medium')[0].attributes['src'].text
		$random.push([nome,urlimagem])	#array multidimensional que armazena o nome e url da imagem
	}
end


rudiments()	#executa a função

index_rand= rand($random.length-1)	#armazeno um index aleatório do array de exercícios $random

puts "\e[H\e[2J"	#clear no terminal
puts "O exercício que irá fazer hoje é o "+$random[index_rand][0]	#printo o exercício que o usuário irá fazer
puts $random[index_rand][1]		#printo a url da imagem
temp_img = Down.download($random[index_rand][1], destination:"exercicio.jpg")	#faço o download de um arquivo temporário da imagem na pasta do bot e armazeno com o nome "exercicio"

#o usuário poderá escolher abrir a imagem baixada no próprio computador ou abrir a url no navegador