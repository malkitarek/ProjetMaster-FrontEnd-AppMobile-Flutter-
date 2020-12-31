import 'dart:convert';

import 'package:SoinConnect/pages/createPatient/createPatTraitement.dart';
import 'package:SoinConnect/pages/updatePatient/updatePatTraitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
class UpdatePatPage extends StatefulWidget {
  var pat;
  UpdatePatPage(this.pat);
  @override
  _UpdatePatPageState createState() => _UpdatePatPageState();
}

class _UpdatePatPageState extends State<UpdatePatPage> {
  var patient;
  List<String> _values = new List();
  List<bool> _selected = new List();
  List<String> _valuesMaladies = new List();
  List<bool> _selectedMaladies = new List();
  List<String> _valuesHabitudes = new List();
  List<bool> _selectedHabitudes = new List();
  var form;
  var formDossier;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(()  {
      this.patient=widget.pat;

      this.form= FormGroup({
        'id':FormControl(value: patient["id"]),
        'numeroIdentite': FormControl(value:patient["numeroIdentite"],validators: [Validators.required,Validators.number],
          asyncValidators:[AppService().uniqueNumIdentite],
        ),
        'nom': FormControl(value:patient["nom"],validators: [Validators.required]),
        'prenom': FormControl(value:patient["prenom"],validators: [Validators.required]),
        'dateNaissance': FormControl(value:patient["dateNaissance"],validators: [Validators.required]),
        'adresse': FormControl(value:patient["adresse"],validators: [Validators.required]),
        'sexe': FormControl(value:patient["sexe"],validators: [Validators.required]),
        'numeroAssurance': FormControl(value:patient["numeroAssurance"],validators: [Validators.required,Validators.number],
          asyncValidators:[AppService().uniqueNumAssurance],
        ),
        'phone': FormControl(value:patient["appUser"]["phone"],validators: [Validators.required,Validators.pattern("[0]{1}[0-9]{9}")]),
        'email': FormControl(value:patient["appUser"]["email"],
          validators: [Validators.required, Validators.email,],
          asyncValidators:[AppService().uniqueEmail],
        ),
      });
      formDossier= FormGroup({
        'poid': FormControl(value:patient["dossierMedecal"]["poid"],validators: [Validators.required,Validators.number]),
        'taille': FormControl(value:patient["dossierMedecal"]["taille"],validators: [Validators.required,Validators.number]),
        'groupeSanguin': FormControl(value:patient["dossierMedecal"]["groupeSanguin"],validators: [Validators.required]),
        'antecedent': FormControl(),
        'antecedentsFamiliaux': FormArray<String>([]),
        'maladie': FormControl(),
        'maladies': FormArray<String>([]),
        'habitude': FormControl(),
        'habitudesToxiques': FormArray<String>([]),
      });

      (patient["dossierMedecal"]["antecedentsFamiliaux"]).forEach((value){
        (formDossier.control("antecedentsFamiliaux") as FormArray).add(
          FormControl<String>(value: value),
        );
        _values.add(value);
      });
      for(int i=0;i<=_values.length;i++){_selected.add(true);}

      patient["dossierMedecal"]["maladies"].forEach((value){
        (formDossier.control("maladies") as FormArray).add(
          FormControl<String>(value: value),
        );
        _valuesMaladies.add(value);
      });
      for(int i=0;i<=_valuesMaladies.length;i++){_selectedMaladies.add(true);}

      patient["dossierMedecal"]["habitudesToxiques"].forEach((value){
        (formDossier.control("habitudesToxiques") as FormArray).add(
          FormControl<String>(value: value),
        );
        _valuesHabitudes.add(value);
      });
      for(int i=0;i<=_valuesHabitudes.length;i++){_selectedHabitudes.add(true);}
    });

  }
  int  _currentStep=0;
  Widget buildChips() {
    List<Widget> chips = new List();
    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        selected: _selected[i],
        label: Text(_values[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _selected[i] = !_selected[i];
          });
        },
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);
          (formDossier.control("antecedentsFamiliaux") as FormArray<String>).removeAt(i);
          setState(() {
            _values = _values;
            _selected = _selected;

          });
        },
      );

      chips.add(actionChip);
    }

    return  Wrap(
      verticalDirection: VerticalDirection.down,
      children: chips,
    );
  }
  Widget buildChipsMaladies() {
    List<Widget> chips = new List();
    for (int i = 0; i < _valuesMaladies.length; i++) {
      InputChip actionChip = InputChip(
        selected: _selectedMaladies[i],
        label: Text(_valuesMaladies[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _selectedMaladies[i] = !_selectedMaladies[i];
          });
        },
        onDeleted: () {
          _valuesMaladies.removeAt(i);
          _selectedMaladies.removeAt(i);
          (formDossier.control("maladies") as FormArray<String>).removeAt(i);
          setState(() {
            _valuesMaladies = _valuesMaladies;
            _selectedMaladies = _selectedMaladies;

          });
        },
      );

      chips.add(actionChip);
    }

    return  Wrap(
      verticalDirection: VerticalDirection.down,
      children: chips,
    );
  }

  Widget buildChipsHabitudes() {
    List<Widget> chips = new List();
    for (int i = 0; i < _valuesHabitudes.length; i++) {
      InputChip actionChip = InputChip(
        selected: _selectedHabitudes[i],
        label: Text(_valuesHabitudes[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _selectedHabitudes[i] = !_selectedHabitudes[i];
          });
        },
        onDeleted: () {
          _valuesHabitudes.removeAt(i);
          _selectedHabitudes.removeAt(i);
          (formDossier.control("habitudesToxiques") as FormArray<String>).removeAt(i);
          setState(() {
            _valuesHabitudes = _valuesHabitudes;
            _selectedHabitudes = _selectedHabitudes;

          });
        },
      );

      chips.add(actionChip);
    }

    return  Wrap(
      verticalDirection: VerticalDirection.down,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }
  Widget page(){
    return Scaffold(
      appBar: AppBar(title: Text("Modifier Patient"),backgroundColor: ColorBar,),
      body: Stepper( steps: _steep(),
        physics: ClampingScrollPhysics(),

        currentStep: this._currentStep,
        onStepTapped: (step){
          setState(() {
            this._currentStep= step;
          });
        },

        onStepContinue: (){
          setState(()  {
            if(this._currentStep<this._steep().length-1){
              if(form.valid) ++this._currentStep;
              else form.markAllAsTouched();
            }else{
              if(formDossier.valid){
                UpdatePatTraitement().updatePat(form,formDossier,patient["id"],context).then((value) {
                  setState(() {});
                });
              }
              else{
                formDossier.markAllAsTouched();
              }
            }
          });

        },
        onStepCancel: (){
          setState(() {
            if(this._currentStep>0){
              --this._currentStep;
            }else{this._currentStep=0;}
          });
        },
      ),

    );
  }
  List<Step> _steep(){
    List<Step> _steps=[
      Step(title: Text("Les données personnel du patient"),
          content: ReactiveForm(
            formGroup: this.form,
            child: Column(
              children: <Widget>[
                ReactiveTextField(
                    formControlName: 'numeroIdentite',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Numéro d'identité")
                ),
                ReactiveTextField(
                    formControlName: 'nom',
                    decoration: InputDecoration(labelText: "Nom")
                ),
                ReactiveTextField(
                    formControlName: 'prenom',
                    decoration: InputDecoration(labelText: "Prenom")
                ),
                ReactiveTextField(
                    formControlName: 'email',
                    decoration: InputDecoration(labelText: "Email")
                ),
                ReactiveTextField(
                    formControlName: 'phone',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Téléphone")
                ),
                ReactiveTextField(
                    formControlName: 'adresse',
                    decoration: InputDecoration(labelText: "Adresse")
                ),
                ReactiveTextField(
                    formControlName: 'numeroAssurance',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Numéro d'assurance")
                ),
                ReactiveTextField(
                    formControlName: 'dateNaissance',
                    decoration: InputDecoration(labelText: "Date naissance") ,
                    onTap: () async{
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2030));

                      form.control("dateNaissance").value=date.toIso8601String() ;
                    }
                ),
                ReactiveDropdownField<String>(
                    formControlName: 'sexe',
                    hint: Text('Select sexe...'),
                    items: [
                      DropdownMenuItem(
                        value: 'Homme',
                        child: Text('Homme'),
                      ),
                      DropdownMenuItem(
                        value: 'Femme',
                        child: Text('Femme'),
                      )]
                ),
              ],
            ),
          ),
          isActive: _currentStep >=0,
          state: (form.valid)?StepState.complete:StepState.error

      ),
      Step(
          title: Text("Le dossier médécal"),
          content: ReactiveForm(
            formGroup: this.formDossier,
            child: Column(
              children: [
                ReactiveTextField(
                    formControlName: "poid",
                    decoration: InputDecoration(labelText: "poid")),
                ReactiveTextField(
                    formControlName: "taille",
                    decoration: InputDecoration(labelText: "taille")),
                ReactiveDropdownField<String>(
                    formControlName: 'groupeSanguin',
                    hint: Text('Select Groupe sanguin...'),
                    items: [
                      DropdownMenuItem(value: 'O+',child: Text('O+'),),
                      DropdownMenuItem(value: 'O-',child: Text('O-'),),
                      DropdownMenuItem(value: 'A+', child: Text('A+'),),
                      DropdownMenuItem(value: 'A-',child: Text('A-'),),
                      DropdownMenuItem(value: 'B+',child: Text('B+'),),
                      DropdownMenuItem(value: 'B-',child: Text('B-'),),
                      DropdownMenuItem(value: 'AB+', child: Text('AB+'),),
                      DropdownMenuItem(value: 'AB-',child: Text('AB-'),),
                    ]
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: buildChips(),
                ),
                ReactiveTextField(
                    onSubmitted: (){
                      _values.add(formDossier.control("antecedent").value);
                      _selected.add(true);
                      (formDossier.control("antecedentsFamiliaux") as FormArray).add(
                        FormControl<String>(value: formDossier.control("antecedent").value),
                      );
                      // print("eeeeeeeeeeeeee=${formDossier.value}");
                      formDossier.control("antecedent").reset();
                      setState(() {
                        _values = _values;
                        _selected = _selected;
                      });
                    },
                    formControlName: "antecedent",
                    decoration: InputDecoration(labelText: "Antécédents Familiaux")),

                SizedBox(
                  height: 60,
                ),
                Container(
                  child: buildChipsMaladies(),
                ),
                ReactiveTextField(
                    onSubmitted: (){
                      _valuesMaladies.add(formDossier.control("maladie").value);
                      _selectedMaladies.add(true);
                      (formDossier.control("maladies") as FormArray).add(
                        FormControl<String>(value: formDossier.control("maladie").value),
                      );
                      // print("eeeeeeeeeeeeee=${formDossier.value}");
                      formDossier.control("maladie").reset();
                      setState(() {
                        _valuesMaladies = _valuesMaladies;
                        _selectedMaladies = _selectedMaladies;
                      });
                    },
                    formControlName: "maladie",
                    decoration: InputDecoration(labelText: "Maladies")),
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: buildChipsHabitudes(),
                ),
                ReactiveTextField(
                    onSubmitted: (){
                      _valuesHabitudes.add(formDossier.control("habitude").value);
                      _selectedHabitudes.add(true);
                      (formDossier.control("habitudesToxiques") as FormArray).add(
                        FormControl<String>(value: formDossier.control("habitude").value),
                      );
                      // print("eeeeeeeeeeeeee=${formDossier.value}");
                      formDossier.control("habitude").reset();
                      setState(() {
                        _valuesHabitudes = _valuesHabitudes;
                        _selectedHabitudes = _selectedHabitudes;
                      });
                    },
                    formControlName: "habitude",
                    decoration: InputDecoration(labelText: "Habitudes Toxiques")),
              ],
            ),
          ),

          isActive: _currentStep >=1,
          state: StepState.disabled ,


      )
    ];
    return _steps;
  }
}
