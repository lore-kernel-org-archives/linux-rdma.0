From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [RFC v1 for verbs counters]
Date: Wed, 15 Mar 2017 11:48:26 +0000
Message-ID: <SN1PR07MB2207216EF4161F94ED6EC288F8270@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM5PR0502MB30578E5BC54125D013D416DCBD250-Z3o2H//EDN55ESpK+8MyGMDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> RFC: Verbs Counters
>=20
>=20
> There is a constant demand to know about connections used in verbs (and a=
nd other aspects).
> Some vendors have been offering hardware counters for a long time by usin=
g sysfs.
> Those counters, however - are not available per connection but for the wh=
ole system.
>=20
> One way to do it is for each vendor to offer their vendor specific counte=
rs, which will probably
>  not be generic since each vendor could have their own implementation of =
counters hence
>  the verbs interface will not be generic for the rest of them.
>=20
>=20
> We present a generic interface for using counters in verbs.
> Let's have some definition before going into details:
>=20
> Object:          an existing structure in verbs which describes physical =
entity
>                                  e.g.: QP/FLOW/DEVICE/
> Counter:         a single attribute which is use to count events/statisti=
cs
>                                  on object
> Counter-set:     a set of counters that belongs to one specific object.
>=20
>=20
> A generic interface with  following functionality is presented :
>=20
>=20
> 1.      A way to list of all the available counter-sets in the device.
>         Per each counter-set:
>         - What do the counters within the set measure? is it QP? Flow? ot=
her?
>         - A Unique identifier per counter-set.
>         - A list of names for all the counters within each counter-set.
>            since each vendor has their own counters/stats. Each vendor
>            could use their own names for a counter. This suggestion
>            aims to replace vendor-specific-api with predefined
>            enums/names for each counter/stats.
>         - Additional Meta-data about a counter-set (for example - is it c=
ached?)
>=20
> 2.      Operations available per counter-set:
> 2.1     Bind and unbind:
>         a counter-set has to be attached to an object in order for any
>         counter within a counter-set to count. the attaching action
>         is referred to as 'bind' and the opposite action is referred to
>         as 'unbind'.
>         Rather than having specific generic operation for bind and unbind
>         I choose to use existing verbs methods. The existing methods coul=
d
>         be modified with small changes (like adding a new flag) to bind
>         (or unbind) a counter-set to an object.
>=20
>=20
> 2.2     Counter-set may be created: counter-set instance is allocated and
>           created on a ibv context and belongs to that context.
>=20
> 2.3     Counter-set may be destroyed: counter-set instance is destroyed a=
nd
>         de-allocated. If counter-set is bonded to object then it is the
>         responsibility of the driver either to unbind prior to  hardware
>         de-allocation or to notify the user that driver is unable to dest=
roy
>         a counter-set and it is the user responsibility to unbind prior t=
o
>         destruction.
>=20
> 2.4     Counter-set may be queried:  the user supply counter-set instance=
 and
