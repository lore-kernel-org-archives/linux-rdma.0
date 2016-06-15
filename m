From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH v2 1/2] rdma/ucm: Sketch for an ioctl framework
Date: Wed, 15 Jun 2016 17:53:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB062546@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB062505@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB062505-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/ucma.c
> b/drivers/infiniband/core/ucma.c
> index dd3bcce..b289ce0 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -491,9 +491,9 @@ static ssize_t ucma_create_id(struct ucma_file
> *file, const char __user *inbuf,
>  err2:
>  	rdma_destroy_id(ctx->cm_id);
>  err1:
> -	mutex_lock(&mut);
> +	mutex_lock(&file->mut);
>  	idr_remove(&ctx_idr, ctx->id);
> -	mutex_unlock(&mut);
> +	mutex_unlock(&file->mut);
>  	kfree(ctx);
>  	return ret;
>  }

This is likely a change that should have been merged into the second pa=
tch.

> diff --git a/drivers/infiniband/core/urdma.c
> b/drivers/infiniband/core/urdma.c

> +static struct uda_obj * uda_get_obj(struct uda_file *file, struct
> uda_ns *ns,
> +				    struct uda_obj_id *id, bool excl)
> +{
> +	struct uda_obj *obj;
> +
> +	if (id->data)
> +		return ERR_PTR(-EINVAL);
> +
> +	obj =3D idr_find(&ns->idr, id->instance_id);
> +	if (!obj || obj->obj_type !=3D id->obj_type || obj->file !=3D file)
> +		return ERR_PTR(-ENOENT);
> +	else if (obj->flags & UDA_EXCL || (excl && atomic_read(&obj-
> >use_cnt)))
> +		return ERR_PTR(-EBUSY);
> +
> +	if (excl)
> +		obj->flags |=3D UDA_EXCL;
> +	atomic_inc(&obj->use_cnt);
> +	return obj;
> +}

If a descriptor has the exclusive flag (UDA_EXCL) set, then the framewo=
rk will enforce exclusive access on the first object in the object list=
=2E  In such cases, user space is responsible for serializing ioctls th=
at require exclusive access to the same object.  Alternatively, the und=
erlying kernel client can handle all necessary locking, which it can co=
ntrol by leaving the UDA_EXCL flag set to 0.

The framework does not hold any locks through any operations, leaving t=
hat to the name space to manage.

> +static long uda_pre_open(struct uda_file *file, struct uda_ns *ns,
> +			 struct uda_ioctl *ioctl, struct uda_ioctl_desc
> *desc)
> +{
> +	struct uda_obj *obj;
> +	struct uda_arg *arg;
> +	u16 index =3D ioctl->obj_cnt;
> +	long ret;
> +
> +	if (!ioctl->arg_cnt)
> +		return -EINVAL;
> +
> +	/* arg[0] =3D identifier of object to open, data =3D object id */
> +	ret =3D uda_check_arg(ioctl, index, UDA_UCONTEXT, sizeof(u64));
> +	if (ret)
> +		return ret;
> +
> +	obj =3D kzalloc(sizeof *obj, GFP_KERNEL);
> +	if (!obj)
> +		return -ENOMEM;
> +
> +	arg =3D &ioctl->u.arg[index];
> +	obj->file =3D file;
> +	obj->flags =3D UDA_EXCL;
> +	obj->obj_type =3D arg->data;
> +	obj->ucontext =3D *(u64 *) UDA_ARG_DATA(ioctl, index);
> +	atomic_set(&obj->use_cnt, 1);
> +
> +	mutex_lock(&ns->lock);
> +	obj->instance_id =3D idr_alloc(&ns->idr, obj, 0, 0, GFP_KERNEL);
> +	if (obj->instance_id >=3D 0)
> +		list_add(&obj->entry, &file->obj_list);
> +	mutex_unlock(&ns->lock);
> +
> +	if (obj->instance_id < 0) {
> +		kfree(obj);
> +		return -ENOMEM;
> +	}
> +
> +	/* new object added after object array */
> +	ioctl->u.obj[ioctl->obj_cnt++] =3D obj;
> +	ioctl->arg_cnt--;
> +	return 0;
> +}

If a descriptor indicates that an ioctl will create a new kernel object=
 (UDA_OPEN flag is set), the framework will allocate the tracking objec=
t.  The object details are provided as the first argument (arg[0]) to t=
he ioctl, which the framework replaces with the allocated object.

> +static long uda_check_args(struct uda_ioctl *ioctl)
> +{
> +	struct uda_arg *arg;
> +	u16 i;
> +
> +	for (i =3D 0; i < ioctl->arg_cnt; i++) {
> +		arg =3D &ioctl->u.arg[i + ioctl->obj_cnt];
> +		if (arg->offset + arg->length > ioctl->length)
> +			return -EINVAL;
> +	}
> +	return 0;
> +}

This check verifies that the ioctl arguments fit within the allocated b=
uffer.  Additional checks on the arguments are left to the kernel clien=
ts.

