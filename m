From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Wed, 14 Jun 2017 11:39:31 +0300
Message-ID: <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB143340-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 1:48 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> In this ioctl interface, processing the command starts from
>> properties of the command and fetching the appropriate user objects
>> before calling the handler.
>>
>> Parsing and validation is done according to a specifier declared by
>> the driver's code. In the driver, all supported types are declared.
>> These types are separated to different type groups, each could be
>> declared in a different place (for example, common types and driver
>> specific types).
>>
>> For each type we list all supported actions. Similarly to types,
>> actions are separated to actions groups too. Each group is declared
>> separately. This could be used in order to add actions to an existing
>> type.
>>
>> Each action has a specific handler, which could be either a common
>> handler or a driver specific handler.
>> Along with the handler, a group of attributes is specified as well.
>> This group lists all supported attributes and is used for automatic
>> fetching and validation of the command, response and its related
>> objects.
>>
>> When a group of elements is used, the high bits of the elements ids
>> are used in order to calculate the group index. Then, these high bits
>> are masked out in order to have a zero based namespace for every
>> group. This is mandatory for compact representation and O(1) array
>> access.
>>
>> A group of attributes is actually an array of attributes. Each
>> attribute has a type (PTR_IN, PTR_OUT, IDR and FD) and a length.
>> Attributes could be validated through some attributes, like:
>> (*) Minimum size / Exact size
>> (*) Fops for FD
>> (*) Object type for IDR
>>
>> If an IDR/fd attribute is specified, the kernel also states the object
>> type and the required access (NEW, WRITE, READ or DESTROY).
>> All uobject/fd management is done automatically by the infrastructure,
>> meaning - the infrastructure will fail concurrent commands that at
>> least one of them requires concurrent access (WRITE/DESTROY),
>> synchronize actions with device removals (dissociate context events)
>> and take care of reference counting (increase/decrease) for concurrent
>> actions invocation. The reference counts on the actual kernel objects
>> shall be handled by the handlers.
>>
>>  types
>> +--------+
>> |        |
>> |        |   actions
>> +--------+
>> |        |   group      action      action_spec
>> +-----+   |len     |
>> +--------+  +------+[d]+-------+   +----------------+[d]+------------+
>> |attr1+-> |type    |
>> | type   +> |action+-> | spec  +-> +  attr_groups   +->
>> |common_chain+--> +-----+   |idr_type|
>> +--------+  +------+   |handler|   |                |   +------------+
>> |attr2|   |access  |
>> |        |  |      |   +-------+   +----------------+   |vendor chain|
>> +-----+   +--------+
>> |        |  |      |                                    +------------+
>> |        |  +------+
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> |        |
>> +--------+
>
> Architecturally, this looks decent.
>
> It took me a few times reading through this before I could start to under=
stand what this is describing though.  (And I'm still not sure I'm there). =
 I think part of the problem is that this patch introduces terms for abstra=
ct concepts that don't easily convey the intent.  (At least they didn't to =
me.)  Simply changing some of the terms may help people figure out how to u=
se this.
>
> At the top-level ("type"), I think you're describing the concept of an ob=
ject-oriented class.  Each class contains a set ("action group") of methods=
 or operations ("action").  An operation takes a set of parameters ("action=
_spec").  Some parameters are common ("common_chain") and some vendor speci=
fic ("vendor_chain").  Each parameter is a some data type ("attr").  Please=
 confirm if this is correct.
>

Let's start from the root of the parsing tree. at the top level we
have the root of the parsing tree ("uverbs_spec_root"). The root has
several "type_groups", one for each "namespace".
Currently, two "namespace"s are declared - common and driver
("vendor_chain" here, should be changed to "driver").
Each "type_group" contains a few "type"s. "type" has several
"action_group"s, one for each "namespace". Each "action_group"
contains several "action"s.
Each "action" contains groups of "attr_spec", one for each namespace.
Finally, "attr_spec" contains attributes ("attrs").
Each attribute is of one of the following classes: ptr_in, ptr_out,
idr or fd (in the future, we might add a few more like "flags").

> Assuming my understanding is correct (and I haven't read through the rest=
 of the patches yet), then I would suggest using these terms instead (based=
 on standard OO design terminology):
>
> type_group -> namespace (?)

I currently use "namespace" term to differentiate between the groups
of the entities. For example, in each layer of the hierarchy we
(possibly) have a namespace of common entities and driver-specific
entities.

> type -> class or obj_class

I use the term "class" for the nature of the actual attributes
("attrs"). Each attribute is one of the following classes: idr, fd,
ptr_in or ptr_out.

> action_group -> operations or methods or functions
> action -> op_def or method_def or func_def
> attr_spec_group -> param_list or op_param_list or func_param_list ...

I used the term "group" to emphasize that these aren't just a random
collection of params in a lit.
Grouping this entities together has a specific meaning.

> common_chain -> common_params
> vendor_chain -> vendor_params

I agree the term "chain" is problematic. Regarding the drawing above -
"common_params" and "driver_params" seems fine.

> nit: attr_spec -> attr_def

Actually, the term "spec" is used all over the code in order to
emphasize this is a specification the kernel is using for parsing.

> TYPE_IDR -> TYPE_KOBJ (kernel object)
>

What about fds (like completion_channel)? They're KOBJs too.

I don't have an objection coming up with a better name-schema that
captures the subtle details mentioned above :)