>         output address. The hardware queries the counter-set and writes t=
he
>         output to the  address as an array of uint64_t. Each entry in the
>         uint64_t array represents a single counter.
>=20
>=20
> The user is expected to query the device on startup,
>    find which counter-sets are supported and to which objects
>    each counter-set may be bonded. During this scan the user
>     also finds out which counters are supported for which object.
>=20
> Example for a way to list of all the available counter-sets in the device=
.
>=20
>=20
> We modify the method  int query_device_ex() by adding a new flag to the
> enum ibv_device_attr_mask:
>=20
>=20
> +          IBV_DEVICE_ATTR_COUNTER_SET        =3D 1 <<  1
>=20
>=20
> When using this flag, the device will response with struct ibv_device_att=
r_ex
> with a new attribute:
>=20
>=20
> +          uint64_t      max_supported_counter_sets;
>=20
>=20
> And then a user can use a new API to get the description for each counter=
-set.
> number of counter set is specified by a counter-set-id.
> a counter-set id is a number from 0 to max_supported_counter_sets.
> that is - the number returned from the query_device_ex() call.
>=20
>=20
> int ibv_query_counter_set_description(struct ibv_context *context, \
>                                       uint64_t counter_set_id, \
>                                       struct ibv_counter_set_description =
* out)
> - return 0 on success
> - return -1 when counter_set_id is invalid.
>=20
>=20
> The API writes to out the following structure:
>=20
>=20
> struct ibv_counter_set_description {
>             // Which type does this set refers to?
>             // value is taken from enum ibv_counter_set_counted_type
>                         uint8_t            counted_type;
>             // Number of instances of this counter-set available in the h=
ardware
>                         uint64_t           number_of_counter_sets;
>             // Attributes of the set (bit mask)
>             // value is taken from enum ibv_counter_set_attributes
>                         uint32_t           attributes;
>             // number of entries
>                         uint8_t              entries_count;
>             // List of entries,
>                         struct ibv_counter_entry  entry[256];
>             }
>=20
>=20
> Where:
> struct ibv_counter_entry {
> 	     // name of the entry. last entry contains NULL
>              char       name[32];
> }
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
>=20
> Brief explanation for the fields inside struct ibv_counter_set_descriptio=
n:
>=20
>=20
> counted_type - contain id for which this counter_set is related to.
> the id is a value from ibv_counter_set_counted_type  (see below)
> Each counter-set relates to a verbs object, which is the verbs object thi=
s
> counter-set aim to count (i.e. measure), such as QP or Flow.
>=20
>=20
> enum  ibv_counter_set_counted_type  {
>                 IBV_COUNTER_IBV_QP =3D 0,
>                 IBV_COUNTER_IBV_FLOW,
>                 ...
>                 }
>=20
> number_of_counter_sets - how many counters does this device supports?
> Note that this value can be interpreted in more than one way. Either how =
many
> counter_sets are currently available or what is the total (max) number of
> counter_sets the device supports. this is seen as the max limit of count-=
set
> which the process is allowed to create.
>=20
>=20
> attributes   - special attributes which this counter-set might have
> either in software or hardware.
> For example we can have cached counter-set. Which means that every query
> for that set is read from the cache. Unless a request to read the values =
from
> the hardware was specially specified.
>=20
>=20
> enum ibv_counter_set_attributes {
>          // the counter-set value is cached by default
>           IBV_COUNTER_ATTR_CACHED                         =3D 1 <<  1
> };
>=20
>=20
> entries_count - number of entries in the counter_set
>=20
> struct ibv_counter_entry  entry[256] - an ordered list of counter names
>            where the last name in the array is empty (NULL)
>=20
> =3D=3D=3D=3D
>=20
>=20
> Example:
>=20
>=20
>=20
>=20
> ibv_counter_set_description is a struct to describe other structs.
>                 for example, we have the following struct:
>=20
>=20
>                 private struct guy_counter {
>                                 uint64_t apples_kg;
>                                 uint64_t apples_count;
>                 }
>=20
>=20
>=20
>                 - note that all counters are 64bit entries
>=20
>                 The ibv_counter_set_desc looks like this:
>                    // according to the ibv_counter_set_type enum
>                 ibv_counter_set_desc.type =3D IBV_COUNTER_IBV_GUYGUY
>                 ibv_counter_set_desc.attributes =3D 0;
>                 ibv_counter_set_desc.number_of_counter_sets =3D 1000;
>                 ibv_counter_set_desc.entry[0].name =3D  "apples [Kg]"
>                 ibv_counter_set_desc.entry[1].name =3D  "apples [Count]"
>                 ibv_counter_set_desc.entry[2].name =3D  \0
>=20
> =3D=3D=3D=3D
>=20
>=20
> How to fill the internal tables?
>=20
>=20
> On initialization - driver should query device capabilities to see how ma=
ny
>                     counter-set are supported. for each  supported
>                     counter-set the driver will act as following:
> 1. Allocate counter_set_id
> 2. Register counter_set_id with pointer to data structures with list of c=
ounters.
> 5. Finally - The driver returns number of counter_sets supported in ibv_q=
eury_device_ex()
>=20
>=20
>=20
>=20
> Operations available for each counter-set:
> Each ibv_counter is represented by the following structure:
>=20
>=20
> struct ibv_counter_set {
>         struct ibv_context       *context;
>         uint64_t                 handle;
> }
>=20
>=20
>=20
>=20
> THE NEW API
>=20
>=20
> struct ibv_counter_set* ibv_create_counter_set(struct ibv_context *contex=
t,  \
>                         uint16_t counter_set_id)
>=20
>=20
> Method returns struct ibv_counter_set which contains context+handle.
> Actions: Method Allocates memory for struct ibv_counter_set and then call=
s
> the driver to allocate the actual hardware counter-set.
> If successful method returns pointer to struct ibv_counter_set on the hea=
p
> which contains context+handle.
> If unsuccessful - method returns NULL and set errno accordingly.
>=20
>=20
> int ibv_destroy_counter_set(struct ibv_counter_set* counter_set)
>=20
>=20
> Methods destroys input counter_set and free the allocated memory.
> Actions: Method attempts to remove hardware counter-set and then input st=
ruct
> is released (deleted). In the kernel the code checks if caller is
> allowed to destroy counter_set (by comparing pid) and then released
> hardware-resource.
>=20
>=20
> If unsuccessful method returns -1 and set errno accordingly.
> If successful method returns 0.
>=20
>=20
> int ibv_query_counter_set(struct ibv_query_counter_set_attr, uint64_t * o=
ut)
>=20
> Method receives query structure and output address, then query the
> hardware and writes output to the uint64_t * out address.
> Actions: Method recives  struct ibv_query_counter_set_attr, parse the que=
ry
> and then send it to execution in kernel.
> In the kernel the code checks if caller is allowed to query
> the hardware, executes the query and then writes to *out.
> If unsuccessful method returns -1 and set errno accordingly.
> If successful method returns 0
>=20
>=20
> Where:
>=20
>=20
> struct ibv_query_counter_set_attr {
>                         uint32_t          comp_mask
>                         ibv_counter_set   *counter_set;
>                         enum ibv_query_counter_set_attr_params  *query_pa=
rams;
> }
>=20
>=20
> enum ibv_query_counter_set_attr_params {
>         // force hardware query instead of cached value
>         IBV_COUNTER_FORCE_UPDATE                =3D 1 <<  1
> };
>=20
>=20
>=20
>=20
> int ibv_query_counter_set_description(struct ibv_context *context, \
>                                       uint64_t counter_set_id, \
>                                       struct ibv_counter_set_description =
* out)
>=20
> Method writes out a struct ibv_counter_set_description which contains a d=
escription
> of a counter-set.
> User should allocate sizeof(struct ibv_counter_set_description) for *out;
>=20
>=20
> - return 0 on success
> - return -1 when counter_set_id is invalid.
>=20
>=20
>=20
>=20
> Example on using counter_sets:
>=20
>=20
>=20
>=20
> void foo(struct ibv_context *context, int counter_set_id)
> {
>         // an array of attributes. this is a container of counter-set val=
ues
>         uint64_t my_counter[256];
>=20
> 	struct ibv_counter_set_description my_description;
>         struct ibv_counter_set* my_counter_set ;
>=20
> 	ibv_query_counter_set_description(context, counter_set_id, &my_descripti=
on);
>=20
>         my_counter_set =3D ibv_create_counter_set(context,counter_set_id)=
;
>=20
>=20
>         // let's define the query object
>         struct ibv_query_counter_set_attr my_query;
>         my_query.comp_mask =3D 0;
>         my_query.counter_set =3D &my_counter_set;
>         my_query.query_params =3D 0;
>=20
>         // finally - do the query.
>=20
>          if(-1 =3D=3D ibv_query_counter_set(my_query, my_counter)) {
>                 printf("query failed")
>         }
>         else  {
>                   for(int i =3D 0 ; i < my_description->entries_count ; +=
+i)   {
>                                  printf("name %d =3D %lu, \
>                         my_description->entries[i].name, my_counter[i]);
>                   }
>         }
> }

I like this solution, even though I was aiming for a different problem :-).

Regarding this solution. It allows polling statistics from the driver/hardw=
are
per demand in a generic way. Generic means in this case - the number,
the scope and the meaning of the statistics. I understand that it assumes
that the resources to count these statistics are limited and hence the usag=
e
should be only after allocation by the "user".
It isn't clear to me if the user is the application or libibverbs. Anyway, =
some
Cleanup should be considered to avoid driver/HW resources being wasted
due to improper behavior. If the NIC's HW supports this then the implicatio=
ns
on the performance is little. If it doesn't, then it is up to the vendor to=
 decide
if to support and to what extent.
The vendor should be able to decide what scope it allows/supports.
I'm not sure what is the added value of caching statistics.

I'm not sure how this would relate to "rdmatool - tool for RDMA users" [1].
Is this an alternative or parallel solution? Will the code be re-usable?

Regarding what issue was planning to focus on, I will comment in Alex's e-m=
ail.

Thanks,
Ram

[1] https://www.spinics.net/lists/linux-rdma/msg45250.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
