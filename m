From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Thu, 15 Jun 2017 14:50:17 +0300
Message-ID: <CAAKD3BA+Bpwbx+pZivK_+jRLc9kCrvhQkPy4tKcaTqUZhfRiOg@mail.gmail.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373AB1436F6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1436F6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 On Wed, Jun 14, 2017 at 8:25 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Let's start from the root of the parsing tree. at the top level we
>> have the root of the parsing tree ("uverbs_spec_root"). The root has
>> several "type_groups", one for each "namespace".
>> Currently, two "namespace"s are declared - common and driver
>> ("vendor_chain" here, should be changed to "driver").
>> Each "type_group" contains a few "type"s. "type" has several
>> "action_group"s, one for each "namespace". Each "action_group"
>> contains several "action"s.
>> Each "action" contains groups of "attr_spec", one for each namespace.
>> Finally, "attr_spec" contains attributes ("attrs").
>> Each attribute is of one of the following classes: ptr_in, ptr_out,
>> idr or fd (in the future, we might add a few more like "flags").
>
> Again, I think the approach looks good.  I can see *how* the relationship=
s between structures are defined by looking at the struct definitions.  Wha=
t's not clear is *why* those relationships exist.  I really do think trying=
 to use standard object-oriented terminology helps convey the latter.
>
> Using a commonly known programming term (e.g. class, namespace) with a di=
fferent meaning makes it difficult to understand what's going on.  I don't =
want to get too buried in terminology here, but I do think that coming up w=
ith the best terms will simplify maintenance and make it easier for people =
to use.  I'm even fine with name changes coming as follow on patches, so th=
e entire series doesn't need to be reworked.
>

Following object oriented approach, I can think of the following
trivial changes:
type->class
action->method (actually, these are static methods, but nm)

Since I would like to differentiate between specifications and the
actual given data, I'll add the _spec suffix.

The "groups" concept is a bit harder to grasp in OO. In our case, an
entity is actually divided into a few "groups" and its actual content
is the unification of these groups.
You could think of it as a derived class with multiple inheritance
from bases classes, where you have a base class for each "group":

class cq: public cq_common, public cq_mlx5
{
}

In contrast of the OO multiple inheritance case, we have a specific
meaning to the order of these groups - the handler actually uses them.
When the method handler is called, it gets an array of "argument
groups". Each element in this array contains another array of all the
arguments in this specific group.
For example,
common_attrs_array =3D &uverbs_attr_array[UVERBS_NAMESPACE_COMMON];
first_attr =3D common_attrs_array[0];

Maybe we could use the term "namespace" here, as what we are actually
doing here is giving the common and driver different namespaces inside
the same entity (avoid collision between the derived classes in the
multiple inheritance).
This is not the "namespace" terminology in OO, but it fits what we're
actually doing here.
What do you think on the following?

/*
 * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 *    Verbs action specifications
 * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 */

#define UVERBS_ID_NS_MASK 0xF000
#define UVERBS_ID_NS_SHIFT 12

enum uverbs_attr_type {
    UVERBS_ATTR_TYPE_NA,
    UVERBS_ATTR_TYPE_PTR_IN,
    UVERBS_ATTR_TYPE_PTR_OUT,
    UVERBS_ATTR_TYPE_OBJECT_ID,
    UVERBS_ATTR_TYPE_FD_NUM,
};

enum uverbs_obj_access {
    UVERBS_ACCESS_READ,
    UVERBS_ACCESS_WRITE,
    UVERBS_ACCESS_NEW,
    UVERBS_ACCESS_DESTROY
};

struct uverbs_attr_spec {
    enum uverbs_attr_type        type;
    <...>
};

struct uverbs_attr_spec_ns {
    struct uverbs_attr_spec        *attrs;
    <...>
};

struct uverbs_method_spec {
    struct uverbs_attr_spec_ns            **attr_ns;
    size_t                                             num_ns;
    <...>
};

struct uverbs_method_ns_spec {
    size_t                                     num_methods;
    struct uverbs_method_spec       **methods;
};

struct uverbs_class_spec {
    size_t                                             num_ns;
    const struct uverbs_method_ns_spec    **method_ns;
    /* Attributes of objects created of this class. Contains obj_size,
destroy_order and the type_class which are either idr/fd */
    const struct uverbs_obj_type           *type_attrs;
};

struct uverbs_class_ns_spec {
    size_t                                       num_ns;
    const struct uverbs_class_spec  **classes;
};

struct uverbs_root_spec {
    const struct uverbs_class_ns_spec  **class_ns;
    size_t                                           num_ns;
};