> See other comments below.
>
>> diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
>> index e06f4cf..7fed6d9 100644
>> --- a/include/rdma/uverbs_ioctl.h
>> +++ b/include/rdma/uverbs_ioctl.h
>> @@ -41,8 +41,13 @@
>>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   */
>>
>> +#define UVERBS_ID_GROUP_MASK 0xF000
>> +#define UVERBS_ID_GROUP_SHIFT 12
>> +
>>  enum uverbs_attr_type {
>>       UVERBS_ATTR_TYPE_NA,
>> +     UVERBS_ATTR_TYPE_PTR_IN,
>> +     UVERBS_ATTR_TYPE_PTR_OUT,
>>       UVERBS_ATTR_TYPE_IDR,
>
> This is really indicating that we're dealing with a kernel object of some=
 sort, not the actual indexer.
>

Yeah, but FDs could represent kernel objects too. The meaning here are
kernel objects that resides in the idr.
What do you propose?

>>       UVERBS_ATTR_TYPE_FD,
>>  };
>> @@ -54,29 +59,106 @@ enum uverbs_obj_access {
>>       UVERBS_ACCESS_DESTROY
>>  };
>>
>> +enum uverbs_attr_spec_flags {
>> +     UVERBS_ATTR_SPEC_F_MANDATORY    =3D 1U << 0,
>> +     /* Support extending attributes by length */
>> +     UVERBS_ATTR_SPEC_F_MIN_SZ       =3D 1U << 1,
>> +};
>
> Don't use named enums for bit flags.  The result of ORing flags ends up a=
s a non-enum value.
>

Sure

>> +
>>  struct uverbs_attr_spec {
>>       enum uverbs_attr_type           type;
>> -     struct {
>> -             /*
>> -              * higher bits mean the group and lower bits mean
>> -              * the type id within the group.
>> -              */
>> -             u16                     obj_type;
>> -             u8                      access;
>> -     } obj;
>> +     /* a combination of enum uverbs_attr_spec_flags */
>> +     u8                              flags;
>> +     union {
>> +             u16                             len;
>> +             struct {
>> +                     /*
>> +                      * higher bits mean the group and lower bits mean
>> +                      * the type id within the group.
>> +                      */
>> +                     u16                     obj_type;
>> +                     u8                      access;
>> +             } obj;
>> +     };
>
> You mentioned trying to conserve space, but this layout will have 1 byte =
padding after flags and 3 bytes at the end.  Swapping flags to the end shou=
ld eliminate the padding
>

Yep, thanks

>>  };
>>
>>  struct uverbs_attr_spec_group {
>>       struct uverbs_attr_spec         *attrs;
>>       size_t                          num_attrs;
>> +     /* populate at runtime */
>> +     unsigned long                   *mandatory_attrs_bitmask;
>> +};
>
> I'm assuming that this references all the parameters for a given method, =
so suggesting renaming to param_list.
>

This implies changing all attrs->params (to keep the terms in sync).
Let's come with a clear schema for all entities.

>> +
>> +struct uverbs_attr_array;
>> +struct ib_uverbs_file;
>> +
>> +enum uverbs_action_flags {
>> +     /*
>> +      * Action marked with this flag creates a context (or root for
>> all
>> +      * objects).
>> +      */
>> +     UVERBS_ACTION_FLAG_CREATE_ROOT =3D 1U << 0,
>> +};
>
> Same comment as above regarding named enums.
>

Sure, thanks.

>> +
>> +struct uverbs_action {
>> +     struct uverbs_attr_spec_group                   **attr_groups;
>> +     size_t                                          num_groups;
>> +     size_t                                          num_child_attrs;
>> +     /* Combination of bits from enum uverbs_action_flags */
>> +     u32 flags;
>> +     int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file
>> *ufile,
>> +                    struct uverbs_attr_array *ctx, size_t num);
>> +};
>
> I think this is defining the function handler and parameters of a single =
method.  Why is attr_groups **, rather than just *?
>

It points to an array (defined somewhere). Each entry in this array is
a pointer to a uverbs_attr_spec_group (defined somewhere).
For example, in the driver's code we define a modified copy of the
create_cq operation, i.e. mlx5_create_cq_action.
mlx5_create_cq_action points to an array (usually unnamed, but let's
name it for the ease of discussion): mlx5_create_cq_attr_groups.
mlx5_create_cq_attr_groups is an array of 2 - the first is a pointer
to uverbs_common_create_cq_attrs and the second one is
mlx5_create_cq_attrs.

