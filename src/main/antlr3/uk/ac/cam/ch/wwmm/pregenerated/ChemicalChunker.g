grammar ChemicalChunker;

options {
    language=Java;
    output = AST;
   backtrack= true;
   memoize = true;
}
tokens{
Sentence;
Unmatched;
NounPhrase;
MultipleApparatus;
DissolvePhrase;
VerbPhrase;
CYCLES;
RATIO;
CITATION;
MIXTURE;
PrepPhrase;
TimePhrase;
RolePrepPhrase;
AtmospherePhrase;
TempPhrase;
AMOUNT;
MASS;
PERCENT;
VOLUME;
MOLAR;
YIELD;
APPARATUS;
MULTIPLE;
OSCARCM;
MOLECULE;
UNNAMEDMOLECULE;
QUANTITY;
OSCARONT;
}


@header {
    package uk.ac.cam.ch.wwmm.pregenerated;
 }
@lexer::header {package uk.ac.cam.ch.wwmm.pregenerated;}

WS :  (' ')+ {skip();};
TOKEN : (~' ')+;



document: sentences+-> ^(Sentence  sentences )+ ;

sentences:  (sentenceStructure|unmatchedPhrase)+ stop*;

sentenceStructure:  (nounphrase|verbphrase|prepphrase|prepphraseAfter)+ (advAdj|colon)* (conjunction|rbconj|comma)*;

unmatchedPhrase
	:	 unmatchedToken -> ^(Unmatched unmatchedToken);

unmatchedToken //all base tokens other than comma and stop
	:	(number|advAdj|tmunicode|cdunicode|jjcomp|inAll|
	nnexample|nnstate|nntime|nnmass|nnmolar|nnamount|nnatmosphere|nneq|nnvol|nnchementity|nntemp|nnflash|nngeneral|nnmethod|nnpressure|nncolumn|nnchromatography|nnvacuum|nncycle|nntimes|
	oscarcm|oscaronts|oscarase|verb|nnadd|nnmixture|nnapparatus|nnconcentrate|nndry|nnextract|nnfilter|nnprecipitate|nnpurify|nnremove|nnsynthesize|nnyield|colon|apost|neg|dash|nnpercent|lsqb|rsqb|lrb|rrb|
	cc|dt|dtTHE|fw|md|nn|nns|nnp|prp|prp_poss|rbconj|sym|uh|clause|comma|ls|nnps|pos);

nounphrase
	:	nounphraseStructure ->  ^(NounPhrase  nounphraseStructure);

nounphraseStructure
	:	nounphraseStructure1|nounphraseStructure2;
nounphraseStructure1
	:	 multiApparatus ->  ^(MultipleApparatus multiApparatus);
nounphraseStructure2
	:	dtTHE? dt? advAdj*  (dissolvePhrase|ratio|noun|number)+    (conjunction* advAdj* (dissolvePhrase|ratio|noun|number) )*   ((prepphraseOf| prepphraseIN) dissolvePhrase?)*  ;
dissolvePhrase
	:	(dissolveStructure|lrb dissolveStructure rrb) ->  ^(DissolvePhrase lrb? dissolveStructure rrb?);

dissolveStructure
	:	adj? (nnp (molecule|unnamedmolecule|nnchementity) | (molecule|unnamedmolecule)) (inin dtTHE? adj? nnp? (molecule|unnamedmolecule) (conjunction molecule)*)+ ;


verbphrase
	:	verbphraseStructure ->  ^(VerbPhrase  verbphraseStructure);
verbphraseStructure :  dt? to? inAll? inafter? (md* rbconj? adv* adj? verb+ md* adv* adj? neg? )+ inoff? (cc? comma? prepphrase)*   ;
verb : vb|vbp|vbg|vbd|vbz|vbn|vbuse|vbsubmerge|vbimmerse|degassMultiVerb|vbsubject|vbadd|vbdilute|vbcharge|vbcontain|vbdrop|vbfill|vbsuspend|vbtreat|vbapparatus|vbconcentrate|vbcool|vbdegass|vbdissolve|vbdry|vbextract|vbfilter |vbheat|vbincrease|vbpartition|vbprecipitate|vbpurify|vbquench|vbrecover|vbremove|vbstir|vbsynthesize|vbwait|vbwash|vbyield|vbchange;

