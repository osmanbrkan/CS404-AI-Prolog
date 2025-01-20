% Osman Berk An 28849
% Date: 04-12-2024
% CS404 Homework4 Prolog code

%Initialization of people bags and foods
% define men and women
man(rasim).
man(can).
man(gencer).

woman(beyza).
woman(meryem).
woman(canan).

% define bags and food
bag(blue).
bag(red).
bag(green).
bag(yellow).
bag(orange).
bag(purple).

food(onion).
food(garlic).
food(cookies).
food(chocolate).
food(avocado).
food(nuts).

% make that all as a list for the relatios
people_list(People) :-
    findall(Person, (man(Person); woman(Person)), People).

bag_list(Bags) :-
    findall(Bag, bag(Bag), Bags).

food_list(Foods) :-
    findall(Food, food(Food), Foods).

% creating all combinations People - Bag and Food together
create_combinations(People, Bags, Foods, Relations) :-
    relation_assign(People, Bags, Foods, [], Relations).

% generating relations: People, Bag, Food
generate_relations(Relations) :-
    people_list(People),
    bag_list(Bags),
    food_list(Foods),
    create_combinations(People, Bags, Foods, Relations). %all people, bag, food assignments 

%first assign empty otherwise it gives false. that is like base case. When there is no food bag left, it stops
relation_assign([], [], [], Relations, Relations).

% assigning food and bag to the remaining people in recursive 
relation_assign([Person|RestPeople], Bags, Foods, Acc, Relations) :-
    select(Bag, Bags, RemainingBags),
    select(Food, Foods, RemainingFoods),
    NewRelation = relation(Person, Bag, Food),
    relation_assign(RestPeople, RemainingBags, RemainingFoods, [NewRelation|Acc], Relations).




%Implementation of clues 

% Clue 1: Onion was not carried with the red bag.
clue_1(Relations) :-
    \+ member(relation(_, red, onion), Relations). %no onion in red bag

% Clue 2: The man who owns the red bag did not carry cookies, chocolate, or avocado.
clue_2(Relations) :-
    member(relation(RedBagOwner, red, RedBagFood), Relations),
    man(RedBagOwner),
    \+ member(RedBagFood, [cookies, chocolate, avocado]).

% Clue 3: Beyza owns either the yellow bag or the blue bag, and Meryem owns the other.
clue_3(Relations) :-
    member(relation(beyza, BeyzaBag, _), Relations),
    member(relation(meryem, MeryemBag, _), Relations),
    permutation([BeyzaBag, MeryemBag], [yellow, blue]). %ensuring the relationship betwen Beyza and Meryem

% Clue 4: The person who carried avocado, who was not Beyza nor Gencer, does not own the blue or orange bags.
clue_4(Relations) :-
    member(relation(AvocadoCarrier, AvocadoBag, avocado), Relations),
    \+ member(AvocadoCarrier, [beyza, gencer]),  %avocado carier is not beyza or gencer
    \+ member(AvocadoBag, [blue, orange]).%and no blue or orange bag

% Clue 5: The woman who carried cookies owns the yellow bag.
clue_5(Relations) :-
    member(relation(CookieCarrier, yellow, cookies), Relations),
    woman(CookieCarrier). %cookie carrier has yellow bag

% Clue 6: The food item carried with the purple bag belongs to either Can or Gencer.
clue_6(Relations) :-
    member(relation(PurpleBagOwner, purple, _), Relations),
    member(PurpleBagOwner, [can, gencer]).

% Clue 7: Chocolate was not carried with the orange bag.
clue_7(Relations) :-
    \+ member(relation(_, orange, chocolate), Relations). %no cholocate with orange bag

% Clue 8: Meryem did not carry a food item with the yellow or green bag.
clue_8(Relations) :-
    \+ member(relation(meryem, yellow, _), Relations),
    \+ member(relation(meryem, green, _), Relations). %not carry food item with yellow or green

% Clue 9: Onion is carried by Gencer.
clue_9(Relations) :-
    member(relation(gencer, _, onion), Relations).

% Clue 10: Nuts were carried with the green bag, and that person was guilty.
clue_10(Relations) :-
    member(relation(_, green, nuts), Relations). %it gives guilty person


%all given clues finished

% applying all clues
apply_clues(Relations) :-
    clue_1(Relations),
    clue_2(Relations),
    clue_3(Relations),
    clue_4(Relations),
    clue_5(Relations),
    clue_6(Relations),
    clue_7(Relations),
    clue_8(Relations),
    clue_9(Relations),
    clue_10(Relations).


% printing all relationship assignments, bag food to people
print_final([]).
print_final([relation(Person, Bag, Food)|Rest]) :-
    write(Person), write(' owns '), write(Bag), write(' bag '), write('and carries '), write(Food), nl,
    print_final(Rest).



% guilty(X) solver 
guilty(GuiltyPerson) :-
    % all relations
    generate_relations(Relations),

    % applying all clues
    apply_clues(Relations),

    % take the guilty person
    member(relation(GuiltyPerson, green, nuts), Relations),

    % Output all people's bag and food assignments
    write('Result:'), nl,
    print_final(Relations),

    % Output the guilty person
    write('Guilty person: '), write(GuiltyPerson), nl.











