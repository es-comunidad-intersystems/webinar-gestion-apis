Class Webinar.Data.Player Extends (%Persistent, %Populate, %JSON.Adaptor)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Name As %String(MAXLEN = 255);

Property Alias As %String(MAXLEN = 50);

Property Avatar As %String(MAXLEN = "");

Property Score As %Numeric;

Property Team As Team;

/// Id Getter 
Method IdGet() As %String
{
	quit ..%Id()
}

Storage Default
{
<Data name="PlayerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>Avatar</Value>
</Value>
<Value name="5">
<Value>Score</Value>
</Value>
<Value name="6">
<Value>Team</Value>
</Value>
</Data>
<DataLocation>^Webinar.Data.PlayerD</DataLocation>
<DefaultData>PlayerDefaultData</DefaultData>
<IdLocation>^Webinar.Data.PlayerD</IdLocation>
<IndexLocation>^Webinar.Data.PlayerI</IndexLocation>
<StreamLocation>^Webinar.Data.PlayerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
