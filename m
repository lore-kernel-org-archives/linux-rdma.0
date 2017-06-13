From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Tue, 13 Jun 2017 22:48:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In this ioctl interface, processing the command starts from
> properties of the command and fetching the appropriate user objects
> before calling the handler.
> 
> Parsing and validation is done according to a specifier declared by
> the driver's code. In the driver, all supported types are declared.
> These types are separated to different type groups, each could be
> declared in a different place (for example, common types and driver
> specific types).
> 
> For each type we list all supported actions. Similarly to types,
> actions are separated to actions groups too. Each group is declared
> separately. This could be used in order to add actions to an existing
> type.
> 
> Each action has a specific handler, which could be either a common
> handler or a driver specific handler.
> Along with the handler, a group of attributes is specified as well.
> This group lists all supported attributes and is used for automatic
> fetching and validation of the command, response and its related
> objects.
> 
> When a group of elements is used, the high bits of the elements ids
> are used in order to calculate the group index. Then, these high bits
> are masked out in order to have a zero based namespace for every
> group. This is mandatory for compact representation and O(1) array
> access.
> 
> A group of attributes is actually an array of attributes. Each
> attribute has a type (PTR_IN, PTR_OUT, IDR and FD) and a length.
> Attributes could be validated through some attributes, like:
> (*) Minimum size / Exact size
> (*) Fops for FD
> (*) Object type for IDR
> 
> If an IDR/fd attribute is specified, the kernel also states the object
> type and the required access (NEW, WRITE, READ or DESTROY).
> All uobject/fd management is done automatically by the infrastructure,
> meaning - the infrastructure will fail concurrent commands that at
> least one of them requires concurrent access (WRITE/DESTROY),
> synchronize actions with device removals (dissociate context events)
> and take care of reference counting (increase/decrease) for concurrent
> actions invocation. The reference counts on the actual kernel objects
> shall be handled by the handlers.
> 
>  types
> +--------+
> |        |
> |        |   actions
> +--------+
> |        |   group      action      action_spec
> +-----+   |len     |
> +--------+  +------+[d]+-------+   +----------------+[d]+------------+
> |attr1+-> |type    |
> | type   +> |action+-> | spec  +-> +  attr_groups   +->
> |common_chain+--> +-----+   |idr_type|
> +--------+  +------+   |handler|   |                |   +------------+
> |attr2|   |access  |
> |        |  |      |   +-------+   +----------------+   |vendor chain|
> +-----+   +--------+
> |        |  |      |                                    +------------+
> |        |  +------+
> |        |
> |        |
> |        |
> |        |
> |        |
> |        |
> |        |
> |        |
> |        |
> |        |
> +--------+

Architecturally, this looks decent.

It took me a few times reading through this before I could start to understand what this is describing though.  (And I'm still not sure I'm there).  I think part of the problem is that this patch introduces terms for abstract concepts that don't easily convey the intent.  (At least they didn't to me.)  Simply changing some of the terms may help people figure out how to use this.

At the top-level ("type"), I think you're describing the concept of an object-oriented class.  Each class contains a set ("action group") of methods or operations ("action").  An operation takes a set of parameters ("action_spec").  Some parameters are common ("common_chain") and some vendor specific ("vendor_chain").  Each parameter is a some data type ("attr").  Please confirm if this is correct.

Assuming my understanding is correct (and I haven't read through the rest of the patches yet), then I would suggest using these terms instead (based on standard OO design terminology):

type_group -> namespace (?)
type -> class or obj_class
action_group -> operations or methods or functions
action -> op_def or method_def or func_def
attr_spec_group -> param_list or op_param_list or func_param_list ...
common_chain -> common_params
vendor_chain -> vendor_params
nit: attr_spec -> attr_def
TYPE_IDR -> TYPE_KOBJ (kernel object)

See other comments below.

> diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
> index e06f4cf..7fed6d9 100644
> --- a/include/rdma/uverbs_ioctl.h
> +++ b/include/rdma/uverbs_ioctl.h
> @@ -41,8 +41,13 @@
>   * =======================================
>   */
> 
> +#define UVERBS_ID_GROUP_MASK 0xF000
> +#define UVERBS_ID_GROUP_SHIFT 12
> +
>  enum uverbs_attr_type {
>  	UVERBS_ATTR_TYPE_NA,
> +	UVERBS_ATTR_TYPE_PTR_IN,
> +	UVERBS_ATTR_TYPE_PTR_OUT,
>  	UVERBS_ATTR_TYPE_IDR,

This is really indicating that we're dealing with a kernel object of some sort, not the actual indexer.

>  	UVERBS_ATTR_TYPE_FD,
>  };
> @@ -54,29 +59,106 @@ enum uverbs_obj_access {
>  	UVERBS_ACCESS_DESTROY
>  };
> 
> +enum uverbs_attr_spec_flags {
> +	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
> +	/* Support extending attributes by length */
> +	UVERBS_ATTR_SPEC_F_MIN_SZ	= 1U << 1,
> +};

Don't use named enums for bit flags.  The result of ORing flags ends up as a non-enum value. 

> +
>  struct uverbs_attr_spec {
>  	enum uverbs_attr_type		type;
> -	struct {
> -		/*
> -		 * higher bits mean the group and lower bits mean
> -		 * the type id within the group.
> -		 */
> -		u16			obj_type;
> -		u8			access;
> -	} obj;
> +	/* a combination of enum uverbs_attr_spec_flags */
> +	u8				flags;
> +	union {
> +		u16				len;
> +		struct {
> +			/*
> +			 * higher bits mean the group and lower bits mean
> +			 * the type id within the group.
> +			 */
> +			u16			obj_type;
> +			u8			access;
> +		} obj;
> +	};

You mentioned trying to conserve space, but this layout will have 1 byte padding after flags and 3 bytes at the end.  Swapping flags to the end should eliminate the padding

>  };
> 
>  struct uverbs_attr_spec_group {
>  	struct uverbs_attr_spec		*attrs;
>  	size_t				num_attrs;
> +	/* populate at runtime */
> +	unsigned long			*mandatory_attrs_bitmask;
> +};

I'm assuming that this references all the parameters for a given method, so suggesting renaming to param_list.

> +
> +struct uverbs_attr_array;
> +struct ib_uverbs_file;
> +
> +enum uverbs_action_flags {
> +	/*
> +	 * Action marked with this flag creates a context (or root for
> all
> +	 * objects).
> +	 */
> +	UVERBS_ACTION_FLAG_CREATE_ROOT = 1U << 0,
> +};

Same comment as above regarding named enums.

> +
> +struct uverbs_action {
> +	struct uverbs_attr_spec_group			**attr_groups;
> +	size_t						num_groups;
> +	size_t						num_child_attrs;
> +	/* Combination of bits from enum uverbs_action_flags */
> +	u32 flags;
> +	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file
> *ufile,
> +		       struct uverbs_attr_array *ctx, size_t num);
> +};

