From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v1 rdma-next 5/6] RDMA/nldev: provide detailed MR
 information
Date: Wed, 14 Feb 2018 15:43:46 +0200
Message-ID: <20180214134346.GZ2197@mtr-leonro.local>
References: <cover.1518552800.git.swise@opengridcomputing.com>
 <be7f33b8ce1e7311e9ed408267d8475166e48d9b.1518552800.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Jdw4pA1x1k2W7MG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <be7f33b8ce1e7311e9ed408267d8475166e48d9b.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9Jdw4pA1x1k2W7MG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 12:51:16PM -0800, Steve Wise wrote:
> Implement the RDMA nldev netlink interface for dumping detailed
> MR information.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/nldev.c      | 174 +++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/restrack.c   |  48 +++++++---
>  drivers/infiniband/core/uverbs_cmd.c |   6 ++
>  drivers/infiniband/core/verbs.c      |   3 +
>  include/rdma/ib_verbs.h              |   5 +
>  include/rdma/restrack.h              |   4 +
>  include/uapi/rdma/rdma_netlink.h     |  10 ++
>  7 files changed, 238 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 34fb0d3..8d96f3e 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -94,6 +94,13 @@
>  	[RDMA_NLDEV_ATTR_RES_CQE]		= { .type = NLA_U32 },
>  	[RDMA_NLDEV_ATTR_RES_USECNT]		= { .type = NLA_U64 },
>  	[RDMA_NLDEV_ATTR_RES_POLL_CTX]		= { .type = NLA_U8 },
> +	[RDMA_NLDEV_ATTR_RES_MR]		= { .type = NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_MR_ENTRY]		= { .type = NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_RKEY]		= { .type = NLA_U32 },
> +	[RDMA_NLDEV_ATTR_RES_LKEY]		= { .type = NLA_U32 },
> +	[RDMA_NLDEV_ATTR_RES_IOVA]		= { .type = NLA_U64 },
> +	[RDMA_NLDEV_ATTR_RES_MRLEN]		= { .type = NLA_U64 },
> +	[RDMA_NLDEV_ATTR_RES_PGSIZE]		= { .type = NLA_U32 },
>  };
>
>  static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
> @@ -206,6 +213,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
>  		[RDMA_RESTRACK_CQ] = "cq",
>  		[RDMA_RESTRACK_QP] = "qp",
>  		[RDMA_RESTRACK_CM_ID] = "cm_id",
> +		[RDMA_RESTRACK_MR] = "mr",
>  	};
>
>  	struct rdma_restrack_root *res = &device->res;
> @@ -446,6 +454,51 @@ static int fill_res_cq_entry(struct sk_buff *msg,
>  	return -EMSGSIZE;
>  }
>
> +static int fill_res_mr_entry(struct sk_buff *msg,
> +			     struct ib_mr *mr)
> +{
> +	struct rdma_restrack_entry *res = &mr->res;
> +	struct nlattr *entry_attr;
> +
> +	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_MR_ENTRY);
> +	if (!entry_attr)
> +		goto out;
> +
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_RKEY, mr->rkey))
> +		goto err;
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LKEY, mr->lkey))
> +		goto err;
> +	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_RES_IOVA, mr->iova, 0))
> +		goto err;
> +	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_RES_MRLEN, mr->length, 0))
> +		goto err;
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PGSIZE, mr->page_size))
> +		goto err;
> +
> +	/*
> +	 * Existence of task means that it is user MR and netlink
> +	 * user is invited to go and read /proc/PID/comm to get name
> +	 * of the task file and res->task_com should be NULL.
> +	 */
> +	if (rdma_is_kernel_res(res)) {
> +		if (nla_put_string(msg, RDMA_NLDEV_ATTR_RES_KERN_NAME,
> +				   res->kern_name))
> +			goto err;
> +	} else {
> +		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PID,
> +				task_pid_vnr(res->task)))
> +			goto err;
> +	}
> +
> +	nla_nest_end(msg, entry_attr);
> +	return 0;
> +
> +err:
> +	nla_nest_cancel(msg, entry_attr);
> +out:
> +	return -EMSGSIZE;
> +}
> +
>  static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			  struct netlink_ext_ack *extack)
>  {
> @@ -1098,6 +1151,124 @@ static int nldev_res_get_cq_dumpit(struct sk_buff *skb,
>  	return ret;
>  }
>
> +static int nldev_res_get_mr_dumpit(struct sk_buff *skb,
> +				   struct netlink_callback *cb)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
> +	struct rdma_restrack_entry *res;
> +	int err, ret = 0, idx = 0;
> +	struct nlattr *table_attr;
> +	struct ib_device *device;
> +	int start = cb->args[0];
> +	struct ib_mr *mr = NULL;
> +	struct nlmsghdr *nlh;
> +	u32 index;
> +
> +	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +			  nldev_policy, NULL);
> +	/*
> +	 * Right now, we are expecting the device index to get MR information,
> +	 * but it is possible to extend this code to return all devices in
> +	 * one shot by checking the existence of RDMA_NLDEV_ATTR_DEV_INDEX.
> +	 * if it doesn't exist, we will iterate over all devices.
> +	 *
> +	 * But it is not needed for now.
> +	 */
> +	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> +		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_MR_GET),
> +		0, NLM_F_MULTI);
> +
> +	if (fill_nldev_handle(skb, device)) {
> +		ret = -EMSGSIZE;
> +		goto err;
> +	}
> +
> +	table_attr = nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_MR);
> +	if (!table_attr) {
> +		ret = -EMSGSIZE;
> +		goto err;
> +	}
> +
> +	down_read(&device->res.rwsem);
> +	hash_for_each_possible(device->res.hash, res, node, RDMA_RESTRACK_MR) {
> +		if (idx < start)
> +			goto next;
> +
> +		if ((rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) != &init_pid_ns) ||
> +		    (!rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) !=
> +		     task_active_pid_ns(res->task)))
> +			/*
> +			 * 1. Kernel MRs should be visible in init namspace only
> +			 * 2. Present only MRs visible in the current namespace
> +			 */
> +			goto next;
> +
> +		if (!rdma_restrack_get(res))
> +			/*
> +			 * Resource is under release now, but we are not
> +			 * relesing lock now, so it will be released in
> +			 * our next pass, once we will get ->next pointer.
> +			 */
> +			goto next;
> +
> +		mr = container_of(res, struct ib_mr, res);
> +
> +		up_read(&device->res.rwsem);
> +		ret = fill_res_mr_entry(skb, mr);
> +		down_read(&device->res.rwsem);
> +		/*
> +		 * Return resource back, but it won't be released till
> +		 * the &device->res.rwsem will be released for write.
> +		 */
> +		rdma_restrack_put(res);
> +
> +		if (ret == -EMSGSIZE)
> +			/*
> +			 * There is a chance to optimize here.
> +			 * It can be done by using list_prepare_entry
> +			 * and list_for_each_entry_continue afterwards.
> +			 */
> +			break;
> +		if (ret)
> +			goto res_err;
> +next:		idx++;
> +	}
> +	up_read(&device->res.rwsem);
> +
> +	nla_nest_end(skb, table_attr);
> +	nlmsg_end(skb, nlh);
> +	cb->args[0] = idx;
> +
> +	/*
> +	 * No more MRs to fill, cancel the message and
> +	 * return 0 to mark end of dumpit.
> +	 */
> +	if (!mr)
> +		goto err;
> +
> +	put_device(&device->dev);
> +	return skb->len;
> +
> +res_err:
> +	nla_nest_cancel(skb, table_attr);
> +	up_read(&device->res.rwsem);
> +
> +err:
> +	nlmsg_cancel(skb, nlh);
> +	put_device(&device->dev);
> +	return ret;
> +}
> +
>  static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
>  	[RDMA_NLDEV_CMD_GET] = {
>  		.doit = nldev_get_doit,
> @@ -1130,6 +1301,9 @@ static int nldev_res_get_cq_dumpit(struct sk_buff *skb,
>  	[RDMA_NLDEV_CMD_RES_CQ_GET] = {
>  		.dump = nldev_res_get_cq_dumpit,
>  	},
> +	[RDMA_NLDEV_CMD_RES_MR_GET] = {
> +		.dump = nldev_res_get_mr_dumpit,
> +	},
>  };
>
>  void __init nldev_init(void)
> diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
> index 6385914..d3ad0ab 100644
> --- a/drivers/infiniband/core/restrack.c
> +++ b/drivers/infiniband/core/restrack.c
> @@ -43,22 +43,36 @@ int rdma_restrack_count(struct rdma_restrack_root *res,
>
>  static void set_kern_name(struct rdma_restrack_entry *res)
>  {
> -	enum rdma_restrack_type type = res->type;
> -	struct ib_qp *qp;
> +	struct ib_pd *pd = NULL;
>
> -	if (type != RDMA_RESTRACK_QP)
> -		/* Other types already have this name embedded in */
> -		return;
> +	switch (res->type) {
> +	case RDMA_RESTRACK_QP: {
> +		struct ib_qp *qp;
>
> -	qp = container_of(res, struct ib_qp, res);
> -	if (!qp->pd) {
> -		WARN_ONCE(true, "XRC QPs are not supported\n");
> -		/* Survive, despite the programmer's error */
> -		res->kern_name = " ";
> -		return;
> +		qp = container_of(res, struct ib_qp, res);
> +		if (qp->pd) {
> +			pd = qp->pd;
> +		} else {
> +			WARN_ONCE(true, "XRC QPs are not supported\n");
> +			/* Survive, despite the programmer's error */
> +			res->kern_name = " ";
> +		}
> +		break;
> +	}
> +	case RDMA_RESTRACK_MR: {
> +		struct ib_mr *mr;
> +
> +		mr = container_of(res, struct ib_mr, res);
> +		pd = mr->pd;
> +		break;
> +	}
> +	default:
> +		/* Other types set kern_name directly */
> +		break;
>  	}
>
> -	res->kern_name = qp->pd->res.kern_name;
> +	if (pd)
> +		res->kern_name = pd->res.kern_name;
>  }
>
>  static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
> @@ -70,6 +84,7 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
>  	struct ib_pd *pd;
>  	struct ib_cq *cq;
>  	struct ib_qp *qp;
> +	struct ib_mr *mr;
>
>  	switch (type) {
>  	case RDMA_RESTRACK_PD:
> @@ -92,6 +107,10 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
>  		cm_id = container_of(res, struct rdma_cm_id, res);
>  		dev = cm_id->device;
>  		break;
> +	case RDMA_RESTRACK_MR:
> +		mr = container_of(res, struct ib_mr, res);
> +		dev = mr->device;
> +		break;
>  	default:
>  		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
>  		return NULL;
> @@ -108,6 +127,7 @@ static bool res_is_user(struct rdma_restrack_entry *res)
>  	struct ib_pd *pd;
>  	struct ib_cq *cq;
>  	struct ib_qp *qp;
> +	struct ib_mr *mr;
>  	bool is_user = false;
>
>  	switch (type) {
> @@ -132,6 +152,10 @@ static bool res_is_user(struct rdma_restrack_entry *res)
>  		cm_id = container_of(res, struct rdma_cm_id, res);
>  		is_user = !cm_id->caller;
>  		break;
> +	case RDMA_RESTRACK_MR:
> +		mr = container_of(res, struct ib_mr, res);
> +		is_user = mr->pd->uobject;
> +		break;
>  	default:
>  		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
>  	}
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 256934d..3f026c4 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -694,6 +694,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
>  	mr->pd      = pd;
>  	mr->uobject = uobj;
>  	atomic_inc(&pd->usecnt);
> +	mr->res.type = RDMA_RESTRACK_MR;
> +	rdma_restrack_add(&mr->res);
>
>  	uobj->object = mr;
>
> @@ -819,6 +821,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
>  	struct ib_uverbs_dereg_mr cmd;
>  	struct ib_uobject	 *uobj;
>  	int                       ret = -EINVAL;
> +	struct ib_mr *mr;
>
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
> @@ -828,6 +831,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
>  	if (IS_ERR(uobj))
>  		return PTR_ERR(uobj);
>
> +	mr = uobj->object;
> +	rdma_restrack_del(&mr->res);
> +

It is wrong function to rdma_restrack_del(). The best place to put
rdma_restrack_add() is right after device->xxx() call and
rdma_restrack_del() is right before device->yyy() call.

Thanks

>  	ret = uobj_remove_commit(uobj);
>
>  	return ret ?: in_len;
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 16ebc63..c3265f7 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1623,6 +1623,7 @@ int ib_dereg_mr(struct ib_mr *mr)
>  	struct ib_pd *pd = mr->pd;
>  	int ret;
>
> +	rdma_restrack_del(&mr->res);
>  	ret = mr->device->dereg_mr(mr);
>  	if (!ret)
>  		atomic_dec(&pd->usecnt);
> @@ -1659,6 +1660,8 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
>  		mr->uobject = NULL;
>  		atomic_inc(&pd->usecnt);
>  		mr->need_inval = false;
> +		mr->res.type = RDMA_RESTRACK_MR;
> +		rdma_restrack_add(&mr->res);
>  	}
>
>  	return mr;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 5263c86..33d8c5d 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1771,6 +1771,11 @@ struct ib_mr {
>  		struct ib_uobject	*uobject;	/* user */
>  		struct list_head	qp_entry;	/* FR */
>  	};
> +
> +	/*
> +	 * Implementation details of the RDMA core, don't use in drivers:
> +	 */
> +	struct rdma_restrack_entry res;
>  };
>
>  struct ib_mw {
> diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
> index a794e0e..bfd1140 100644
> --- a/include/rdma/restrack.h
> +++ b/include/rdma/restrack.h
> @@ -37,6 +37,10 @@ enum rdma_restrack_type {
>  	 */
>  	RDMA_RESTRACK_CM_ID,
>  	/**
> +	 * @RDMA_RESTRACK_MR: Memory Region (MR)
> +	 */
> +	RDMA_RESTRACK_MR,
> +	/**
>  	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
>  	 */
>  	RDMA_RESTRACK_MAX
> diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> index fa677ef..6adaeaa 100644
> --- a/include/uapi/rdma/rdma_netlink.h
> +++ b/include/uapi/rdma/rdma_netlink.h
> @@ -244,6 +244,8 @@ enum rdma_nldev_command {
>
>  	RDMA_NLDEV_CMD_RES_CQ_GET, /* can dump */
>
> +	RDMA_NLDEV_CMD_RES_MR_GET, /* can dump */
> +
>  	RDMA_NLDEV_NUM_OPS
>  };
>
> @@ -390,6 +392,14 @@ enum rdma_nldev_attr {
>  	RDMA_NLDEV_ATTR_RES_USECNT,		/* u64 */
>  	RDMA_NLDEV_ATTR_RES_POLL_CTX,		/* u8 */
>
> +	RDMA_NLDEV_ATTR_RES_MR,			/* nested table */
> +	RDMA_NLDEV_ATTR_RES_MR_ENTRY,		/* nested table */
> +	RDMA_NLDEV_ATTR_RES_RKEY,		/* u32 */
> +	RDMA_NLDEV_ATTR_RES_LKEY,		/* u32 */
> +	RDMA_NLDEV_ATTR_RES_IOVA,		/* u64 */
> +	RDMA_NLDEV_ATTR_RES_MRLEN,		/* u64 */
> +	RDMA_NLDEV_ATTR_RES_PGSIZE,		/* u32 */
> +
>  	RDMA_NLDEV_ATTR_MAX
>  };
>  #endif /* _UAPI_RDMA_NETLINK_H */
> --
> 1.8.3.1
>

--9Jdw4pA1x1k2W7MG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqEPRIACgkQ5GN7iDZy
WKeVeBAAwuSKmXT6PPtlzifx0ROHdAZt1mVfJg8iQXDQuPtdfE2ATM1p8VhGOIu9
/uibqU24BL0TVTq1ZsD8PQ6AszYeocjdES6tSWdrTGhK+R3GLDhB5KYk+7XndYJ8
fWZUd1kZ71aJ6basfGcFqUmQWClapzv8sgkSBCNL1epiXkSVsQsI4Zs8WY+shBqi
nzjjua0KCYyrH04yAPz1NwnpQQt6fcM9EoGKGpSE7VyYBu2b8tqXs9esYg5G7Hrf
b3PTqzWWaVa92GJxfQDw+kwtPkb/eYYH8CNVG/9J98wVR8Pdb6qHebeHEKWXPBci
m5zCnqnUAQhRD6M0RERYsEhdppu0mzFPZ5HDRFxeCLAiFi6/v8OTG3tTC6MSdSJ1
uST2g+Uy8hblt8nQgmsldyQpqIbrthbLLac3hl4VBL/s9uoqn+Fkls5LigdIZuxi
xycy4G9w7ryKjMPGXrEjGRbDCxZ9yyJbnCRnIzWoj96DoYa6aTgOPwOHsTEFogt2
p49m6vbmLn6XCyXARJdlZu/S1OxY7bJe/Sp38QHEF5Gk47HfBVR906lR2AeX0RVM
hivQTzYSlxsNiXLolamnzJiNr0RUS7o7dgDsetkeCDwV1+WNtShe5rz7F9iPXzvW
IdSjC3EJTrhYeJVGxH8m25W+hMaF87b6+5xZUenPf7HhweVdsOQ=
=a0U/
-----END PGP SIGNATURE-----

--9Jdw4pA1x1k2W7MG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
