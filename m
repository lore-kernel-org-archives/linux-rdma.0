From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Support rq record doorbell for
 the user space
Date: Mon, 22 Jan 2018 10:08:52 +0200
Message-ID: <20180122080852.GI1393@mtr-leonro.local>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y96v7rNg6HAoELs5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516242871-154089-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--y96v7rNg6HAoELs5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 18, 2018 at 10:34:28AM +0800, Yixian Liu wrote:
> This patch adds interfaces and definitions to support the rq record
> doorbell for the user space.
>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/Makefile          |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_db.c     | 94 +++++++++++++++++++++++++++++
>  drivers/infiniband/hw/hns/hns_roce_device.h | 41 ++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 22 ++++++-
>  drivers/infiniband/hw/hns/hns_roce_main.c   |  5 ++
>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 32 +++++++++-
>  6 files changed, 191 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/infiniband/hw/hns/hns_roce_db.c
>
> diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
> index 97bf2cd..cf03404 100644
> --- a/drivers/infiniband/hw/hns/Makefile
> +++ b/drivers/infiniband/hw/hns/Makefile
> @@ -7,7 +7,7 @@ ccflags-y :=  -Idrivers/net/ethernet/hisilicon/hns3
>  obj-$(CONFIG_INFINIBAND_HNS) += hns-roce.o
>  hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
>  	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
> -	hns_roce_cq.o hns_roce_alloc.o
> +	hns_roce_cq.o hns_roce_alloc.o hns_roce_db.o
>  obj-$(CONFIG_INFINIBAND_HNS_HIP06) += hns-roce-hw-v1.o
>  hns-roce-hw-v1-objs := hns_roce_hw_v1.o
>  obj-$(CONFIG_INFINIBAND_HNS_HIP08) += hns-roce-hw-v2.o
> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
> new file mode 100644
> index 0000000..0908208
> --- /dev/null
> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright (c) 2017 Hisilicon Limited.
> + * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.

Good to know

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

Please move to use SPDX headers for new files.