I think this is defining the function handler and parameters of a single method.  Why is attr_groups **, rather than just *?

> +
> +struct uverbs_action_group {
> +	size_t					num_actions;
> +	struct uverbs_action			**actions;
> +};
> +
> +struct uverbs_type {
> +	size_t					num_groups;
> +	const struct uverbs_action_group	**action_groups;
> +	const struct uverbs_obj_type		*type_attrs;
> +};

Conceptually, I think this is representing an object-oriented class; consider renaming type to class.  Similar to my question above, why is action_groups **, rather than *?  Actually, why doesn't this just reference an array of uverbs_action?  The extra layers of indirection to **actions_groups -> ** actions seems overly complex.

> +
> +struct uverbs_type_group {
> +	size_t					num_types;
> +	const struct uverbs_type		**types;
> +};
> +
> +struct uverbs_spec_root {
> +	const struct uverbs_type_group		**type_groups;
> +	size_t					num_groups;
> +};

Similar comments as above regarding **type_groups and **types.  Can we avoid the extra indirection, and maybe drop the action_group and type_group structures completely?  (If this is purely a space issue, we're only saving 1-2 pointers worth of space).


> +
> +/* =================================================
> + *              Parsing infrastructure
> + * =================================================
> + */
> +
> +struct uverbs_ptr_attr {
> +	void	__user *ptr;
> +	u16		len;
>  };
> 
>  struct uverbs_obj_attr {
> +	/*
> +	 * pointer to the user-space given attribute, in order to write
> the
> +	 * new uobject's id.
> +	 */
> +	struct ib_uverbs_attr __user	*uattr;
> +	/* pointer to the kernel descriptor -> type, access, etc */
> +	const struct uverbs_obj_type	*type;
>  	struct ib_uobject		*uobject;
> +	/* fd or id in idr of this object */
> +	int				id;
>  };
> 
>  struct uverbs_attr {
> -	struct uverbs_obj_attr	obj_attr;
> +	union {
> +		struct uverbs_ptr_attr	ptr_attr;
> +		struct uverbs_obj_attr	obj_attr;
> +	};
>  };
> 
>  struct uverbs_attr_array {
> diff --git a/include/uapi/rdma/rdma_user_ioctl.h
> b/include/uapi/rdma/rdma_user_ioctl.h
> index 9388125..3a40b9d 100644
> --- a/include/uapi/rdma/rdma_user_ioctl.h
> +++ b/include/uapi/rdma/rdma_user_ioctl.h
> @@ -43,6 +43,30 @@
>  /* Legacy name, for user space application which already use it */
>  #define IB_IOCTL_MAGIC		RDMA_IOCTL_MAGIC
> 
> +#define RDMA_VERBS_IOCTL \
> +	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
> +
> +enum ib_uverbs_attr_flags {
> +	UVERBS_ATTR_F_MANDATORY = 1U << 0,
> +};

Named enum for flags

> +
> +struct ib_uverbs_attr {
> +	__u16 attr_id;		/* command specific type attribute */
> +	__u16 len;		/* only for pointers */
> +	__u16 flags;		/* combination of ib_uverbs_attr_flags
> */
> +	__u16 reserved;
> +	__u64 data;		/* ptr to command, inline data or idr/fd */
> +};
> +
> +struct ib_uverbs_ioctl_hdr {
> +	__u16 length;
> +	__u16 object_type;
> +	__u16 action;
> +	__u16 num_attrs;
> +	__u64 reserved;
> +	struct ib_uverbs_attr  attrs[0];
> +};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
