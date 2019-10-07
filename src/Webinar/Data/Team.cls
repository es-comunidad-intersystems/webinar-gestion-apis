Class Webinar.Data.Team Extends (%Persistent, %Populate, %JSON.Adaptor)
{

Property Name As %String;

Property City As %String(MAXLEN = 255);

Storage Default
{
<Data name="TeamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>City</Value>
</Value>
</Data>
<DataLocation>^Webinar.Data.TeamD</DataLocation>
<DefaultData>TeamDefaultData</DefaultData>
<IdLocation>^Webinar.Data.TeamD</IdLocation>
<IndexLocation>^Webinar.Data.TeamI</IndexLocation>
<StreamLocation>^Webinar.Data.TeamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
