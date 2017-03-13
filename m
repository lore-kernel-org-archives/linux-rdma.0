From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC v1 for verbs counters]
Date: Mon, 13 Mar 2017 20:36:45 +0000
Message-ID: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


RFC: Verbs Counters


There is a constant demand to know about connections used in verbs (and and=
 other aspects).
Some vendors have been offering hardware counters for a long time by using =
sysfs.=20
Those counters, however - are not available per connection but for the whol=
e system.

One way to do it is for each vendor to offer their vendor specific counters=
, which will probably
 not be generic since each vendor could have their own implementation of co=
unters hence
 the verbs interface will not be generic for the rest of them.=20


We present a generic interface for using counters in verbs.
Let's have some definition before going into details:

Object:          an existing structure in verbs which describes physical en=
tity
                                 e.g.: QP/FLOW/DEVICE/
Counter:         a single attribute which is use to count events/statistics
                                 on object
Counter-set:     a set of counters that belongs to one specific object.


A generic interface with  following functionality is presented :


1.      A way to list of all the available counter-sets in the device.
        Per each counter-set:
        - What do the counters within the set measure? is it QP? Flow? othe=
r?
        - A Unique identifier per counter-set.
        - A list of names for all the counters within each counter-set.
           since each vendor has their own counters/stats. Each vendor=20
           could use their own names for a counter. This suggestion=20
           aims to replace vendor-specific-api with predefined=20
           enums/names for each counter/stats.
        - Additional Meta-data about a counter-set (for example - is it cac=
hed?)
       =20
2.      Operations available per counter-set:
2.1     Bind and unbind:
        a counter-set has to be attached to an object in order for any
        counter within a counter-set to count. the attaching action
        is referred to as 'bind' and the opposite action is referred to
        as 'unbind'.
        Rather than having specific generic operation for bind and unbind=20
        I choose to use existing verbs methods. The existing methods could=
=20
        be modified with small changes (like adding a new flag) to bind=20
        (or unbind) a counter-set to an object.


2.2     Counter-set may be created: counter-set instance is allocated and=20
          created on a ibv context and belongs to that context.

2.3     Counter-set may be destroyed: counter-set instance is destroyed and=
=20
        de-allocated. If counter-set is bonded to object then it is the=20
        responsibility of the driver either to unbind prior to  hardware=20
        de-allocation or to notify the user that driver is unable to destro=
y=20
        a counter-set and it is the user responsibility to unbind prior to=
=20
        destruction.

2.4     Counter-set may be queried:  the user supply counter-set instance a=
nd=20
        output address. The hardware queries the counter-set and writes the=
=20
        output to the  address as an array of uint64_t. Each entry in the=20
        uint64_t array represents a single counter.=20


The user is expected to query the device on startup,=20
   find which counter-sets are supported and to which objects
   each counter-set may be bonded. During this scan the user
    also finds out which counters are supported for which object.
       =20
Example for a way to list of all the available counter-sets in the device.


We modify the method  int query_device_ex() by adding a new flag to the=20
enum ibv_device_attr_mask:


+          IBV_DEVICE_ATTR_COUNTER_SET        =3D 1 <<  1


When using this flag, the device will response with struct ibv_device_attr_=
ex
with a new attribute:


+          uint64_t      max_supported_counter_sets;


And then a user can use a new API to get the description for each counter-s=
et.
number of counter set is specified by a counter-set-id.
a counter-set id is a number from 0 to max_supported_counter_sets.
that is - the number returned from the query_device_ex() call.


int ibv_query_counter_set_description(struct ibv_context *context, \
                                      uint64_t counter_set_id, \
                                      struct ibv_counter_set_description * =
out)
- return 0 on success
- return -1 when counter_set_id is invalid.


The API writes to out the following structure:


struct ibv_counter_set_description {
            // Which type does this set refers to?                         =
                    =20
            // value is taken from enum ibv_counter_set_counted_type =20
                        uint8_t            counted_type;                   =
                 =20
            // Number of instances of this counter-set available in the har=
dware
                        uint64_t           number_of_counter_sets;         =
         =20
            // Attributes of the set (bit mask)
            // value is taken from enum ibv_counter_set_attributes
                        uint32_t           attributes;                     =
                                              =20
            // number of entries
                        uint8_t              entries_count;
            // List of entries,=20
                        struct ibv_counter_entry  entry[256];             =
=20
            }


Where:
struct ibv_counter_entry {
	     // name of the entry. last entry contains NULL
             char       name[32];
}          =20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D


Brief explanation for the fields inside struct ibv_counter_set_description:


counted_type - contain id for which this counter_set is related to.
the id is a value from ibv_counter_set_counted_type  (see below)
Each counter-set relates to a verbs object, which is the verbs object this=
=20
counter-set aim to count (i.e. measure), such as QP or Flow.


enum  ibv_counter_set_counted_type  {
                IBV_COUNTER_IBV_QP =3D 0,
                IBV_COUNTER_IBV_FLOW,
                ...
                }

number_of_counter_sets - how many counters does this device supports?
Note that this value can be interpreted in more than one way. Either how ma=
ny=20
counter_sets are currently available or what is the total (max) number of=20
counter_sets the device supports. this is seen as the max limit of count-se=
t
which the process is allowed to create.