> +
> +#include <linux/platform_device.h>
> +#include <rdma/ib_umem.h>
> +#include "hns_roce_device.h"
> +
> +int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
> +			 struct hns_roce_db *db)
> +{
> +	struct hns_roce_user_db_page *db_page;
> +	int ret = 0;
> +
> +	mutex_lock(&context->db_page_mutex);
> +
> +	list_for_each_entry(db_page, &context->db_page_list, list)
> +		if (db_page->user_virt == (virt & PAGE_MASK))
> +			goto found;
> +
> +	db_page = kmalloc(sizeof(*db_page), GFP_KERNEL);
> +	if (!db_page) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	db_page->user_virt = (virt & PAGE_MASK);
> +	db_page->refcnt    = 0;
> +	db_page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
> +					 PAGE_SIZE, 0, 0);
> +	if (IS_ERR(db_page->umem)) {
> +		ret = PTR_ERR(db_page->umem);
> +		kfree(db_page);
> +		goto out;
> +	}
> +
> +	list_add(&db_page->list, &context->db_page_list);
> +
> +found:
> +	db->dma = sg_dma_address(db_page->umem->sg_head.sgl) +
> +		  (virt & ~PAGE_MASK);
> +	db->u.user_page = db_page;
> +	++db_page->refcnt;
> +
> +out:
> +	mutex_unlock(&context->db_page_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(hns_roce_db_map_user);
> +
> +void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
> +			    struct hns_roce_db *db)
> +{
> +	mutex_lock(&context->db_page_mutex);
> +
> +	if (!--db->u.user_page->refcnt) {
> +		list_del(&db->u.user_page->list);
> +		ib_umem_release(db->u.user_page->umem);
> +		kfree(db->u.user_page);
> +	}
> +
> +	mutex_unlock(&context->db_page_mutex);
> +}
> +EXPORT_SYMBOL(hns_roce_db_unmap_user);
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index 42c3b5a..65c09c5 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -178,7 +178,8 @@ enum {
>  enum {
>  	HNS_ROCE_CAP_FLAG_REREG_MR		= BIT(0),
>  	HNS_ROCE_CAP_FLAG_ROCE_V1_V2		= BIT(1),
> -	HNS_ROCE_CAP_FLAG_RQ_INLINE		= BIT(2)
> +	HNS_ROCE_CAP_FLAG_RQ_INLINE		= BIT(2),
> +	HNS_ROCE_CAP_FLAG_RECORD_DB		= BIT(3)
>  };
>
>  enum hns_roce_mtt_type {
> @@ -186,6 +187,10 @@ enum hns_roce_mtt_type {
>  	MTT_TYPE_CQE,
>  };
>
> +enum {
> +	HNS_ROCE_DB_PER_PAGE = PAGE_SIZE / 4
> +};
> +
>  #define HNS_ROCE_CMD_SUCCESS			1
>
>  #define HNS_ROCE_PORT_DOWN			0
> @@ -203,6 +208,8 @@ struct hns_roce_uar {
>  struct hns_roce_ucontext {
>  	struct ib_ucontext	ibucontext;
>  	struct hns_roce_uar	uar;
> +	struct list_head	db_page_list;
> +	struct mutex		db_page_mutex;
>  };
>
>  struct hns_roce_pd {
> @@ -335,6 +342,33 @@ struct hns_roce_buf {
>  	int				page_shift;
>  };
>
> +struct hns_roce_db_pgdir {
> +	struct list_head	list;
> +	DECLARE_BITMAP(order0, HNS_ROCE_DB_PER_PAGE);
> +	DECLARE_BITMAP(order1, HNS_ROCE_DB_PER_PAGE / 2);
> +	unsigned long		*bits[2];

I didn't see any usage of the fields from this struct in this patch,
where did you use them?

> +	u32			*db_page;
> +	dma_addr_t		db_dma;
> +};
> +
> +struct hns_roce_user_db_page {
> +	struct list_head	list;
> +	struct ib_umem		*umem;
> +	unsigned long		user_virt;
> +	int			refcnt;

refcount_t please.

> +};
> +
> +struct hns_roce_db {
> +	u32		*db_record;
> +	union {
> +		struct hns_roce_db_pgdir *pgdir;
> +		struct hns_roce_user_db_page *user_page;
> +	} u;
> +	dma_addr_t	dma;
> +	int		index;
> +	int		order;
> +};
> +
>  struct hns_roce_cq_buf {
>  	struct hns_roce_buf hr_buf;
>  	struct hns_roce_mtt hr_mtt;
> @@ -465,6 +499,7 @@ struct hns_roce_rinl_buf {
>  struct hns_roce_qp {
>  	struct ib_qp		ibqp;
>  	struct hns_roce_buf	hr_buf;
> +	struct hns_roce_db	rdb;
>  	struct hns_roce_wq	rq;
>  	__le64			doorbell_qpn;
>  	__le32			sq_signal_bits;
> @@ -930,6 +965,10 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
>  int hns_roce_ib_destroy_cq(struct ib_cq *ib_cq);
>  void hns_roce_free_cq(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq);
>
> +int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
> +			 struct hns_roce_db *db);
> +void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
> +			    struct hns_roce_db *db);
>  void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
>  void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
>  void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 256fe11..e0f4dc4 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -1140,7 +1140,8 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
>
>  	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
>  				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2 |
> -				  HNS_ROCE_CAP_FLAG_RQ_INLINE;
> +				  HNS_ROCE_CAP_FLAG_RQ_INLINE |
> +				  HNS_ROCE_CAP_FLAG_RECORD_DB;
>  	caps->pkey_table_len[0] = 1;
>  	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
>  	caps->ceqe_depth	= HNS_ROCE_V2_COMP_EQE_NUM;
> @@ -2246,6 +2247,19 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
>  		hr_qp->qkey = attr->qkey;
>  	}
>
> +	roce_set_bit(context->byte_68_rq_db, V2_QPC_BYTE_68_RQ_RECORD_EN_S, 1);
> +	roce_set_bit(qpc_mask->byte_68_rq_db, V2_QPC_BYTE_68_RQ_RECORD_EN_S, 0);
> +
> +	roce_set_field(context->byte_68_rq_db,
> +		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_M,
> +		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_S,
> +		       ((u32)hr_qp->rdb.dma) >> 1);
> +	roce_set_field(qpc_mask->byte_68_rq_db,
> +		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_M,
> +		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_S, 0);
> +	context->rq_db_record_addr = hr_qp->rdb.dma >> 32;
> +	qpc_mask->rq_db_record_addr = 0;
> +
>  	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 1);
>  	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 0);
>
> @@ -3183,6 +3197,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
>  		hr_qp->sq.tail = 0;
>  		hr_qp->sq_next_wqe = 0;
>  		hr_qp->next_sge = 0;
> +		if (hr_qp->rq.wqe_cnt)
> +			*hr_qp->rdb.db_record = 0;
>  	}
>
>  out:
> @@ -3409,6 +3425,10 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
>  	hns_roce_mtt_cleanup(hr_dev, &hr_qp->mtt);
>
>  	if (is_user) {
> +		if (hr_qp->rq.wqe_cnt)
> +			hns_roce_db_unmap_user(
> +				to_hr_ucontext(hr_qp->ibqp.uobject->context),
> +				&hr_qp->rdb);
>  		ib_umem_release(hr_qp->umem);
>  	} else {
>  		kfree(hr_qp->sq.wrid);
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index aa0c242..dd7d882 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -350,6 +350,11 @@ static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
>  	if (ret)
>  		goto error_fail_uar_alloc;
>
> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
> +		INIT_LIST_HEAD(&context->db_page_list);
> +		mutex_init(&context->db_page_mutex);
> +	}
> +
>  	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
>  	if (ret)
>  		goto error_fail_copy_to_udata;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
> index 4414cea..300f760 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
> @@ -489,6 +489,15 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
>  	return 0;
>  }
>
> +static int hns_roce_qp_has_rq(struct ib_qp_init_attr *attr)
> +{
> +	if (attr->qp_type == IB_QPT_XRC_INI ||
> +	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>  				     struct ib_pd *ib_pd,
>  				     struct ib_qp_init_attr *init_attr,
> @@ -602,6 +611,17 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>  			dev_err(dev, "hns_roce_ib_umem_write_mtt error for create qp\n");
>  			goto err_mtt;
>  		}
> +
> +		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
> +		    hns_roce_qp_has_rq(init_attr)) {
> +			ret = hns_roce_db_map_user(
> +					to_hr_ucontext(ib_pd->uobject->context),
> +					ucmd.db_addr, &hr_qp->rdb);
> +			if (ret) {
> +				dev_err(dev, "rp record doorbell map failed!\n");
> +				goto err_mtt;
> +			}
> +		}
>  	} else {
>  		if (init_attr->create_flags &
>  		    IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
> @@ -707,8 +727,16 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>  		hns_roce_release_range_qp(hr_dev, qpn, 1);
>
>  err_wrid:
> -	kfree(hr_qp->sq.wrid);
> -	kfree(hr_qp->rq.wrid);
> +	if (ib_pd->uobject) {
> +		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
> +		    hns_roce_qp_has_rq(init_attr))
> +			hns_roce_db_unmap_user(
> +					to_hr_ucontext(ib_pd->uobject->context),
> +					&hr_qp->rdb);
> +	} else {
> +		kfree(hr_qp->sq.wrid);
> +		kfree(hr_qp->rq.wrid);
> +	}
>
>  err_mtt:
>  	hns_roce_mtt_cleanup(hr_dev, &hr_qp->mtt);
> --
> 1.9.1
>

--y96v7rNg6HAoELs5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlplnBQACgkQ5GN7iDZy
WKfKTRAAl8Bocyx46gD2kcBlWgGA0APKn6v4kxmYXBCSJ2TXzJiI5x8peXfnrwSd
HXIcdoKWy5lvygSsyT4MsRDXbqqhuHsqpkl1tIZuPRDiwME3Mkb9ZZ21uoLLsPef
2UTEpkVHCqZtv9GYgln5oJExP9Nuu+AvC8lJKY2vbk2cgZYMRXiDLQhZRziND9mq
sCFNA1gTK7ozU76svCbBujLgHGXWE5xBMHEnCHHQrA0D6ypJNP87DDqigDApajWo
fH5nx3W1XC4GYqAjJ2i7zZ+KUctgz9gPwPvmqWIAG9B/jHR932oyNlV8w643+y+V
lPGtl7y6GfCxca8T0j/uG1Byv4uIDujflwloJkXYtrlqCb6YivOQmDRcqJgeaqoN
RdsV4SjPnmoO3az2v/nxU+JJV8rn9OIABUZXC/7Vxv7TMUQeF79z+xLJDhU/S/9q
AHie6jZCkbDbJHGAsmaP3Mji8K6jZmP1CEDMfAE6FqX5eZydQJsCHFUHIBYdx9H7
auZVqoNlxlL6sO0UH/RXC1Ii/8MOGmvDQUKPGuvjg9j87vrla3TnI+FWOEunFnqZ
VKC1Bpxf31jQBWF4ecUmDXfF1XaWbo8xFsJtxd2WRk7FEM2V7H3rcSHIdUS+Wx9p
q3Z5mbTdxh2+hYQV3QRNM2touQgk1JgOec/9kVau3seUtZbxnuM=
=dgQg
-----END PGP SIGNATURE-----

--y96v7rNg6HAoELs5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
