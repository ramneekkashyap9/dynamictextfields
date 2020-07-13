
class ListFieldFormBloc extends FormBloc<String, String> {

 final members = ListFieldBloc<MemberFieldBloc>(name: 'members');

 ListFieldFormBloc() {
   addFieldBlocs(
     fieldBlocs: [

       members,
     ],
   );
 }

 void addMember() {
   members.addFieldBloc(MemberFieldBloc(
     name: 'member',
     steps: TextFieldBloc(name: 'steps',),


   ));
 }

 void removeMember(int index) {
   members.removeFieldBlocAt(index);
 }

 void addHobbyToMember(int memberIndex) {
   //  members.value[memberIndex].hobbies.addFieldBloc(TextFieldBloc());
 }

 void removeHobbyFromMember(
     {@required int memberIndex, @required int hobbyIndex}) {
   //  members.value[memberIndex].hobbies.removeFieldBlocAt(hobbyIndex);
 }

 @override
 void onSubmitting() async {
   // Without serialization
   final clubV1 = Club(

     members: members.value.map<Member>((memberField) {
       return Member(
         steps: memberField.steps.value,

       );
     }).toList(),
   );


   // With Serialization
   final clubV2 = Club.fromJson(state.toJson());


   emitSuccess(
     canSubmitAgain: true,
     successResponse: JsonEncoder.withIndent('    ').convert(
       state.toJson(),
     ),
   );
 }
}

class MemberFieldBloc extends GroupFieldBloc {
 final TextFieldBloc steps;


 MemberFieldBloc({
   @required this.steps,

   String name,
 }) : super([steps,], name: name);
}

class Club {

 List<Member> members;

 Club({ this.members});

 Club.fromJson(Map<String, dynamic> json) {

   if (json['members'] != null) {
     members = List<Member>();
     json['members'].forEach((v) {
       members.add(Member.fromJson(v));
     });

   }
 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = Map<String, dynamic>();

   if (this.members != null) {
     data['members'] = this.members.map((v) => v.toJson()).toList();
   }
   return data;
 }


}

class Member {
 String steps;


 Member({this.steps});

 Member.fromJson(Map<String, dynamic> json) {
   steps = json['steps'];

 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = Map<String, dynamic>();
   data['steps'] = this.steps;

   return data;
 }


}

class ListFieldsForm extends StatelessWidget {
 var stateCheck;
 ListFieldsForm({this.stateCheck});