attributes   - special attributes which this counter-set might have=20
either in software or hardware.=20
For example we can have cached counter-set. Which means that every query=20
for that set is read from the cache. Unless a request to read the values fr=
om=20
the hardware was specially specified.


enum ibv_counter_set_attributes {
         // the counter-set value is cached by default=20
          IBV_COUNTER_ATTR_CACHED                         =3D 1 <<  1  =20
};


entries_count - number of entries in the counter_set

struct ibv_counter_entry  entry[256] - an ordered list of counter names
           where the last name in the array is empty (NULL)

=3D=3D=3D=3D


Example:




ibv_counter_set_description is a struct to describe other structs.
                for example, we have the following struct:


                private struct guy_counter {
                                uint64_t apples_kg;
                                uint64_t apples_count;
                }


               =20
                - note that all counters are 64bit entries
               =20
                The ibv_counter_set_desc looks like this:
                   // according to the ibv_counter_set_type enum
                ibv_counter_set_desc.type =3D IBV_COUNTER_IBV_GUYGUY       =
                               =20
                ibv_counter_set_desc.attributes =3D 0;
                ibv_counter_set_desc.number_of_counter_sets =3D 1000;
                ibv_counter_set_desc.entry[0].name =3D  "apples [Kg]"
                ibv_counter_set_desc.entry[1].name =3D  "apples [Count]"
                ibv_counter_set_desc.entry[2].name =3D  \0
               =20
=3D=3D=3D=3D


How to fill the internal tables?


On initialization - driver should query device capabilities to see how many=
=20
                    counter-set are supported. for each  supported=20
                    counter-set the driver will act as following:
1. Allocate counter_set_id=20
2. Register counter_set_id with pointer to data structures with list of cou=
nters.
5. Finally - The driver returns number of counter_sets supported in ibv_qeu=
ry_device_ex()




Operations available for each counter-set:
Each ibv_counter is represented by the following structure:


struct ibv_counter_set {
        struct ibv_context       *context;
        uint64_t                 handle; =20
}




THE NEW API


struct ibv_counter_set* ibv_create_counter_set(struct ibv_context *context,=
  \
                        uint16_t counter_set_id)


Method returns struct ibv_counter_set which contains context+handle.
Actions: Method Allocates memory for struct ibv_counter_set and then calls=
=20
the driver to allocate the actual hardware counter-set.
If successful method returns pointer to struct ibv_counter_set on the heap
which contains context+handle.
If unsuccessful - method returns NULL and set errno accordingly.


int ibv_destroy_counter_set(struct ibv_counter_set* counter_set)


Methods destroys input counter_set and free the allocated memory.
Actions: Method attempts to remove hardware counter-set and then input stru=
ct=20
is released (deleted). In the kernel the code checks if caller is=20
allowed to destroy counter_set (by comparing pid) and then released=20
hardware-resource.


If unsuccessful method returns -1 and set errno accordingly.=20
If successful method returns 0.


int ibv_query_counter_set(struct ibv_query_counter_set_attr, uint64_t * out=
)

Method receives query structure and output address, then query the=20
hardware and writes output to the uint64_t * out address.
Actions: Method recives  struct ibv_query_counter_set_attr, parse the query
and then send it to execution in kernel.
In the kernel the code checks if caller is allowed to query
the hardware, executes the query and then writes to *out.
If unsuccessful method returns -1 and set errno accordingly.=20
If successful method returns 0


Where:


struct ibv_query_counter_set_attr {
                        uint32_t          comp_mask
                        ibv_counter_set   *counter_set;
                        enum ibv_query_counter_set_attr_params  *query_para=
ms;
}


enum ibv_query_counter_set_attr_params {
        // force hardware query instead of cached value
        IBV_COUNTER_FORCE_UPDATE                =3D 1 <<  1 =20
};




int ibv_query_counter_set_description(struct ibv_context *context, \
                                      uint64_t counter_set_id, \
                                      struct ibv_counter_set_description * =
out)

Method writes out a struct ibv_counter_set_description which contains a des=
cription=20
of a counter-set.=20
User should allocate sizeof(struct ibv_counter_set_description) for *out;


- return 0 on success
- return -1 when counter_set_id is invalid.




Example on using counter_sets:




void foo(struct ibv_context *context, int counter_set_id)=20
{
        // an array of attributes. this is a container of counter-set value=
s
        uint64_t my_counter[256];

	struct ibv_counter_set_description my_description;
        struct ibv_counter_set* my_counter_set ;

	ibv_query_counter_set_description(context, counter_set_id, &my_description=
);
               =20
        my_counter_set =3D ibv_create_counter_set(context,counter_set_id);


        // let's define the query object
        struct ibv_query_counter_set_attr my_query;
        my_query.comp_mask =3D 0;
        my_query.counter_set =3D &my_counter_set;
        my_query.query_params =3D 0;
               =20
        // finally - do the query.
       =20
         if(-1 =3D=3D ibv_query_counter_set(my_query, my_counter)) {
                printf("query failed")
        }
        else  {
                  for(int i =3D 0 ; i < my_description->entries_count ; ++i=
)   {
                                 printf("name %d =3D %lu, \
                        my_description->entries[i].name, my_counter[i]);=20
                  }
        }
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
