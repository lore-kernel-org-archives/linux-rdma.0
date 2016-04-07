From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Thu, 7 Apr 2016 19:31:00 +0300
Message-ID: <20160407163100.GA5808@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-10-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 02:33:54AM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Allocate and free a security context when creating and destroying a QP.
> This context is used for controlling access to PKeys.
>=20
> When a request is made to modify a QP that changes the port, PKey index,
> alternate path port, or alternate path PKey index, check that the QP has
> permission for the PKey in the index on the subnet prefix of the port.
> If the QP is shared make sure all handles to the QP also have access.
>=20
> Store which port and pkey a QP is using.  After the reset to init
> transition the user can modify the port and pkey independently.  This
> adds a transactional aspect to modify QP when the port, pkey, or
> alternate path change.  Permission must be checked for the new settings,
> then the modify can be attempted.  If the modify fails the old setting
> should be restored.
>=20
> To keep the security changes isolated a new file is used to hold security
> related functionality.
>=20
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/Makefile        |    2 +-
>  drivers/infiniband/core/core_priv.h     |   41 ++++
>  drivers/infiniband/core/core_security.c |  331 +++++++++++++++++++++++++=
++++++

We are already in core, there is no need to call files core_XXX.

>  drivers/infiniband/core/uverbs_cmd.c    |   20 ++-
>  drivers/infiniband/core/verbs.c         |   24 +++-
>  include/rdma/ib_verbs.h                 |   28 +++-
>  6 files changed, 439 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/infiniband/core/core_security.c
>=20
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/M=
akefile
> index f818538..48a4013 100644
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=3D	ib_uverbs.o i=
b_ucm.o \
> =20
>  ib_core-y :=3D			packer.o ud_header.o verbs.o cq.o sysfs.o \
>  				device.o fmr_pool.o cache.o netlink.o \
> -				roce_gid_mgmt.o
> +				roce_gid_mgmt.o core_security.o
>  ib_core-$(CONFIG_INFINIBAND_USER_MEM) +=3D umem.o
>  ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) +=3D umem_odp.o umem_rbtre=
e.o
> =20
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/cor=
e/core_priv.h
> index 722b866..27f2fa8 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -140,4 +140,45 @@ static inline bool rdma_is_upper_dev_rcu(struct net_=
device *dev,
>  int ib_get_cached_subnet_prefix(struct ib_device *device,
>  				u8                port_num,
>  				u64              *sn_pfx);
> +
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +int ib_security_modify_qp(struct ib_qp *qp,
> +			  struct ib_qp_attr *qp_attr,
> +			  int qp_attr_mask,
> +			  struct ib_udata *udata);
> +
> +int ib_security_create_qp_security(struct ib_qp *qp);

Why do we need xx_SECURITY_xxxxx_SECURITY in name?

> +void ib_security_destroy_qp(struct ib_qp_security *sec);
> +int ib_security_open_shared_qp(struct ib_qp *qp);
> +void ib_security_close_shared_qp(struct ib_qp_security *sec);
> +#else
> +static inline int ib_security_modify_qp(struct ib_qp *qp,
> +					struct ib_qp_attr *qp_attr,
> +					int qp_attr_mask,
> +					struct ib_udata *udata)
> +{
> +	return qp->device->modify_qp(qp->real_qp,
> +				     qp_attr,
> +				     qp_attr_mask,
> +				     udata);
> +}
> +
> +static inline int ib_security_create_qp_security(struct ib_qp *qp)
> +{
> +	return 0;
> +}
> +
> +static inline void ib_security_destroy_qp(struct ib_qp_security *sec)
> +{
> +}
> +
> +static inline int ib_security_open_shared_qp(struct ib_qp *qp)
> +{
> +	return 0;
> +}
> +
> +static inline void ib_security_close_shared_qp(struct ib_qp_security *se=
c)
> +{
> +}
> +#endif
>  #endif /* _CORE_PRIV_H */
> diff --git a/drivers/infiniband/core/core_security.c b/drivers/infiniband=
/core/core_security.c
> new file mode 100644
> index 0000000..768edea
> --- /dev/null
> +++ b/drivers/infiniband/core/core_security.c
> @@ -0,0 +1,331 @@
> +/*
> + * Copyright (c) 2016 Mellanox Technologies Ltd.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +
> +#include <linux/security.h>
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_cache.h>
> +#include "core_priv.h"
> +
> +static int get_pkey_info(struct ib_device *dev,
> +			 u8 port_num,
> +			 u16 pkey_index,
> +			 u64 *subnet_prefix,
> +			 u16 *pkey)
> +{
> +	int err;
> +
> +	err =3D ib_get_cached_pkey(dev, port_num, pkey_index, pkey);
> +	if (err)
> +		return err;
> +
> +	err =3D ib_get_cached_subnet_prefix(dev, port_num, subnet_prefix);
> +
> +	return err;
> +}
> +
> +static int enforce_qp_pkey_security(struct ib_device *dev,
> +				    u8 port_num,
> +				    u16 pkey_index,
> +				    struct ib_qp_security *sec)
> +{
> +	struct ib_qp_security *shared_qp_sec;
> +	u64 subnet_prefix;
> +	int err =3D 0;
> +	u16 pkey;
> +
> +	err =3D get_pkey_info(dev, port_num, pkey_index, &subnet_prefix, &pkey);
> +	if (err)
> +		return err;
> +
> +	err =3D security_qp_pkey_access(subnet_prefix, pkey, sec);
> +	if (err)
> +		return err;
> +
> +	if (sec->qp =3D=3D sec->qp->real_qp) {
> +		/* The caller of this function holds the QP security
> +		 * mutex so this list traversal is safe
> +		*/

Did the comment below pass checkpatch.pl?

> +		list_for_each_entry(shared_qp_sec,
> +				    &sec->shared_qp_list,
> +				    shared_qp_list) {

Is this list always needed to be protected by lock?
In general, I prefer to see lock/unlock operations near protected code.
Otherwise, it is hard to follow all lock/unlock paths.

> +			err =3D security_qp_pkey_access(subnet_prefix,
> +						      pkey,
> +						      shared_qp_sec);
> +			if (err)
> +				break;
> +		}
> +	}
> +	return err;
> +}
> +
> +static int check_pkey(const struct ib_qp *qp,
> +		      const struct ib_qp_attr *qp_attr,
> +		      int qp_attr_mask)
> +{
> +	bool check_pkey =3D !!(qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT));
> +
> +	return check_pkey && (qp->qp_num !=3D IB_QPT_SMI &&
> +			      qp->qp_num !=3D IB_QPT_GSI);

