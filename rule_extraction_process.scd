//-----------------------------------------------------------------
//
//          script for the rule extraction process
//
//
//-----------------------------------------------------------------


//   Read previous session (load data)
//~data = Object.readArchive("/Users/tuno/Documents/tuno/artificial_intelligence/monthbymonth/2016march/blip_rule_analysis/session");



//-----------------------------------------------------
//
//        load compression functions
//
loadRelative("uncompleted_compression_workshop.scd")
//
//-----------------------------------------------------




//--------------------------------------------------------
//
//     Rule extraction process
//
//--------------------------------------------------------



~data.size
~data.do{|x,i| x.postln}  // Check data if needed


~cleanedData = ~cleanDataForCompression.value(~data) ; //Clean data




~acceptableDifference = [ 20, 1000, 0.5]; //distancia parametro a parametro


~classes = ~countClasses.value(~cleanedData);//cuanta cuantos valores tango en cada parámetro


~rules = ~uncompletedClassesCompression.value(~cleanedData,~classes);
~rules.do{|x| x.size.postln; x.do{|y| y.postln}}

-----------------------------------------------------------
~bag = ~bagOfRules_uncompleted.value(~rules)

~bag[1].do{ |x| x.postln}
~bag.do{ |x| x.do{|y| y.postln}}



~second = ~uncompletedClassesCompression.value(~bag[0],~classes);
~second_bag = ~bagOfRules_uncompleted.value(~second);
~second_bag[1]
~second_bag[0].do{|x,i|   [i,x].postln}


//-------------------------------------------
//-------------------------------------------
//simple unification function
(
~unify = { |rules|
	var unifiedRules;
	var temporalData = rules.deepCopy;
	var size, columns;
	size = rules[0].size;
	columns = (0 .. size - 2);
	columns.collect{|colToExclude|
		var section, selection, subsets;
		var newRule;
		section = (0..size-2).removing(colToExclude);
		subsets = temporalData.slice(nil, section);
		selection = temporalData.slice(nil, colToExclude);
		subsets.do { |x, i|
			var parameterValues = [ ];
			var indexesOfParameterValues = [ ];
			var count = 0;
			subsets.do{ |y, j |
				count = count + 1;
				if(x==y) {
					if(temporalData.at(j).notNil){
						if(temporalData[j][colToExclude].class==Array){
							temporalData[j][colToExclude].do{|x|
								if(parameterValues.indexOfEqual(x).isNil){
									parameterValues = parameterValues.add(x)};
							};
						};//{parameterValues = parameterValues.add(temporalData[j][colToExclude])};
					indexesOfParameterValues = indexesOfParameterValues.add(j);
				}};
			};
			if(count == rules.size){count = 0;

				if(indexesOfParameterValues.size>1){
					parameterValues.postln;
					indexesOfParameterValues.postln;
					newRule = temporalData[indexesOfParameterValues[0]];

					newRule[colToExclude] = parameterValues;
					//'newRule:  '.post;newRule.postln;
					temporalData = temporalData.add(newRule);
					indexesOfParameterValues.do{|x| temporalData[x]=nil};
				};
			};
		}
	};
	unifiedRules = unifiedRules.add(temporalData);
	unifiedRules = unifiedRules.collect{|x| x.reject(_.isNil)};
	unifiedRules  = unifiedRules.unbubble(0,1);
	unifiedRules;
}
)
//-------------------------------------------
//-------------------------------------------

~unifiedRules = ~unify.value(~second_bag[0])
~unifiedRules.do{|x, i | [i,x].postln}


//~split = ~splitRules_uncompleted.value(~unifiedRules)
//~split.do{|x| x.do{|y,j| [j,y].postln}}
-----------------------------------------------------------



//----------------------------------------------------------------------------
///  save session function
//  write data
a = ~data.writeArchive("/Users/tuno/Documents/tuno/artificial_intelligence/monthbymonth/2016march/blip_rule_analysis/session");

//read session
//~data =
b = Object.readArchive("/Users/tuno/Documents/tuno/artificial_intelligence/monthbymonth/2016march/blip_rule_analysis/session");
//----------------------------------------------------------------------------





~bag[1].do{ |x| x.postln}

//---------------------------------------------------
//---------------------------------------------------
(
~maxParametersRange = {|array|
	var max, min, size, column, difference, range = [];
	size = (0 .. array[0].size - 2);
	size.do{|col|
		column = array.slice(nil, col);
		//column.postln;
		min = column.minItem;
		max = column.maxItem;
		difference = max-min;
		range = range.add(difference);
	};
	range
}
)
//---------------------------------------------------
//---------------------------------------------------
(
~acceptableDifference = ~maxParametersRange.value(~cleanedData);

~compression_discontinuous = ~uncompletedClassesCompression.value(~bag[1],~classes);
)

~compression_discontinuous.do{|x| x.do{|y| y.postln}}

~discontinuous_bag = ~bagOfRules_uncompleted.value(~compression_discontinuous)


~discontinuous_bag[0].do{|x| x.postln}


~discontinuous_bag[1].do{|x| x.postln}







///
~compresion = ~uncompletedClassesCompression.value(~cleanedData, ~classes)
~bolsa = ~bagOfRules_uncompleted.value(~compresion)
~bolsa[0].size
~bolsa[0].do{|x| x.postln}

~unificadas = ~unify.value(~bolsa[0])


~bolsa2 = ~bagOfRules_uncompleted.value(~unificadas)

~bolsa2.do{|x| x.postln}




























//second
//  starting from the rules in the first compression
//---------------------------------------------------
//---------------------------------------------------
(
~slotRange = {|array|
	var max, min, size, column, difference, range = [];
	size = (0 .. array[0].size - 2);
	size.do{|col|
		column = array.slice(nil, col);
		//column.postln;
		min = column.minItem;
		max = column.maxItem;
		difference = max-min;
		range = range.add(difference);
	};
	range
}
)
//---------------------------------------------------
//---------------------------------------------------
(
~sac = { |rules|
	var bag = [];
	rules.do{ |x|
		x.do{ |y|
			if(bag.indexOfEqual(y).isNil){bag = bag.add(y)};
		}
	};
	bag
}
);
//---------------------------------------------------
//---------------------------------------------------

~mixBag = ~sac.value(~rules)
~mixBag.size
(
~acceptableDifference = ~slotRange.value(~cleanedData);
~compression_discontinuous = ~uncompletedClassesCompression.value(~mixBag,~classes);
)
~bag = ~bagOfRules_uncompleted.value(~compression_discontinuous)
~bag.do{|x| x.postln}
~bag.size
~split = ~splitRules_uncompleted.value(~bag)
~split.do{|x|  x.size.postln; x.do{|y| y.postln}}



Ndef(\x).play
//class rule
~selectRandomRule.value(~split,2, rrand(0,20))
Ndef(\x).stop