> If no one else cares what things are called, we can just move on.  But I =
wonder if the lack of review of this series isn't a reflection on how much =
effort it takes to understand what's happening.
>
>

I'm sure we can agree on some acceptable terminology. If it helps
other to convey the reason and usage for this design, it's even
welcomed.

>> > Assuming my understanding is correct (and I haven't read through the
>> rest of the patches yet), then I would suggest using these terms
>> instead (based on standard OO design terminology):
>> >
>> > type_group -> namespace (?)
>>
>> I currently use "namespace" term to differentiate between the groups
>> of the entities. For example, in each layer of the hierarchy we
>> (possibly) have a namespace of common entities and driver-specific
>> entities.
>>
>> > type -> class or obj_class
>>
>> I use the term "class" for the nature of the actual attributes
>> ("attrs"). Each attribute is one of the following classes: idr, fd,
>> ptr_in or ptr_out.
>>
>> > action_group -> operations or methods or functions
>> > action -> op_def or method_def or func_def
>> > attr_spec_group -> param_list or op_param_list or func_param_list
>> ...
>>
>> I used the term "group" to emphasize that these aren't just a random
>> collection of params in a lit.
>> Grouping this entities together has a specific meaning.
>
> But *what* is that meaning?  That's what I'd like the name to convey.  I =
thought the grouping was because the attributes were a set of parameters be=
ing passed into a single function/operation/action/method.
>
>

Entities were grouped together because they belong to the same
namespace. If we take the attributes for an example, once we execute
the method's handler, we get one group of attributes for the common
namespace
and another one for the driver namespace. By using namespaces, we
could introduce new arguments for either common and driver specific
without stepping on other attributes in different namespaces.
When reaching the handler, each argument has a unique meaning. Please
see the uverbs_attr_array example above.

>> > common_chain -> common_params
>> > vendor_chain -> vendor_params
>>
>> I agree the term "chain" is problematic. Regarding the drawing above -
>> "common_params" and "driver_params" seems fine.
>>
>> > nit: attr_spec -> attr_def
>>
>> Actually, the term "spec" is used all over the code in order to
>> emphasize this is a specification the kernel is using for parsing.
>
> I'm far more indifferent to spec vs def.
>
>> > TYPE_IDR -> TYPE_KOBJ (kernel object)
>> >
>>
>> What about fds (like completion_channel)? They're KOBJs too.
>
> How about KSTRUCT or IDR_OBJ?  The fact that we're using an IDR seems lik=
e an internal implementation detail of the framework.
>
>

Jason suggested UVERBS_ATTR_TYPE_OBJECT_ID and UVERBS_ATTR_TYPE_FD_NUM.
I think it make sense and it captures that a fd has some special linux
(posix) mechanics.