degassMultiVerb
	:	vbdegass cc vbfill;

noun 	:	nounStructure (dash nounStructure)*;

nounStructure :  prp|prp_poss|citation|cycles|molecule|apparatus|mixture|unnamedmolecule|nnyield|nnstate|nn|nns|nnp|nnadd|preparationphrase|nnexample|range|amount|oscaronts|nntime|nnatmosphere|tmunicode|nneq|quantity|nnchementity|measurements|nntemp|nnflash|nngeneral|nnmethod|nnamount|nnpressure|nncolumn|nnchromatography|nnvacuum|nncycle|nntimes|nnconcentrate|nnvol|nnpurify|nnsynthesize|nnmixture|reference|nndry|number|oscarCompound|nnextract|nnfilter|nnprecipitate|nnremove|fw|sym|clause|ls|nnps|pos|oscarase;

// Different PrepPhrases

prepphrase
	: 	neg? (prepphraseAtmosphere|prepphraseTime|prepphraseTemp|prepphraseIN|prepphraseRole|prepphraseOther)  ;

prepphraseAtmosphere
	: prepphraseAtmosphereContent ->  ^(AtmospherePhrase  prepphraseAtmosphereContent ) ;

prepphraseAtmosphereContent
	:inunder  dt? advAdj* molecule nnatmosphere?	;

prepphraseTime
	:prepPhraseTimeStructure ->  ^(TimePhrase  prepPhraseTimeStructure);

prepPhraseTimeStructure
	:advAdj* inAll?  dt? advAdj* cd? nntime+	;

prepphraseTemp:  prepphraseTempContent ->  ^(TempPhrase   prepphraseTempContent);

prepphraseTempContent
	:  advAdj? inAll? dt? advAdj? cd? nntemp+;

prepphraseIN
	:inin molecule ->  ^(PrepPhrase  inin  molecule);

prepphraseRole
	:inas dt? nnchementity ->	^(RolePrepPhrase  inas dt? nnchementity);

prepphraseOther
	: advAdj* inMost+  nounphrase ->  ^(PrepPhrase  advAdj* inMost+  nounphrase);

prepphraseOf
	: inof  nounphrase->  ^(PrepPhrase  inof  nounphrase);

prepphraseAfter
	:  advAdj? inafter  nounphrase ->  ^(PrepPhrase  advAdj* inafter  nounphrase);

preparationphrase
	: vbsynthesize inas (nnexample cd| prepphrase)	;

multiApparatus
	:	apparatus (conjunction* apparatus )*;
apparatus
	:	dt? preapparatus* nnApp+-> ^(APPARATUS   dt? preapparatus* nnApp+ );

nnApp
	:	nnapparatus+ (dash nnapparatus)*;
preapparatus
	:    (quantity|adj|nnpressure|nnadd|molecule|nnchementity|nnstate|nn)+ ;

// The RRB at the end is for leftover brackets from chemicals that didn't parse properly
oscaronts
	: oscaront+ -> ^(OSCARONT   oscaront+);
oscarCompound :  adj* (oscarCompound1|oscarCompound2|oscarCompound3|oscarCompound4|oscarcm) adj? reference?;

oscarCompound4 :	lrb  oscarcm rrb -> ^(OSCARCM  lrb  oscarcm  rrb );
oscarCompound3 :	oscarCompound3Structure -> ^(OSCARCM   oscarCompound3Structure );
oscarCompound2 :	oscarCompound2Structure -> ^(OSCARCM   oscarCompound2Structure );
oscarCompound1 :	oscarcm oscarcm+ -> ^(OSCARCM  oscarcm oscarcm+);

oscarCompound3Structure
	:  oscarcm (dash|apost)+;
oscarCompound2Structure
	:  oscarcm (dash oscarcm)+  dash?;

molecule
	:  moleculeamount-> ^(MOLECULE  moleculeamount );

moleculeamount : moleculeamount3|moleculeamount1 | moleculeamount2 ;

