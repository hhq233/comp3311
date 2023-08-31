create table Acad_object_groups (
	id          integer,
	name        LongName,
	gtype       AcadObjectGroupType not null,
	glogic      AcadObjectGroupLogicType,
	gdefBy      AcadObjectGroupDefType not null,
	negated     boolean default false,
	parent      integer, -- references Acad_object_groups(id),
	definition  TextString, -- if pattern or query-based group
	primary key (id)
);

create table Subject_group_members (
	subject     integer references Subjects(id),
	ao_group    integer references Acad_object_groups(id),
	primary key (subject,ao_group)
);

create table Stream_group_members (
	stream      integer references Streams(id),
	ao_group    integer references Acad_object_groups(id),
	primary key (stream,ao_group)
);

create table Program_group_members (
	program     integer references Programs(id),
	ao_group    integer references Acad_object_groups(id),
	primary key (program,ao_group)
);
