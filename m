From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC v1 for verbs counters]
Date: Thu, 16 Mar 2017 17:44:25 +0000
Message-ID: <HE1PR0502MB30663840419B28FAAEE6DC9BBD260@HE1PR0502MB3066.eurprd05.prod.outlook.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>,<SN1PR07MB2207216EF4161F94ED6EC288F8270@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB2207216EF4161F94ED6EC288F8270-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=A0  =20
>> RFC: Verbs Counters
>>=20
>>=20
>> There is a constant demand to know about connections used in verbs (and =
and other aspects).
>> Some vendors have been offering hardware counters for a long time by usi=
ng sysfs.
>> Those counters, however - are not available per connection but for the w=
hole system.
>>=20
>> One way to do it is for each vendor to offer their vendor specific count=
ers, which will probably
>>=A0 not be generic since each vendor could have their own implementation =
of counters hence
>>=A0 the verbs interface will not be generic for the rest of them.
>>=20
>>=20
>> We present a generic interface for using counters in verbs.
>> Let's have some definition before going into details:
>>=20
>> Object:=A0=A0=A0=A0=A0=A0=A0=A0=A0 an existing structure in verbs which =
describes physical entity
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 e.g.: QP/FLOW/DEVICE/
>> Counter:=A0=A0=A0=A0=A0=A0=A0=A0 a single attribute which is use to coun=
t events/statistics
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 on object
>> Counter-set:=A0=A0=A0=A0 a set of counters that belongs to one specific =
object.
>>=20
>>=20
>> A generic interface with=A0 following functionality is presented :
>>=20
>>=20
>> 1.=A0=A0=A0=A0=A0 A way to list of all the available counter-sets in the=
 device.
>>=A0=A0=A0=A0=A0=A0=A0=A0 Per each counter-set:
>>=A0=A0=A0=A0=A0=A0=A0=A0 - What do the counters within the set measure? i=
s it QP? Flow? other?
>>=A0=A0=A0=A0=A0=A0=A0=A0 - A Unique identifier per counter-set.
>>=A0=A0=A0=A0=A0=A0=A0=A0 - A list of names for all the counters within ea=
ch counter-set.
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 since each vendor has their own counter=
s/stats. Each vendor
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 could use their own names for a counter=
. This suggestion
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 aims to replace vendor-specific-api wit=
h predefined
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enums/names for each counter/stats.
>>=A0=A0=A0=A0=A0=A0=A0=A0 - Additional Meta-data about a counter-set (for =
example - is it cached?)
>>=20
>> 2.=A0=A0=A0=A0=A0 Operations available per counter-set:
>> 2.1=A0=A0=A0=A0 Bind and unbind:
>>=A0=A0=A0=A0=A0=A0=A0=A0 a counter-set has to be attached to an object in=
 order for any
>>=A0=A0=A0=A0=A0=A0=A0=A0 counter within a counter-set to count. the attac=
hing action
>>=A0=A0=A0=A0=A0=A0=A0=A0 is referred to as 'bind' and the opposite action=
 is referred to
>>=A0=A0=A0=A0=A0=A0=A0=A0 as 'unbind'.
>>=A0=A0=A0=A0=A0=A0=A0=A0 Rather than having specific generic operation fo=
r bind and unbind
>>=A0=A0=A0=A0=A0=A0=A0=A0 I choose to use existing verbs methods. The exis=
ting methods could
>>=A0=A0=A0=A0=A0=A0=A0=A0 be modified with small changes (like adding a ne=
w flag) to bind
>>=A0=A0=A0=A0=A0=A0=A0=A0 (or unbind) a counter-set to an object.
>>=20
>>=20
>> 2.2=A0=A0=A0=A0 Counter-set may be created: counter-set instance is allo=
cated and
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 created on a ibv context and belongs to th=
at context.
>>=20
>> 2.3=A0=A0=A0=A0 Counter-set may be destroyed: counter-set instance is de=
stroyed and
>>=A0=A0=A0=A0=A0=A0=A0=A0 de-allocated. If counter-set is bonded to object=
 then it is the