moleculeamount3
	:(quantity|mixture) inof mixtureRatio mixture? oscarCompound ;

moleculeamount1
	:(quantity|mixture)+ inof quantity? inof? oscarCompound mixture?;

moleculeamount2
	:(quantity|mixture)* oscarCompound+  ((cdAlphanumType|number)quantity+)?(citation|quantity|mixture)* ;

unnamedmolecule
	: unnamedmoleculeamount -> ^(UNNAMEDMOLECULE unnamedmoleculeamount);

unnamedmoleculeamount
	:(unnamedmoleculeamount5|unnamedmoleculeamount1 | unnamedmoleculeamount2 | unnamedmoleculeamount3|unnamedmoleculeamount4) ;

unnamedmoleculeamount5	:
          jjcomp nnchementity cdAlphanum? (quantity|mixture)* ;

unnamedmoleculeamount1
	: quantity inof (cdAlphanum|cd);

unnamedmoleculeamount2
	:(cdAlphanum|cdAlphanumType) (citation|quantity|mixture)*;

unnamedmoleculeamount3
	:quantity inof (jj? noun)+;

unnamedmoleculeamount4
	:(quantity|mixture) nnchementity;

quantity 	:  (quantity1|quantity2) ->   ^(QUANTITY  quantity1? quantity2?);

quantity1
	: lrb measurements (comma  measurements)* (comma preparationphrase)* (stop preparationphrase)*  rrb;

quantity2
	:  measurements (comma  measurements)*  ;

measurements
	:(cd nn)? (multiple|measurementtypes)    dt?;
multiple	: cd cdunicode measurementtypes? -> ^(MULTIPLE   cd cdunicode measurementtypes? );
measurementtypes
	: molar|amount|mass|volume|yield|percent;

molar	: cd* nnmolar -> ^(MOLAR   cd* nnmolar );
amount	: cd+ nnamount -> ^(AMOUNT   cd+ nnamount );
mass	: cd+ nnmass-> ^(MASS   cd+ nnmass );
volume	: cd+ nnvol -> ^(VOLUME   cd+ nnvol );
yield: percent nnyield -> ^(YIELD percent nnyield );
percent	: number nn? nnpercent -> ^(PERCENT   number nn? nnpercent );

mixture: mixtureRatio?  (mixtureStructure3|mixtureStructure2|mixtureStructure1) -> ^(MIXTURE   mixtureRatio? mixtureStructure3? mixtureStructure2? mixtureStructure1?);
mixtureStructure2: comma lrb mixtureContent rrb comma;
mixtureStructure1: lrb mixtureContent rrb;
mixtureStructure3
	:	lrb  nnpercent rrb;

mixtureRatio
	:	cd colon (cd|cdAlphanum);
mixtureContent:   (fw|verb|nn|measurements|md|nnpercent|stop|oscarCompound|molecule|unnamedmolecule|dash|sym|cd|noun|inAll|cd|comma|adj|colon|stop) (minimixture|fw|verb|measurements|nnyield|md|nnpercent|stop|oscarCompound|molecule|unnamedmolecule|dash|sym|cd|noun|inAll|cd|comma|adj|colon|stop)+ ;

minimixture: (mixtureStructure2|mixtureStructure1) -> ^(MIXTURE  mixtureStructure2? mixtureStructure1?);
//TODO the next 5 rules appear to be orphans
minimixtureStructure2: comma lrb mixtureContent rrb comma;
minimixtureStructure1:  lrb mixtureContent rrb;
minimixtureContent:   (fw|nn|verb|measurements|nnpercent|md|stop|oscarCompound|molecule|unnamedmolecule|dash|sym|cd|noun|inAll|cd|comma|adj|colon|stop) (fw|verb|measurements|nnyield|nnpercent|md|stop|oscarCompound|molecule|unnamedmolecule|dash|sym|cd|noun|inAll|cd|comma|adj|colon|stop)+ ;

method:
    (nngeneral|nn)? nnmethod (cdAlphanum|cd)?  ;
brackets:
	(lrb|rrb|lsqb|rsqb)+;

cdAlphanumType	:  lrb (cdAlphanum|cd) rrb;

advAdj
	:adv|adj;