>> +
>> +struct uverbs_action_group {
>> +     size_t                                  num_actions;
>> +     struct uverbs_action                    **actions;
>> +};
>> +
>> +struct uverbs_type {
>> +     size_t                                  num_groups;
>> +     const struct uverbs_action_group        **action_groups;
>> +     const struct uverbs_obj_type            *type_attrs;
>> +};
>
> Conceptually, I think this is representing an object-oriented class; cons=
ider renaming type to class.  Similar to my question above, why is action_g=
roups **, rather than *?  Actually, why doesn't this just reference an arra=
y of uverbs_action?  The extra layers of indirection to **actions_groups ->=
 ** actions seems overly complex.
>

The problem with class is that it's already used for attribute classes
(idr, fd, ptr_in, ptr_out and in the future maybe "flags").
The pointer-to-pointer schema is used for the exact same reason as
before. We have an array of pointers. For the sake of completion,
let's say the mlx5 driver adds a new action for type cq, so we'll
have:
mlx5_cq.action_groups -> point to an array of pointers of
action_group(s), let's say mlx5_cq_action_groups.
mlx5_cq_action_groups is an array of two pointers, the first is to
uverbs_common_cq_actions and the second is to mlx5_cq_actions.

>> +
>> +struct uverbs_type_group {
>> +     size_t                                  num_types;
>> +     const struct uverbs_type                **types;
>> +};
>> +
>> +struct uverbs_spec_root {
>> +     const struct uverbs_type_group          **type_groups;
>> +     size_t                                  num_groups;
>> +};
>
> Similar comments as above regarding **type_groups and **types.  Can we av=
oid the extra indirection, and maybe drop the action_group and type_group s=
tructures completely?  (If this is purely a space issue, we're only saving =
1-2 pointers worth of space).
>
>

We support 4 bits of namespaces (16 namespaces). Currently, we use
only 2 (common and driver), but obviously, this could let you have
some limited support of nested attributes (could be nice for example
for the flow-steering case).
The real reason for the indirection is to let you re-use entities that
were already defined in the common code. In order to do that, that
array of groups has to define "pointers to entities" and not the
entities themselves.
That currently mean that adding features would make drivers duplicate
this branch in their tree. However, for unchanged entities (types,
actions, attributes), they could still use the common pointers.
Once this goes in, we can introduce some function which merges special
features for drivers seamlessly - without the need to replicate that
structure (again - only the tree structure is currently replicated,
the data is stored as pointers which could be just used as
&uverbs_common_xxxx).

>> +
>> +/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> + *              Parsing infrastructure
>> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> + */
>> +
>> +struct uverbs_ptr_attr {
>> +     void    __user *ptr;
>> +     u16             len;
>>  };
>>
>>  struct uverbs_obj_attr {
>> +     /*
>> +      * pointer to the user-space given attribute, in order to write
>> the
>> +      * new uobject's id.
>> +      */
>> +     struct ib_uverbs_attr __user    *uattr;
>> +     /* pointer to the kernel descriptor -> type, access, etc */
>> +     const struct uverbs_obj_type    *type;
>>       struct ib_uobject               *uobject;
>> +     /* fd or id in idr of this object */
>> +     int                             id;
>>  };
>>
>>  struct uverbs_attr {
>> -     struct uverbs_obj_attr  obj_attr;
>> +     union {
>> +             struct uverbs_ptr_attr  ptr_attr;
>> +             struct uverbs_obj_attr  obj_attr;
>> +     };
>>  };
>>
>>  struct uverbs_attr_array {
>> diff --git a/include/uapi/rdma/rdma_user_ioctl.h
>> b/include/uapi/rdma/rdma_user_ioctl.h
>> index 9388125..3a40b9d 100644
>> --- a/include/uapi/rdma/rdma_user_ioctl.h
>> +++ b/include/uapi/rdma/rdma_user_ioctl.h
>> @@ -43,6 +43,30 @@
>>  /* Legacy name, for user space application which already use it */
>>  #define IB_IOCTL_MAGIC               RDMA_IOCTL_MAGIC
>>
>> +#define RDMA_VERBS_IOCTL \
>> +     _IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
>> +
>> +enum ib_uverbs_attr_flags {
>> +     UVERBS_ATTR_F_MANDATORY =3D 1U << 0,
>> +};
>
> Named enum for flags
>

Yeah

>> +
>> +struct ib_uverbs_attr {
>> +     __u16 attr_id;          /* command specific type attribute */
>> +     __u16 len;              /* only for pointers */
>> +     __u16 flags;            /* combination of ib_uverbs_attr_flags
>> */
>> +     __u16 reserved;
>> +     __u64 data;             /* ptr to command, inline data or idr/fd *=
/
>> +};
>> +
>> +struct ib_uverbs_ioctl_hdr {
>> +     __u16 length;
>> +     __u16 object_type;
>> +     __u16 action;
>> +     __u16 num_attrs;
>> +     __u64 reserved;
>> +     struct ib_uverbs_attr  attrs[0];
>> +};
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the review.
I hope this is clearer now. If you still think some of the terminology
should be changed, let's propose and discuss.

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
