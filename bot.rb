require 'nokogiri'
require 'httparty'
require 'byebug'
require 'down'

def rudiments
	puts "\e[H\e[2J"
	print "Qual tipo de rudimento quer aprender hoje? (rulos, paradiddles, flams)"
	tipo = gets.chomp

	url = "https://www.drumeo.com/beat/rudiments/"

	if tipo == "rulos"
		url = "https://www.drumeo.com/beat/rudiments/rolls/"
	elsif tipo == "paradiddles"
		url = "https://www.drumeo.com/beat/rudiments/paradiddles/"
	elsif tipo == "flams"
		url = "https://www.drumeo.com/beat/rudiments/flams/"
	end

	nao_analisada = HTTParty.get(url)
	analisada = Nokogiri::HTML(nao_analisada)

	if tipo == "rulos"
		rudimentos = analisada.css('a.post-tile.Rolls')
	elsif tipo == "paradiddles"
		rudimentos = analisada.css('a.post-tile.Paradiddles')
	elsif tipo == "flams"
		rudimentos = analisada.css('a.post-tile.Flams')
	end

	$random = []
	rudimentos.each {|exercicio|
		nome = exercicio.css('p.text-wrap').text
		urlimagem = exercicio.css('img.show-for-medium')[0].attributes['src'].text
		$random.push([nome,urlimagem])
	}
end


rudiments

index_rand= rand($random.length-1)
print(index_rand)
puts "\e[H\e[2J"
puts "O exercício que irá fazer hoje é o "+$random[index_rand][0]
puts $random[index_rand][1]
temp_img = Down.download($random[index_rand][1], destination:"exercicio.jpg")