range: number dash number;
cycles	:	cycleStructure -> ^(CYCLES cycleStructure)  ;
cycleStructure	:	cd dashNN? nncycle;
dashNN	:	(adj|nn|cd) (dash (adj|nn|cd))*;
ratio : (numberratio|nounratio) -> ^(RATIO numberratio? nounratio?)  ;
numberratio	:	 cd (colon cdAlphanum|cd)+ ;
nounratio
	:	 noun  (colon noun)+  ;

reference
	:	lsqb cd rsqb;
citation: (citationStructure1|citationStructure2) -> ^(CITATION  citationStructure1? citationStructure2?);

citationStructure1:  lrb citationContent rrb;
citationStructure2: comma lrb citationContent rrb comma;
citationContent:   (nnp|fw|cd|conjunction) (nnp|fw|cd|conjunction)+ ;

adj	:	jj|jjr|jjs|oscarcj|jjchem|oscarrn;
adv	:	rb|rbr|rp|rbs;
clause	:	wdt|wp_poss|wrb|ex|pdt|wp;
conjunction :	cc|comma;
inAll	: in|inafter|inas|inbefore|inby|infor|infrom|inin|ininto|inof|inoff|inon|inover|inunder|invia|inwith|inwithout|to;
inMost	: in|inas|inbefore|inby|infor|infrom|inin|ininto|inof|inoff|inon|inover|inunder|invia|inwith|inwithout|to;
number : cd|cdAlphanum;


//Tags---Pattern---Description
cdAlphanum:'CD-ALPHANUM' TOKEN -> ^('CD-ALPHANUM' TOKEN);
oscarcj:'OSCAR-CJ' TOKEN -> ^('OSCAR-CJ' TOKEN);
oscarrn:'OSCAR-RN' TOKEN -> ^('OSCAR-RN' TOKEN);
oscarase:'OSCAR-ASE' TOKEN -> ^('OSCAR-ASE' TOKEN);
oscaront:'OSCAR-ONT' TOKEN -> ^('OSCAR-ONT' TOKEN);
tmunicode:'TM-UNICODE' TOKEN -> ^('TM-UNICODE' TOKEN);
cdunicode:'CD-UNICODE' TOKEN -> ^('CD-UNICODE' TOKEN);
jjchem:'JJ-CHEM' TOKEN -> ^('JJ-CHEM' TOKEN);
jjcomp:'JJ-COMPOUND' TOKEN -> ^('JJ-COMPOUND' TOKEN);
// Prepositions
inas:'IN-AS' TOKEN -> ^('IN-AS' TOKEN);
inbefore:'IN-BEFORE' TOKEN -> ^('IN-BEFORE' TOKEN);
inafter:'IN-AFTER' TOKEN -> ^('IN-AFTER' TOKEN);
inin:'IN-IN' TOKEN -> ^('IN-IN' TOKEN);
ininto:'IN-INTO' TOKEN -> ^('IN-INTO' TOKEN);
inwith:'IN-WITH' TOKEN -> ^('IN-WITH' TOKEN);
inwithout:'IN-WITHOUT' TOKEN -> ^('IN-WITHOUT' TOKEN);
inby:'IN-BY' TOKEN -> ^('IN-BY' TOKEN);
invia:'IN-VIA' TOKEN -> ^('IN-VIA' TOKEN);
inof:'IN-OF' TOKEN -> ^('IN-OF' TOKEN);
inon:'IN-ON' TOKEN -> ^('IN-ON' TOKEN);
infor:'IN-FOR' TOKEN -> ^('IN-FOR' TOKEN);
infrom:'IN-FROM' TOKEN -> ^('IN-FROM' TOKEN);
inunder:'IN-UNDER' TOKEN -> ^('IN-UNDER' TOKEN);
inover:'IN-OVER' TOKEN -> ^('IN-OVER' TOKEN);
inoff:'IN-OFF' TOKEN -> ^('IN-OFF' TOKEN);