IB_QPT_SMI and IB_QPT_GSI are declared as struct ib_qp_type and setted
in qp->qp_type and not in qp->qp_num.

> +}
> +
> +static int check_alt_pkey(const struct ib_qp *qp,
> +			  const struct ib_qp_attr *qp_attr,
> +			  int qp_attr_mask)
> +{
> +	bool check_alt_pkey =3D !!(qp_attr_mask & IB_QP_ALT_PATH);
> +
> +	return check_alt_pkey && (qp->qp_num !=3D IB_QPT_SMI &&
> +				  qp->qp_num !=3D IB_QPT_GSI);
> +}

The same as above.

> +
> +static int affects_security_settings(const struct ib_qp *qp,
> +				     const struct ib_qp_attr *qp_attr,
> +				     int qp_attr_mask)
> +{
> +	return check_pkey(qp, qp_attr, qp_attr_mask) ||
> +	       check_alt_pkey(qp, qp_attr, qp_attr_mask);
> +}
> +
> +static void begin_port_pkey_change(struct ib_qp *qp,
> +				   struct ib_port_pkey *pp,
> +				   struct ib_port_pkey *old_pp,
> +				   u8 port_num,
> +				   u16 pkey_index)
> +{
> +	if (pp->state =3D=3D IB_PORT_PKEY_NOT_VALID ||
> +	    (pkey_index !=3D pp->pkey_index ||
> +	     port_num !=3D pp->port_num)) {
> +		old_pp->pkey_index =3D pp->pkey_index;
> +		old_pp->port_num =3D pp->port_num;
> +		old_pp->state =3D pp->state;
> +
> +		pp->port_num =3D port_num;
> +		pp->pkey_index =3D pkey_index;
> +		pp->state =3D IB_PORT_PKEY_CHANGING;
> +	}
> +}
> +
> +static int qp_modify_enforce_security(struct ib_qp *qp,
> +				      const struct ib_qp_attr *qp_attr,
> +				      int qp_attr_mask)
> +{
> +	struct ib_qp_security *sec =3D qp->qp_sec;
> +	int err =3D 0;
> +
> +	if (check_pkey(qp, qp_attr, qp_attr_mask)) {
> +		u8 port_num =3D (qp_attr_mask & IB_QP_PORT) ?
> +			       qp_attr->port_num :
> +			       sec->ports_pkeys.main.port_num;
> +
> +		u16 pkey_index =3D (qp_attr_mask & IB_QP_PKEY_INDEX) ?
> +				  qp_attr->pkey_index :
> +				  sec->ports_pkeys.main.pkey_index;
> +
> +		err =3D enforce_qp_pkey_security(qp->device,
> +					       port_num,
> +					       pkey_index,
> +					       sec);
> +
> +		if (err)
> +			return err;
> +
> +		begin_port_pkey_change(qp,
> +				       &sec->ports_pkeys.main,
> +				       &sec->old_ports_pkeys.main,
> +				       port_num,
> +				       pkey_index);
> +	}
> +
> +	if (check_alt_pkey(qp, qp_attr, qp_attr_mask)) {
> +		err =3D enforce_qp_pkey_security(qp->device,
> +					       qp_attr->alt_port_num,
> +					       qp_attr->alt_pkey_index,
> +					       sec);
> +
> +		if (err)
> +			return err;
> +
> +		begin_port_pkey_change(qp,
> +				       &sec->ports_pkeys.alt,
> +				       &sec->old_ports_pkeys.alt,
> +				       qp_attr->alt_port_num,
> +				       qp_attr->alt_pkey_index);
> +	}
> +	return err;
> +}
> +
> +static void abort_port_pkey_change(struct ib_qp *qp,
> +				   struct ib_port_pkey *pp,
> +				   struct ib_port_pkey *old_pp)
> +{
> +	if (pp->state =3D=3D IB_PORT_PKEY_CHANGING) {
> +		pp->pkey_index =3D old_pp->pkey_index;
> +		pp->port_num =3D old_pp->port_num;
> +		pp->state =3D old_pp->state;
> +	}
> +}
> +
> +static int cleanup_qp_pkey_associations(struct ib_qp *qp,
> +					bool revert_to_old)
> +{
> +	struct ib_qp_security *sec =3D qp->qp_sec;
> +
> +	if (revert_to_old) {
> +		abort_port_pkey_change(qp,
> +				       &qp->qp_sec->ports_pkeys.main,
> +				       &qp->qp_sec->old_ports_pkeys.main);
> +
> +		abort_port_pkey_change(qp,
> +				       &qp->qp_sec->ports_pkeys.alt,
> +				       &qp->qp_sec->old_ports_pkeys.alt);
> +	} else {
> +		if (sec->ports_pkeys.main.state =3D=3D IB_PORT_PKEY_CHANGING)
> +			sec->ports_pkeys.main.state =3D IB_PORT_PKEY_VALID;
> +
> +		if (sec->ports_pkeys.alt.state =3D=3D IB_PORT_PKEY_CHANGING)
> +			sec->ports_pkeys.alt.state =3D IB_PORT_PKEY_VALID;
> +	}
> +
> +	memset(&sec->old_ports_pkeys, 0, sizeof(sec->old_ports_pkeys));
> +
> +	return 0;
> +}
> +
> +int ib_security_open_shared_qp(struct ib_qp *qp)
> +{
> +	struct ib_qp *real_qp =3D qp->real_qp;
> +	int err;
> +
> +	err =3D ib_security_create_qp_security(qp);
> +	if (err)
> +		goto out;
> +
> +	mutex_lock(&real_qp->qp_sec->mutex);
> +
> +	if (real_qp->qp_sec->ports_pkeys.main.state !=3D IB_PORT_PKEY_NOT_VALID)
> +		err =3D enforce_qp_pkey_security(real_qp->device,
> +					       real_qp->qp_sec->ports_pkeys.main.port_num,
> +					       real_qp->qp_sec->ports_pkeys.main.pkey_index,
> +					       qp->qp_sec);
> +	if (err)
> +		goto err;
> +
> +	if (real_qp->qp_sec->ports_pkeys.alt.state !=3D IB_PORT_PKEY_NOT_VALID)
> +		err =3D enforce_qp_pkey_security(real_qp->device,
> +					       real_qp->qp_sec->ports_pkeys.alt.port_num,
> +					       real_qp->qp_sec->ports_pkeys.alt.pkey_index,
> +					       qp->qp_sec);
> +
> +	if (err)
> +		goto err;
> +
> +	if (qp !=3D real_qp)
> +		list_add(&qp->qp_sec->shared_qp_list,
> +			 &real_qp->qp_sec->shared_qp_list);
> +err:
> +	mutex_unlock(&real_qp->qp_sec->mutex);
> +	if (err)
> +		ib_security_destroy_qp(qp->qp_sec);
> +
> +out:
> +	return err;
> +}
> +
> +void ib_security_close_shared_qp(struct ib_qp_security *sec)
> +{
> +	struct ib_qp *real_qp =3D sec->qp->real_qp;
> +
> +	mutex_lock(&real_qp->qp_sec->mutex);
> +	list_del(&sec->shared_qp_list);
> +	mutex_unlock(&real_qp->qp_sec->mutex);
> +
> +	ib_security_destroy_qp(sec);
> +}
> +
> +int ib_security_create_qp_security(struct ib_qp *qp)
> +{
> +	int err;
> +
> +	qp->qp_sec =3D kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
> +	if (!qp->qp_sec)
> +		return -ENOMEM;
> +
> +	qp->qp_sec->qp =3D qp;
> +	mutex_init(&qp->qp_sec->mutex);
> +	INIT_LIST_HEAD(&qp->qp_sec->shared_qp_list);
> +	err =3D security_ib_qp_alloc_security(qp->qp_sec);
> +	if (err)
> +		kfree(qp->qp_sec);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(ib_security_create_qp_security);
> +
> +void ib_security_destroy_qp(struct ib_qp_security *sec)
> +{
> +	security_ib_qp_free_security(sec);
> +	kfree(sec);
> +}

Did you want to EXPORT_SYMBOL here too?

> +
> +int ib_security_modify_qp(struct ib_qp *qp,
> +			  struct ib_qp_attr *qp_attr,
> +			  int qp_attr_mask,
> +			  struct ib_udata *udata)
> +{
> +	int err =3D 0;
> +	bool enforce_security =3D affects_security_settings(qp,
> +							  qp_attr,
> +							  qp_attr_mask);
> +
> +	if (enforce_security) {
> +		mutex_lock(&qp->qp_sec->mutex);
> +
> +		err =3D qp_modify_enforce_security(qp, qp_attr, qp_attr_mask);
> +	}
> +
> +	if (!err)
> +		err =3D qp->device->modify_qp(qp->real_qp,
> +					    qp_attr,
> +					    qp_attr_mask,
> +					    udata);
> +	if (enforce_security) {
> +		cleanup_qp_pkey_associations(qp, !!err);
> +		mutex_unlock(&qp->qp_sec->mutex);
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL(ib_security_modify_qp);
> +
> +#endif /* CONFIG_SECURITY_INFINIBAND */
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/co=
re/uverbs_cmd.c
> index 6fdc7ec..6df15ea 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -37,7 +37,7 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> -
> +#include <linux/security.h>
>  #include <asm/uaccess.h>
> =20
>  #include "uverbs.h"
> @@ -1857,6 +1857,10 @@ static int create_qp(struct ib_uverbs_file *file,
>  	}
> =20
>  	if (cmd->qp_type !=3D IB_QPT_XRC_TGT) {
> +		ret =3D ib_security_create_qp_security(qp);
> +		if (ret)
> +			goto err_destroy;
> +
>  		qp->real_qp	  =3D qp;
>  		qp->device	  =3D device;
>  		qp->pd		  =3D pd;
> @@ -2339,10 +2343,18 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file=
 *file,
>  		ret =3D ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
>  		if (ret)
>  			goto release_qp;
> -		ret =3D qp->device->modify_qp(qp, attr,
> -			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
> +
> +		ret =3D ib_security_modify_qp(qp,
> +					    attr,
> +					    modify_qp_mask(qp->qp_type,
> +							   cmd.attr_mask),
> +					    &udata);
>  	} else {
> -		ret =3D ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_ma=
sk));
> +		ret =3D ib_security_modify_qp(qp,
> +					    attr,
> +					    modify_qp_mask(qp->qp_type,
> +							   cmd.attr_mask),
> +					    NULL);
>  	}
> =20
>  	if (ret)
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index 15b8adb..47000ee 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -44,6 +44,7 @@
>  #include <linux/in.h>
>  #include <linux/in6.h>
>  #include <net/addrconf.h>
> +#include <linux/security.h>
> =20
>  #include <rdma/ib_verbs.h>
>  #include <rdma/ib_cache.h>
> @@ -681,12 +682,19 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *rea=
l_qp,
>  {
>  	struct ib_qp *qp;
>  	unsigned long flags;
> +	int err;
> =20
>  	qp =3D kzalloc(sizeof *qp, GFP_KERNEL);
>  	if (!qp)
>  		return ERR_PTR(-ENOMEM);
> =20
>  	qp->real_qp =3D real_qp;
> +	err =3D ib_security_open_shared_qp(qp);
> +	if (err) {
> +		kfree(qp);
> +		return ERR_PTR(err);
> +	}
> +
>  	atomic_inc(&real_qp->usecnt);
>  	qp->device =3D real_qp->device;
>  	qp->event_handler =3D event_handler;
> @@ -728,11 +736,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>  {
>  	struct ib_qp *qp, *real_qp;
>  	struct ib_device *device;
> +	int err;
> =20
>  	device =3D pd ? pd->device : qp_init_attr->xrcd->device;
>  	qp =3D device->create_qp(pd, qp_init_attr, NULL);
> =20
>  	if (!IS_ERR(qp)) {
> +		err =3D ib_security_create_qp_security(qp);
> +		if (err)
> +			goto destroy_qp;
> +
>  		qp->device     =3D device;
>  		qp->real_qp    =3D qp;
>  		qp->uobject    =3D NULL;
> @@ -780,6 +793,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>  	}
> =20
>  	return qp;
> +
> +destroy_qp:
> +	ib_destroy_qp(qp);
> +	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL(ib_create_qp);
> =20
> @@ -1180,7 +1197,7 @@ int ib_modify_qp(struct ib_qp *qp,
>  	if (ret)
>  		return ret;
> =20
> -	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
> +	return ib_security_modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
>  }
>  EXPORT_SYMBOL(ib_modify_qp);
> =20
> @@ -1209,6 +1226,7 @@ int ib_close_qp(struct ib_qp *qp)
>  	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
> =20
>  	atomic_dec(&real_qp->usecnt);
> +	ib_security_close_shared_qp(qp->qp_sec);
>  	kfree(qp);
> =20
>  	return 0;
> @@ -1248,6 +1266,7 @@ int ib_destroy_qp(struct ib_qp *qp)
>  	struct ib_pd *pd;
>  	struct ib_cq *scq, *rcq;
>  	struct ib_srq *srq;
> +	struct ib_qp_security *sec;
>  	int ret;
> =20
>  	if (atomic_read(&qp->usecnt))
> @@ -1260,6 +1279,7 @@ int ib_destroy_qp(struct ib_qp *qp)
>  	scq  =3D qp->send_cq;
>  	rcq  =3D qp->recv_cq;
>  	srq  =3D qp->srq;
> +	sec  =3D qp->qp_sec;
> =20
>  	ret =3D qp->device->destroy_qp(qp);
>  	if (!ret) {
> @@ -1271,6 +1291,8 @@ int ib_destroy_qp(struct ib_qp *qp)
>  			atomic_dec(&rcq->usecnt);
>  		if (srq)
>  			atomic_dec(&srq->usecnt);
> +		if (sec)
> +			ib_security_destroy_qp(sec);
>  	}
> =20
>  	return ret;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 870c5ac..f71cb47 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1416,8 +1416,34 @@ struct ib_srq {
>  	} ext;
>  };
> =20
> +enum port_pkey_state {
> +	IB_PORT_PKEY_NOT_VALID =3D 0,
> +	IB_PORT_PKEY_VALID =3D 1,
> +	IB_PORT_PKEY_CHANGING =3D 2,
> +};
> +
> +struct ib_port_pkey {
> +	enum port_pkey_state	state;
> +	u16			pkey_index;
> +	u8			port_num;
> +};
> +
> +struct ib_ports_pkeys {
> +	struct ib_port_pkey	main;
> +	struct ib_port_pkey	alt;
> +};
> +
>  struct ib_qp_security {
> -	void *q_security;
> +	struct ib_qp	       *qp;
> +	/* Hold this mutex when changing port and pkey settings. */
> +	struct mutex		mutex;
> +	struct ib_ports_pkeys	ports_pkeys;
> +	struct ib_ports_pkeys	old_ports_pkeys;
> +	/* A list of all open shared QP handles.  Required to enforce security
> +	 * properly for all users of a shared QP.
> +	 */
> +	struct list_head        shared_qp_list;
> +	void                   *q_security;
>  };
> =20
>  struct ib_qp {
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBotEAAoJEORje4g2clinpWYP/1MIGrbmFWfk6bzRsO1z5nc7
YfShW3ltJ/WLFD8ifvZw03JvVZLJ2rULAVqvg/TWiheqNRGnF8Vd1xhvlDYYuvjd
o2X2LUKUXiBqzLUN1YFASVVGtRp/TXfyH4DvkpU/hVSDjWYy2M/oEON9+eR1ER45
mzJ4nxnbpDhEr2DpvZkY+7nHu7CJixQoOu4wNZIs6Tpmy5faO82rXvSjMgmi7EMG
NSZKUtUreL0kn22qElYZdLpr4hbXiiYJpqqZU9sHfHIgpXCYsp/n3M367zucZOQV
j6DTXeuEgffl7Oum3Ee+Ld3MaKFouKjXQZQHsYG2PUhgz9mSxsjJKBu1j2TYrUU9
fhlkL4ooJohyJEs1OycIPlMVyqmqErWYh8wxh4exvriMGjk6kuxQwp9XnrGabQoH
xAEeT2vDGoaVFtV7QlqDpNxaVu87tWDWPICD7z7q1QVC7c6Bs6vkFtG27F2VoBBv
3CsEgxxKiCBdTwls3lcUcaQrgmKvgiPzB6EPtlKlUicKe7Nitx5auwFqLIXOPuNr
7nkbIae9/4HxpG92wxLNEX+h5iT4BIqhhHhhh2PxHwgJVtls8FMZ06qLyQ0TseuJ
SpYxGoZQRLq/2Gqx0KbW3oRiqgVdn0Wzfzx1eVVPA+8+9gma0jiDybe6TEs4cn8c
42W/JojOYt4bAYOn2hK3
=ABZV
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