 void initState(){


   print(stateCheck);
   print('loaded');
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('ADD steps'),),
     body: BlocProvider(
       create: (context) => ListFieldFormBloc(),
       child: Builder(
         builder: (context) {
           final formBloc = context.bloc<ListFieldFormBloc>();

           return Theme(
             data: Theme.of(context).copyWith(
               inputDecorationTheme: InputDecorationTheme(
                 border: OutlineInputBorder(

                   borderRadius: BorderRadius.circular(20),
                 ),
               ),
             ),
             child: Scaffold(
               resizeToAvoidBottomInset: false,

               floatingActionButton: FloatingActionButton(
                 onPressed: formBloc.submit,
                 child: Icon(Icons.send,color: Colors.white,),
                 backgroundColor: Colors.pink,
               ),
               body: FormBlocListener<ListFieldFormBloc, String, String>(
                 onSubmitting: (context, state) {
                  // LoadingDialog.show(context);
                 },
                 onSuccess: (context, state) {
                   //LoadingDialog.hide(context);


                   var parsedData = json.decode(state.successResponse);
                   List members = parsedData['members'];
                   //  Map<String, dynamic> user = jsonDecode(state.successResponse);

                   String name1;

                   members.forEach((member){
                     //  print(member['firstName']);
                     name1 = member['steps'];
                     //  print(name1);
                     List<String> _steps = [];
                     _steps.add(member["steps"]);
//                    DocumentReference docref =  Firestore.instance.collection('steps').document("a");
//                    docref.setData({"steps":members});
                    // print(_firstNames);

                   });

                   String s = "hello1";


                //   _AddstepsState().getsteps(members);
                //   _AddstepsState().steps = members;
                  // Addsteps(getsteps: members,);

                //   _AddstepsState(steps: members);
                 //  Navigator.pop(context);

                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Addsteps(state1: state,)));

                  // print(members);
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                    content: SingleChildScrollView(
//                        child: Text(state.successResponse)),
//                    duration: Duration(milliseconds: 1500),
//                  ));
                 },
                 onFailure: (context, state) {
                   LoadingDialog.hide(context);

                   Scaffold.of(context).showSnackBar(
                       SnackBar(content: Text(state.failureResponse)));
                 },
                 child: SingleChildScrollView(
                   physics: ClampingScrollPhysics(),
                   child: stateCheck!= null?
                   Column(
                     children: <Widget>[

                       BlocBuilder<ListFieldBloc<MemberFieldBloc>,
                           ListFieldBlocState<MemberFieldBloc>>(
                         bloc: formBloc.members,
                         builder: (context, stateCheck) {
                           if (stateCheck.fieldBlocs.length != 0) {
                             return ListView.builder(
                               shrinkWrap: true,
                               physics: const NeverScrollableScrollPhysics(),
                               itemCount: stateCheck.fieldBlocs.length,
                               itemBuilder: (context, i) {
                                 return MemberCard(
                                   memberIndex: i,
                                   memberField: stateCheck.fieldBlocs[i],
                                   onRemoveMember: () =>
                                       formBloc.removeMember(i),
                                   onAddHobby: () =>
                                       formBloc.addHobbyToMember(i),
                                 );
                               },
                             );
                           }
                           return Container();
                         },
                       ),
                       RaisedButton(
                         color: Colors.blue[100],
                         onPressed: formBloc.addMember,
                         child: Text('ADD steps'),
                       ),

                       Center(child: Text('helo'))
                     ],
                   )
                       :Column(
                     children: <Widget>[

                       BlocBuilder<ListFieldBloc<MemberFieldBloc>,
                           ListFieldBlocState<MemberFieldBloc>>(
                         bloc: formBloc.members,
                         builder: (context, state) {
                           if (state.fieldBlocs.isNotEmpty) {
                             return ListView.builder(
                               shrinkWrap: true,
                               physics: const NeverScrollableScrollPhysics(),
                               itemCount: state.fieldBlocs.length,
                               itemBuilder: (context, i) {
                                 return MemberCard(
                                   memberIndex: i,
                                   memberField: state.fieldBlocs[i],
                                   onRemoveMember: () =>
                                       formBloc.removeMember(i),
                                   onAddHobby: () =>
                                       formBloc.addHobbyToMember(i),
                                 );
                               },
                             );
                           }
                           return Container();
                         },
                       ),
                       RaisedButton(
                         color: Colors.blue[100],
                         onPressed: formBloc.addMember,
                         child: Text('ADD steps'),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           );
         },
       ),
     ),
   );
 }
}

class MemberCard extends StatelessWidget {
 final int memberIndex;
 final MemberFieldBloc memberField;

 final VoidCallback onRemoveMember;
 final VoidCallback onAddHobby;

 const MemberCard({
   Key key,
   @required this.memberIndex,
   @required this.memberField,
   @required this.onRemoveMember,
   @required this.onAddHobby,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Card(
     color: Colors.pink,
     margin: const EdgeInsets.all(8.0),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(
                   'steps #${memberIndex + 1}',
                   style: TextStyle(fontSize: 20, color: Colors.white),
                 ),
               ),
               IconButton(
                 icon: Icon(Icons.delete),
                 onPressed: onRemoveMember,
                 color:Colors.white
               ),
             ],
           ),
           TextFieldBlocBuilder(

             textFieldBloc: memberField.steps,
             decoration: InputDecoration(
               labelText: 'steps',
               labelStyle: TextStyle(color: Colors.white)

             ),
             style: TextStyle(color: Colors.white),



             cursorColor: Colors.white,

           ),

         ],
       ),
     ),
   );
 }
}

class LoadingDialog extends StatelessWidget {
 static void show(BuildContext context, {Key key}) => showDialog<void>(
   context: context,
   useRootNavigator: false,
   barrierDismissible: false,
   builder: (_) => LoadingDialog(key: key),
 ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

 static void hide(BuildContext context) => Navigator.pop(context);

 LoadingDialog({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async => false,
     child: Center(
       child: Card(
         child: Container(
           width: 80,
           height: 80,
           padding: EdgeInsets.all(12.0),
           child: CircularProgressIndicator(),
         ),
       ),
     ),
   );
 }
}

class SuccessScreen extends StatelessWidget {
 SuccessScreen({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Icon(Icons.tag_faces, size: 100),
           SizedBox(height: 10),
           Text(
             'Success',
             style: TextStyle(fontSize: 54, color: Colors.black),
             textAlign: TextAlign.center,
           ),
           SizedBox(height: 10),
           RaisedButton.icon(
             onPressed: () => Navigator.of(context).pushReplacement(
                 MaterialPageRoute(builder: (_) => ListFieldsForm())),
             icon: Icon(Icons.replay),
             label: Text('AGAIN'),
           ),
         ],
       ),
     ),
   );
 }
}