//Modified Nouns
nnstate:'NN-STATE' TOKEN -> ^('NN-STATE' TOKEN);
nntime:'NN-TIME' TOKEN -> ^('NN-TIME' TOKEN);
nnmass:'NN-MASS' TOKEN -> ^('NN-MASS' TOKEN);
nnamount:'NN-AMOUNT' TOKEN -> ^('NN-AMOUNT' TOKEN);
nnmolar:'NN-MOLAR' TOKEN -> ^('NN-MOLAR' TOKEN);
nnatmosphere:'NN-ATMOSPHERE' TOKEN -> ^('NN-ATMOSPHERE' TOKEN);
nneq:'NN-EQ' TOKEN -> ^('NN-EQ' TOKEN);
nnvol:'NN-VOL' TOKEN -> ^('NN-VOL' TOKEN);
nnchementity:'NN-CHEMENTITY' TOKEN -> ^('NN-CHEMENTITY' TOKEN);
nntemp:'NN-TEMP' TOKEN -> ^('NN-TEMP' TOKEN);
nnflash:'NN-FLASH' TOKEN -> ^('NN-FLASH' TOKEN);
nngeneral:'NN-GENERAL' TOKEN -> ^('NN-GENERAL' TOKEN);
nnmethod:'NN-METHOD' TOKEN -> ^('NN-METHOD' TOKEN);
nnpressure:'NN-PRESSURE' TOKEN -> ^('NN-PRESSURE' TOKEN);
nncolumn:'NN-COLUMN' TOKEN -> ^('NN-COLUMN' TOKEN);
nnchromatography:'NN-CHROMATOGRAPHY' TOKEN -> ^('NN-CHROMATOGRAPHY' TOKEN);
nnvacuum:'NN-VACUUM' TOKEN -> ^('NN-VACUUM' TOKEN);
nncycle:'NN-CYCLE' TOKEN -> ^('NN-CYCLE' TOKEN);
nntimes:'NN-TIMES' TOKEN -> ^('NN-TIMES' TOKEN);
nnexample:'NN-EXAMPLE' TOKEN -> ^('NN-EXAMPLE' TOKEN);

//Not really Oscar-cm.. but need to be fixed
oscarcm:'OSCAR-CM' TOKEN -> ^('OSCAR-CM' TOKEN);

//Verbs
vbuse:'VB-USE' TOKEN -> ^('VB-USE' TOKEN);
vbchange:'VB-CHANGE' TOKEN -> ^('VB-CHANGE' TOKEN);
vbsubmerge:'VB-SUBMERGE' TOKEN -> ^('VB-SUBMERGE' TOKEN);
vbsubject:'VB-SUBJECT' TOKEN -> ^('VB-SUBJECT' TOKEN);

//Add Tokens
nnadd:'NN-ADD' TOKEN -> ^('NN-ADD' TOKEN);
nnmixture:'NN-MIXTURE' TOKEN -> ^('NN-MIXTURE' TOKEN);
vbdilute:'VB-DILUTE' TOKEN -> ^('VB-DILUTE' TOKEN);
vbadd:'VB-ADD' TOKEN -> ^('VB-ADD' TOKEN);
vbcharge:'VB-CHARGE' TOKEN -> ^('VB-CHARGE' TOKEN);
vbcontain:'VB-CONTAIN' TOKEN -> ^('VB-CONTAIN' TOKEN);
vbdrop:'VB-DROP' TOKEN -> ^('VB-DROP' TOKEN);
vbfill:'VB-FILL' TOKEN -> ^('VB-FILL' TOKEN);
vbsuspend:'VB-SUSPEND' TOKEN -> ^('VB-SUSPEND' TOKEN);
vbtreat:'VB-TREAT' TOKEN -> ^('VB-TREAT' TOKEN);

//Apparatus Tokens
vbapparatus:'VB-APPARATUS' TOKEN -> ^('VB-APPARATUS' TOKEN);
nnapparatus:'NN-APPARATUS' TOKEN -> ^('NN-APPARATUS' TOKEN);

//Concentrate Tokens
vbconcentrate:'VB-CONCENTRATE' TOKEN -> ^('VB-CONCENTRATE' TOKEN);
nnconcentrate:'NN-CONCENTRATE' TOKEN -> ^('NN-CONCENTRATE' TOKEN);