> +/*
> + * Name space manager
> + */
> +static long uda_check_query(struct uda_ioctl *ioctl)
> +{
> +	long ret;
> +
> +	if (ioctl->flags || ioctl->obj_cnt || ioctl->arg_cnt !=3D 1)
> +		return -EINVAL;
> +
> +	ret =3D uda_check_arg(ioctl, 0, UDA_IOVEC, sizeof(struct
> uda_iovec));
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static long uda_query_ns(struct uda_ns *ns, void *data)
> +{
> +//	struct uda_ioctl *ioctl =3D data;
> +
> +	/* TODO: for each name space, write out uda_ns_attr details */
> +	return -ENOSYS;
> +}
> +
> +static uda_ioctl_handler_t ns_mgr_check_ops[] =3D {
> +	[UDA_NS_MGR_QUERY] =3D uda_check_query,
> +};

Rather than the framework having a generic validation algorithm, I push=
ed that down into the kernel clients.  This is where I think we'll need=
 to see how the code falls out.  In both my name space examples, I ende=
d up using an array of calls that verify the ioctl format before select=
ing the ioctl descriptor, so there's at least some level of commonality=
 here.

> +
> +static struct uda_ioctl_desc ns_mgr_ops[] =3D {
> +	UDA_DESC(NS_MGR, QUERY, uda_query_ns, 0),
> +};
> +
> +static struct uda_ioctl_desc *ns_mgr_get_desc(struct uda_ioctl *ioct=
l)
> +{
> +	u32 op;
> +
> +	op =3D ioctl->op - UDA_NS_MGR_BASE;
> +	if (ns_mgr_check_ops[op](ioctl))
> +		return NULL;
> +
> +	return &ns_mgr_ops[op];
> +}
> +
> +static struct uda_ns ns_mgr =3D {
> +	.idr =3D IDR_INIT(ns_mgr.idr),
> +	.lock =3D __MUTEX_INITIALIZER(ns_mgr.lock),
> +	.ioctl_base =3D UDA_NS_MGR_BASE,
> +	.num_ioctls =3D UDA_NS_MGR_IOCTLS, /* use array length */
> +	.ioctl_desc =3D ns_mgr_get_desc,
> +	.name =3D "urdma ioctl name space manager"
> +};
> +
> +void uda_init(void)
> +{
> +	uda_add_ns(&ns_mgr);
> +}
> diff --git a/include/rdma/rdma_uapi.h b/include/rdma/rdma_uapi.h

> +/* Object and control flags */
> +/* Indicates operation will allocate a new kernel object. */
> +#define UDA_OPEN		(1 << 0)
> +/* Indicates operation will destroy a kernel object */
> +#define UDA_CLOSED		(1 << 1)
> +/* Operation on object requires exclusive access */
> +#define UDA_EXCL		(1 << 2)
> +/* Events may be generated for the given object */
> +#define UDA_EVENT		(1 << 3)
> +
> +struct uda_ns;
> +struct uda_obj;
> +
> +typedef long (*uda_handler_t)(struct uda_ns *ns, void *data);
> +typedef long (*uda_ioctl_handler_t)(struct uda_ioctl *ioctl);

These callbacks seem sufficient for the rdma cm, but there may be a nee=
d to also pass in the associated file object.

> +struct uda_obj {
> +	u64			ucontext;
> +	void			*kcontext;
> +	struct uda_file		*file;
> +	u32			instance_id;	/* idr index */
> +	u16			obj_type;
> +	u16			flags;
> +	struct list_head	entry;
> +	atomic_t		use_cnt;
> +};

All kernel objects require this structure, so we have about 56 bytes of=
 overhead per object.  I don=92t see an easy way to reduce this size.  =
I intentionally kept the structure used to track kernel objects separat=
e from the kernel object itself to simplify handling name space remova.

> diff --git a/include/uapi/rdma/rdma_ioctl.h

> +/* name spaces */
> +enum {
> +	UDA_NS_MGR,
> +};

All new name spaces require adding an entry to this enum.

> +enum {
> +	UDA_RAW_ATTR,		/* provider specific attribute */
> +	UDA_IOVEC,
> +	UDA_OBJ_ID,
> +	UDA_UCONTEXT,
> +	UDA_NS_ATTR,
> +};

All new attributes add an entry to this enum.  Combined with the above =
name space addition, it will be clear whenever the uABI is being update=
d, allowing for a more thorough review.

> +struct uda_iovec {
> +	u64	addr;
> +	u64	length;
> +};

This structure is the ioctl argument attribute UDA_IOVEC.  It may be us=
ed to indicate where a response should be written, or where additional =
input data is located.

> +struct uda_ns_attr {
> +	char	name[UDA_MAX_NAME];
> +	u32	op;
> +	u32	flags;
> +	u16	attr;
> +	u16	id;
> +	u16	version;
> +	u16	resv;
> +};

This describes the attributes of a name space and would be returned by =
the name space manager in response to a query.  The actual attributes n=
eed to be determined.  I used a simple version field to indicate what o=
perations may be supported by the name space.  The intent is for the ve=
rsion to increment whenever new operations or attributes are supported.=
  I don't have a good way to remove operations from a name space.  That=
 would require defining a new name space, and eventually dropping suppo=
rt for the old one.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