>>=A0=A0=A0=A0=A0=A0=A0=A0 responsibility of the driver either to unbind pr=
ior to=A0 hardware
>>=A0=A0=A0=A0=A0=A0=A0=A0 de-allocation or to notify the user that driver =
is unable to destroy
>>=A0=A0=A0=A0=A0=A0=A0=A0 a counter-set and it is the user responsibility =
to unbind prior to
>>=A0=A0=A0=A0=A0=A0=A0=A0 destruction.
>>=20
>> 2.4=A0=A0=A0=A0 Counter-set may be queried:=A0 the user supply counter-s=
et instance and
>>=A0=A0=A0=A0=A0=A0=A0=A0 output address. The hardware queries the counter=
-set and writes the
>>=A0=A0=A0=A0=A0=A0=A0=A0 output to the=A0 address as an array of uint64_t=
. Each entry in the
>>=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t array represents a single counter.
>>=20
>>=20
>> The user is expected to query the device on startup,
>>=A0=A0=A0 find which counter-sets are supported and to which objects
>>=A0=A0=A0 each counter-set may be bonded. During this scan the user
>>=A0=A0=A0=A0 also finds out which counters are supported for which object=
.
>>=20
>> Example for a way to list of all the available counter-sets in the devic=
e.
>>=20
>>=20
>> We modify the method=A0 int query_device_ex() by adding a new flag to th=
e
>> enum ibv_device_attr_mask:
>>=20
>>=20
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0 IBV_DEVICE_ATTR_COUNTER_SET=A0=A0=A0=A0=A0=
=A0=A0 =3D 1 <<=A0 1
>>=20
>>=20
>> When using this flag, the device will response with struct ibv_device_at=
tr_ex
>> with a new attribute:
>>=20
>>=20
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0=A0=A0 max_supported_count=
er_sets;
>>=20
>>=20
>> And then a user can use a new API to get the description for each counte=
r-set.
>> number of counter set is specified by a counter-set-id.
>> a counter-set id is a number from 0 to max_supported_counter_sets.
>> that is - the number returned from the query_device_ex() call.
>>=20
>>=20
>> int ibv_query_counter_set_description(struct ibv_context *context, \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t counter_set_id, \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_counter_set_descripti=
on * out)
>> - return 0 on success
>> - return -1 when counter_set_id is invalid.
>>=20
>>=20
>> The API writes to out the following structure:
>>=20
>>=20
>> struct ibv_counter_set_description {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // Which type does this set refers t=
o?
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // value is taken from enum ibv_coun=
ter_set_counted_type
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint8_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 counted_type;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // Number of instances of this count=
er-set available in the hardware
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 number_of_counter_sets;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // Attributes of the set (bit mask)
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // value is taken from enum ibv_coun=
ter_set_attributes
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint32_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 attributes;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // number of entries
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint8_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 entries_count;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // List of entries,
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
struct ibv_counter_entry=A0 entry[256];
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>=20
>>=20
>> Where:
>> struct ibv_counter_entry {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // name of the entry. last entry con=
tains NULL
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0 name[32];
>> }
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>=20
>>=20
>> Brief explanation for the fields inside struct ibv_counter_set_descripti=
on:
>>=20
>>=20
>> counted_type - contain id for which this counter_set is related to.
>> the id is a value from ibv_counter_set_counted_type=A0 (see below)
>> Each counter-set relates to a verbs object, which is the verbs object th=
is
>> counter-set aim to count (i.e. measure), such as QP or Flow.
>>=20
>>=20
>> enum=A0 ibv_counter_set_counted_type=A0 {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 IBV_COUNTER_IBV_QP =3D 0=
,
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 IBV_COUNTER_IBV_FLOW,
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ...
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>=20
>> number_of_counter_sets - how many counters does this device supports?
>> Note that this value can be interpreted in more than one way. Either how=
 many
>> counter_sets are currently available or what is the total (max) number o=
f
>> counter_sets the device supports. this is seen as the max limit of count=
-set
>> which the process is allowed to create.
>>=20
>>=20
>> attributes=A0=A0 - special attributes which this counter-set might have
>> either in software or hardware.
>> For example we can have cached counter-set. Which means that every query
>> for that set is read from the cache. Unless a request to read the values=
 from
>> the hardware was specially specified.
>>=20
>>=20
>> enum ibv_counter_set_attributes {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 // the counter-set value is cached by default
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 IBV_COUNTER_ATTR_CACHED=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1 <<=A0 1
>> };
>>=20
>>=20
>> entries_count - number of entries in the counter_set
>>=20
>> struct ibv_counter_entry=A0 entry[256] - an ordered list of counter name=
s
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 where the last name in the array is emp=
ty (NULL)
>>=20
>> =3D=3D=3D=3D
>>=20
>>=20
>> Example:
>>=20
>>=20
>>=20
>>=20
>> ibv_counter_set_description is a struct to describe other structs.
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for example, we have the=
 following struct:
>>=20
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 private struct guy_count=
er {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t apples_kg;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t apples_count;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>=20
>>=20
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - note that all counters=
 are 64bit entries
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 The ibv_counter_set_desc=
 looks like this:
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 // according to=
 the ibv_counter_set_type enum
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.typ=
e =3D IBV_COUNTER_IBV_GUYGUY
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.att=
ributes =3D 0;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.num=
ber_of_counter_sets =3D 1000;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.ent=
ry[0].name =3D=A0 "apples [Kg]"
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.ent=
ry[1].name =3D=A0 "apples [Count]"
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ibv_counter_set_desc.ent=
ry[2].name =3D=A0 \0
>>=20
>> =3D=3D=3D=3D
>>=20
>>=20
>> How to fill the internal tables?
>>=20
>>=20
>> On initialization - driver should query device capabilities to see how m=
any
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 counter-set =
are supported. for each=A0 supported
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 counter-set =
the driver will act as following:
>> 1. Allocate counter_set_id
>> 2. Register counter_set_id with pointer to data structures with list of =
counters.
>> 5. Finally - The driver returns number of counter_sets supported in ibv_=
qeury_device_ex()
>>=20
>>=20
>>=20
>>=20
>> Operations available for each counter-set:
>> Each ibv_counter is represented by the following structure:
>>=20
>>=20
>> struct ibv_counter_set {
>>=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_context=A0=A0=A0=A0=A0=A0 *context;
>>=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 handle;
>> }
>>=20
>>=20
>>=20
>>=20
>> THE NEW API
>>=20
>>=20
>> struct ibv_counter_set* ibv_create_counter_set(struct ibv_context *conte=
xt,=A0 \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint16_t counter_set_id)
>>=20
>>=20
>> Method returns struct ibv_counter_set which contains context+handle.
>> Actions: Method Allocates memory for struct ibv_counter_set and then cal=
ls
>> the driver to allocate the actual hardware counter-set.
>> If successful method returns pointer to struct ibv_counter_set on the he=
ap
>> which contains context+handle.
>> If unsuccessful - method returns NULL and set errno accordingly.
>>=20
>>=20
>> int ibv_destroy_counter_set(struct ibv_counter_set* counter_set)
>>=20
>>=20
>> Methods destroys input counter_set and free the allocated memory.
>> Actions: Method attempts to remove hardware counter-set and then input s=
truct
>> is released (deleted). In the kernel the code checks if caller is
>> allowed to destroy counter_set (by comparing pid) and then released
>> hardware-resource.
>>=20
>>=20
>> If unsuccessful method returns -1 and set errno accordingly.
>> If successful method returns 0.
>>=20
>>=20
>> int ibv_query_counter_set(struct ibv_query_counter_set_attr, uint64_t * =
out)
>>=20
>> Method receives query structure and output address, then query the
>> hardware and writes output to the uint64_t * out address.
>> Actions: Method recives=A0 struct ibv_query_counter_set_attr, parse the =
query
>> and then send it to execution in kernel.
>> In the kernel the code checks if caller is allowed to query
>> the hardware, executes the query and then writes to *out.
>> If unsuccessful method returns -1 and set errno accordingly.
>> If successful method returns 0
>>=20
>>=20
>> Where:
>>=20
>>=20
>> struct ibv_query_counter_set_attr {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
uint32_t=A0=A0=A0=A0=A0=A0=A0=A0=A0 comp_mask
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
ibv_counter_set=A0=A0 *counter_set;
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
enum ibv_query_counter_set_attr_params=A0 *query_params;
>> }
>>=20
>>=20
>> enum ibv_query_counter_set_attr_params {
>>=A0=A0=A0=A0=A0=A0=A0=A0 // force hardware query instead of cached value
>>=A0=A0=A0=A0=A0=A0=A0=A0 IBV_COUNTER_FORCE_UPDATE=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 =3D 1 <<=A0 1
>> };
>>=20
>>=20
>>=20
>>=20
>> int ibv_query_counter_set_description(struct ibv_context *context, \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t counter_set_id, \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_counter_set_descripti=
on * out)
>>=20
>> Method writes out a struct ibv_counter_set_description which contains a =
description
>> of a counter-set.
>> User should allocate sizeof(struct ibv_counter_set_description) for *out=
;
>>=20
>>=20
>> - return 0 on success
>> - return -1 when counter_set_id is invalid.
>>=20
>>=20
>>=20
>>=20
>> Example on using counter_sets:
>>=20
>>=20
>>=20
>>=20
>> void foo(struct ibv_context *context, int counter_set_id)
>> {
>>=A0=A0=A0=A0=A0=A0=A0=A0 // an array of attributes. this is a container o=
f counter-set values
>>=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t my_counter[256];
>>=20
>>=A0=A0=A0=A0=A0=A0=A0 struct ibv_counter_set_description my_description;
>>=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_counter_set* my_counter_set ;
>>=20
>>=A0=A0=A0=A0=A0=A0=A0 ibv_query_counter_set_description(context, counter_=
set_id, &my_description);
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0 my_counter_set =3D ibv_create_counter_set(contex=
t,counter_set_id);
>>=20
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0 // let's define the query object
>>=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_query_counter_set_attr my_query;
>>=A0=A0=A0=A0=A0=A0=A0=A0 my_query.comp_mask =3D 0;
>>=A0=A0=A0=A0=A0=A0=A0=A0 my_query.counter_set =3D &my_counter_set;
>>=A0=A0=A0=A0=A0=A0=A0=A0 my_query.query_params =3D 0;
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0 // finally - do the query.
>>=20
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 if(-1 =3D=3D ibv_query_counter_set(my_query, =
my_counter)) {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("query failed")
>>=A0=A0=A0=A0=A0=A0=A0=A0 }
>>=A0=A0=A0=A0=A0=A0=A0=A0 else=A0 {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for(int i =3D 0 ; =
i < my_description->entries_count ; ++i)=A0=A0 {
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("name %d =3D %lu, \
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
my_description->entries[i].name, my_counter[i]);
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>=A0=A0=A0=A0=A0=A0=A0=A0 }
>> }
>>
>>I like this solution, even though I was aiming for a different problem :-=
).
>>
>>Regarding this solution. It allows polling statistics from the driver/har=
dware
>>per demand in a generic way. Generic means in this case - the number,
>>the scope and the meaning of the statistics. I understand that it assumes
>>that the resources to count these statistics are limited and hence the us=
age
>>should be only after allocation by the "user".
>>It isn't clear to me if the user is the application or libibverbs. Anyway=
, some
>>Cleanup should be considered to avoid driver/HW resources being wasted
>>due to improper behavior. If the NIC's HW supports this then the implicat=
ions
>>on the performance is little. If it doesn't, then it is up to the vendor =
to decide
>>if to support and to what extent.
>>The vendor should be able to decide what scope it allows/supports.
>>I'm not sure what is the added value of caching statistics.
>>
>>I'm not sure how this would relate to "rdmatool - tool for RDMA users" [1=
].
>>Is this an alternative or parallel solution? Will the code be re-usable?
>>
>>Regarding what issue was planning to focus on, I will comment in Alex's e=
-mail.
>>
>>Thanks,
>>Ram
>>
>>[1] https://www.spinics.net/lists/linux-rdma/msg45250.html

Hi Ram,
I'm glad to know that you like this solution.
However, I believe that we were aiming for the same thing. trying to know=20
more about the QP/Connection. What I offered in this RFC is a generic infra=
structure
to be utilized by the vendors to implement a solution that suits your needs=
.

as for your concerns,
the user is the programmer who is utilizing the newly suggested verbs inter=
face
to know more about the system.
Cleanup is supported as intergal part of the API (destroy_counter_set)
and it is part of the user responsability to free resources.
it is up to the vendor to make sure resources are not getting wasted.
for example - if a user attached (binds) a counter_set to QP and the progra=
m terminates.
I expect the vendor to make sure their driver releases hardware resources f=
or both the QP
and the attached counter_set. if the vendor fails to release any resources =
it is=20
resources leak.=20

the took you mentioned in [1] could possibly utilize the interface I sugges=
ted
in order to supply more information and/or statistics about the system.

for examle, the tool you mentioned describes the following actions:
[1] Query RDMA device capabilities
- capabilities are constant values/attributes, hence counter_set do not fit=
 this option.
[2] Query RDMA device status and current open resources
- status and least of open resources:
  I could think of a counter_set that is binded to the ibv_context and brin=
g
  a with values, such as number of open QPs and other resources.
[3] Fetching RDMA statistics
- the suggested API fits  RDMA statistics very well and is capable of fulfi=
lling these needs.
[4] Configure RDMA device
- sorry, the API suggested here is 'read-only'. maybe someone else will off=
er a generic API
  to configure. however - it is out of the scope of the suggested API.


re=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