//Cool Tokens
vbcool:'VB-COOL' TOKEN -> ^('VB-COOL' TOKEN);

//Degass Tokens
vbdegass:'VB-DEGASS' TOKEN -> ^('VB-DEGASS' TOKEN);

//Dissolve Tokens
vbdissolve:'VB-DISSOLVE' TOKEN -> ^('VB-DISSOLVE' TOKEN);

//Dry Tokens
vbdry:'VB-DRY' TOKEN -> ^('VB-DRY' TOKEN);
nndry:'NN-DRY' TOKEN -> ^('NN-DRY' TOKEN);

//Extract Tokens
vbextract:'VB-EXTRACT' TOKEN -> ^('VB-EXTRACT' TOKEN);
nnextract:'NN-EXTRACT' TOKEN -> ^('NN-EXTRACT' TOKEN);

//Filter Tokens
vbfilter:'VB-FILTER' TOKEN -> ^('VB-FILTER' TOKEN);
nnfilter:'NN-FILTER' TOKEN -> ^('NN-FILTER' TOKEN);

//Heat Tokens
vbheat:'VB-HEAT' TOKEN -> ^('VB-HEAT' TOKEN);
vbincrease:'VB-INCREASE' TOKEN -> ^('VB-INCREASE' TOKEN);

//Immerse tokens
vbimmerse:'VB-IMMERSE' TOKEN -> ^('VB-IMMERSE' TOKEN);

//Partition Tokens
vbpartition:'VB-PARTITION' TOKEN -> ^('VB-PARTITION' TOKEN);

//Precipitate Tokens
vbprecipitate:'VB-PRECIPITATE' TOKEN -> ^('VB-PRECIPITATE' TOKEN);
nnprecipitate:'NN-PRECIPITATE' TOKEN -> ^('NN-PRECIPITATE' TOKEN);

//Purify Tokens
vbpurify:'VB-PURIFY' TOKEN -> ^('VB-PURIFY' TOKEN);
nnpurify:'NN-PURIFY' TOKEN -> ^('NN-PURIFY' TOKEN);

//Quench Tokens
vbquench:'VB-QUENCH' TOKEN -> ^('VB-QUENCH' TOKEN);

//Recover Tokens
vbrecover:'VB-RECOVER' TOKEN -> ^('VB-RECOVER' TOKEN);

//Remove Tokens
vbremove:'VB-REMOVE' TOKEN -> ^('VB-REMOVE' TOKEN);
nnremove:'NN-REMOVE' TOKEN -> ^('NN-REMOVE' TOKEN);

//Stir Tokens
vbstir:'VB-STIR' TOKEN -> ^('VB-STIR' TOKEN);

//Synthesize Tokens
vbsynthesize:'VB-SYNTHESIZE' TOKEN -> ^('VB-SYNTHESIZE' TOKEN);
nnsynthesize:'NN-SYNTHESIZE' TOKEN -> ^('NN-SYNTHESIZE' TOKEN);

//Wait Tokens
vbwait:'VB-WAIT' TOKEN -> ^('VB-WAIT' TOKEN);

//Wash Tokens
vbwash:'VB-WASH' TOKEN -> ^('VB-WASH' TOKEN);

//Yield Tokens
vbyield:'VB-YIELD' TOKEN -> ^('VB-YIELD' TOKEN);

//Yield Tokens
nnyield:'NN-YIELD' TOKEN -> ^('NN-YIELD' TOKEN);

//Misc Tokens mainly to replace characters that are not markup friendly
// Conjunctive Adverbs
rbconj:'RB-CONJ' TOKEN -> ^('RB-CONJ' TOKEN);
colon:'COLON' TOKEN -> ^('COLON' TOKEN);
comma:'COMMA' TOKEN -> ^('COMMA' TOKEN);
apost:'APOST' TOKEN -> ^('APOST' TOKEN);
neg:'NEG' TOKEN -> ^('NEG' TOKEN);
dash:'DASH' TOKEN -> ^('DASH' TOKEN);
stop:'STOP' TOKEN -> ^('STOP' TOKEN);
nnpercent:'NN-PERCENT' TOKEN -> ^('NN-PERCENT' TOKEN);
lsqb:'LSQB' TOKEN -> ^('LSQB' TOKEN);
rsqb:'RSQB' TOKEN -> ^('RSQB' TOKEN);