>> I don't have an objection coming up with a better name-schema that
>> captures the subtle details mentioned above :)
>>
>> > See other comments below.
>> >
>> >> diff --git a/include/rdma/uverbs_ioctl.h
>> b/include/rdma/uverbs_ioctl.h
>> >> index e06f4cf..7fed6d9 100644
>> >> --- a/include/rdma/uverbs_ioctl.h
>> >> +++ b/include/rdma/uverbs_ioctl.h
>> >> @@ -41,8 +41,13 @@
>> >>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >>   */
>> >>
>> >> +#define UVERBS_ID_GROUP_MASK 0xF000
>> >> +#define UVERBS_ID_GROUP_SHIFT 12
>> >> +
>> >>  enum uverbs_attr_type {
>> >>       UVERBS_ATTR_TYPE_NA,
>> >> +     UVERBS_ATTR_TYPE_PTR_IN,
>> >> +     UVERBS_ATTR_TYPE_PTR_OUT,
>> >>       UVERBS_ATTR_TYPE_IDR,
>> >
>> > This is really indicating that we're dealing with a kernel object of
>> some sort, not the actual indexer.
>> >
>>
>> Yeah, but FDs could represent kernel objects too. The meaning here are
>> kernel objects that resides in the idr.
>> What do you propose?
>>
>> >>       UVERBS_ATTR_TYPE_FD,
>> >>  };
>> >> @@ -54,29 +59,106 @@ enum uverbs_obj_access {
>> >>       UVERBS_ACCESS_DESTROY
>> >>  };
>> >>
>> >> +enum uverbs_attr_spec_flags {
>> >> +     UVERBS_ATTR_SPEC_F_MANDATORY    =3D 1U << 0,
>> >> +     /* Support extending attributes by length */
>> >> +     UVERBS_ATTR_SPEC_F_MIN_SZ       =3D 1U << 1,
>> >> +};
>> >
>> > Don't use named enums for bit flags.  The result of ORing flags ends
>> up as a non-enum value.
>> >
>>
>> Sure
>>
>> >> +
>> >>  struct uverbs_attr_spec {
>> >>       enum uverbs_attr_type           type;
>> >> -     struct {
>> >> -             /*
>> >> -              * higher bits mean the group and lower bits mean
>> >> -              * the type id within the group.
>> >> -              */
>> >> -             u16                     obj_type;
>> >> -             u8                      access;
>> >> -     } obj;
>> >> +     /* a combination of enum uverbs_attr_spec_flags */
>> >> +     u8                              flags;
>> >> +     union {
>> >> +             u16                             len;
>> >> +             struct {
>> >> +                     /*
>> >> +                      * higher bits mean the group and lower bits
>> mean
>> >> +                      * the type id within the group.
>> >> +                      */
>> >> +                     u16                     obj_type;
>> >> +                     u8                      access;
>> >> +             } obj;
>> >> +     };
>> >
>> > You mentioned trying to conserve space, but this layout will have 1
>> byte padding after flags and 3 bytes at the end.  Swapping flags to
>> the end should eliminate the padding
>> >
>>
>> Yep, thanks
>>
>> >>  };
>> >>
>> >>  struct uverbs_attr_spec_group {
>> >>       struct uverbs_attr_spec         *attrs;
>> >>       size_t                          num_attrs;
>> >> +     /* populate at runtime */
>> >> +     unsigned long                   *mandatory_attrs_bitmask;
>> >> +};
>> >
>> > I'm assuming that this references all the parameters for a given
>> method, so suggesting renaming to param_list.
>> >
>>
>> This implies changing all attrs->params (to keep the terms in sync).
>> Let's come with a clear schema for all entities.
>>
>> >> +
>> >> +struct uverbs_attr_array;
>> >> +struct ib_uverbs_file;
>> >> +
>> >> +enum uverbs_action_flags {
>> >> +     /*
>> >> +      * Action marked with this flag creates a context (or root
>> for
>> >> all
>> >> +      * objects).
>> >> +      */
>> >> +     UVERBS_ACTION_FLAG_CREATE_ROOT =3D 1U << 0,
>> >> +};
>> >
>> > Same comment as above regarding named enums.
>> >
>>
>> Sure, thanks.
>>
>> >> +
>> >> +struct uverbs_action {
>> >> +     struct uverbs_attr_spec_group
>> **attr_groups;
>> >> +     size_t                                          num_groups;
>> >> +     size_t
>> num_child_attrs;
>> >> +     /* Combination of bits from enum uverbs_action_flags */
>> >> +     u32 flags;
>> >> +     int (*handler)(struct ib_device *ib_dev, struct
>> ib_uverbs_file
>> >> *ufile,
>> >> +                    struct uverbs_attr_array *ctx, size_t num);
>> >> +};
>> >
>> > I think this is defining the function handler and parameters of a
>> single method.  Why is attr_groups **, rather than just *?
>> >
>>
>> It points to an array (defined somewhere). Each entry in this array is
>> a pointer to a uverbs_attr_spec_group (defined somewhere).
>> For example, in the driver's code we define a modified copy of the
>> create_cq operation, i.e. mlx5_create_cq_action.
>> mlx5_create_cq_action points to an array (usually unnamed, but let's
>> name it for the ease of discussion): mlx5_create_cq_attr_groups.
>> mlx5_create_cq_attr_groups is an array of 2 - the first is a pointer
>> to uverbs_common_create_cq_attrs and the second one is
>> mlx5_create_cq_attrs.
>>
>> >> +
>> >> +struct uverbs_action_group {
>> >> +     size_t                                  num_actions;
>> >> +     struct uverbs_action                    **actions;
>> >> +};
>> >> +
>> >> +struct uverbs_type {
>> >> +     size_t                                  num_groups;
>> >> +     const struct uverbs_action_group        **action_groups;
>> >> +     const struct uverbs_obj_type            *type_attrs;
>> >> +};
>> >
>> > Conceptually, I think this is representing an object-oriented class;
>> consider renaming type to class.  Similar to my question above, why is
>> action_groups **, rather than *?  Actually, why doesn't this just
>> reference an array of uverbs_action?  The extra layers of indirection
>> to **actions_groups -> ** actions seems overly complex.
>
> Thanks -- I see the reason for the extra indirection.  I'll see if I can =
think of a way to flatten things, but I'm doubtful.
>
> - Sean

Thanks for reviewing.

- Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