//The determiner 'the';
dtTHE:'DT-THE' TOKEN -> ^('DT-THE' TOKEN);

lrb:'-LRB-' TOKEN -> ^('-LRB-' TOKEN);
rrb:'-RRB-' TOKEN -> ^('-RRB-' TOKEN);

//Penn Treebank Tokens

// Coordinating conjunction (and, or)
cc:'CC' TOKEN -> ^('CC' TOKEN);

// Cardinal numeral (one, two, 2, etc.)
cd:'CD' TOKEN -> ^('CD' TOKEN);

// Singular determiner/quantifier (this, that)
dt:'DT' TOKEN -> ^('DT' TOKEN);

// Existential there
ex:'EX' TOKEN -> ^('EX' TOKEN);

// Foreign word (hyphenated before regular tag)
fw:'FW' TOKEN -> ^('FW' TOKEN);

// Preposition
in:'IN' TOKEN -> ^('IN' TOKEN);

// Adjective
jj:'JJ' TOKEN -> ^('JJ' TOKEN);

// Comparative adjective
jjr:'JJR' TOKEN -> ^('JJR' TOKEN);

// Semantically superlative adjective (chief, top)
jjs:'JJS' TOKEN -> ^('JJS' TOKEN);

// List item marker
ls:'LS' TOKEN -> ^('LS' TOKEN);

// Modal auxiliary (can, should, will)
md:'MD' TOKEN -> ^('MD' TOKEN);

// Singular or mass noun
nn:'NN' TOKEN -> ^('NN' TOKEN);

// Plural noun
nns:'NNS' TOKEN -> ^('NNS' TOKEN);

// Proper noun or part of name phrase
nnp:'NNP' TOKEN -> ^('NNP' TOKEN);

// Proper noun, plural
nnps:'NNPS' TOKEN -> ^('NNPS' TOKEN);

//Predeterminer
pdt:'PDT' TOKEN -> ^('PDT' TOKEN);

// Possessive ending
pos:'POS' TOKEN -> ^('POS' TOKEN);

//Personal pronoun
prp:'PRP' TOKEN -> ^('PRP' TOKEN);

//Possessive pronoun
prp_poss:'PRP$' TOKEN -> ^('PRP$' TOKEN);

// Adverb
rb:'RB' TOKEN -> ^('RB' TOKEN);

// Comparative adverb
rbr:'RBR' TOKEN -> ^('RBR' TOKEN);

// Superlative adverb
rbs:'RBS' TOKEN -> ^('RBS' TOKEN);

// Adverb/particle (about, off, up)
rp:'RP' TOKEN -> ^('RP' TOKEN);

// Symbol
sym:'SYM' TOKEN -> ^('SYM' TOKEN);

// Infinitive marker to
to:'TO' TOKEN -> ^('TO' TOKEN);

// Interjection, exclamation
uh:'UH' TOKEN -> ^('UH' TOKEN);

// Verb, base form
vb:'VB' TOKEN -> ^('VB' TOKEN);

// Verb, past tense
vbd:'VBD' TOKEN -> ^('VBD' TOKEN);

// Verb, present participle/gerund
vbg:'VBG' TOKEN -> ^('VBG' TOKEN);

// Verb, past participle
vbn:'VBN' TOKEN -> ^('VBN' TOKEN);

// Verb, non-3rd person singular present
vbp:'VBP' TOKEN -> ^('VBP' TOKEN);

// Verb, 3rd. singular present
vbz:'VBZ' TOKEN -> ^('VBZ' TOKEN);

// Wh- determiner (which, that)
wdt:'WDT' TOKEN -> ^('WDT' TOKEN);

// wh- pronoun (what, who, whom)
wp:'WP' TOKEN -> ^('WP' TOKEN);

// Possessive wh- pronoun (whose)
wp_poss:'WP$' TOKEN -> ^('WP$' TOKEN);

// Wh- adverb (how, where, when)
wrb:'WRB' TOKEN -> ^('WRB' TOKEN);