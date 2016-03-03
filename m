From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 14:02:46 -0600
Message-ID: <019d01d17587$a7a7ecd0$f6f7c670$@opengridcomputing.com>
References: <1457028192-24965-1-git-send-email-hch@lst.de> <1457028192-24965-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457028192-24965-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> This supports both manual mapping of lots of SGEs, as well as using MRs
> from the QP's MR pool, for iWarp or other cases where it's more optimal.
> For now, MRs are only used for iWARP transports.  The user of the RDMA-RW
> API must allocate the QP MR pool as well as size the SQ accordingly.
> 
> Thanks to Steve Wise for testing, fixing and rewriting the iWarp support,
> and to Sagi Grimberg for ideas, reviews and fixes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/Makefile  |   2 +-
>  drivers/infiniband/core/mr_pool.c |   4 +-
>  drivers/infiniband/core/rw.c      | 419 ++++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/verbs.c   |  25 +++
>  include/rdma/ib_verbs.h           |  14 +-
>  include/rdma/rw.h                 |  69 +++++++
>  6 files changed, 530 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/infiniband/core/rw.c
>  create mode 100644 include/rdma/rw.h
> 
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> index 48bd9d8..26987d9 100644
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@ -8,7 +8,7 @@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
>  obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
>  					$(user_access-y)
> 
> -ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
> +ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
>  				device.o fmr_pool.o cache.o netlink.o \
>  				roce_gid_mgmt.o mr_pool.o
>  ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
> diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
> index b1eb27a..9751bb1 100644
> --- a/drivers/infiniband/core/mr_pool.c
> +++ b/drivers/infiniband/core/mr_pool.c
> @@ -20,8 +20,10 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)
> 
>  	spin_lock_irqsave(&qp->mr_lock, flags);
>  	mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
> -	if (mr)
> +	if (mr) {
> +		list_del(&mr->qp_entry);
>  		qp->mrs_used++;
> +	}
>  	spin_unlock_irqrestore(&qp->mr_lock, flags);
>

Should the above be squashed into the mr_pool patch?

Also, in your isert WIP patch from your git repo:

patch 46debb67 ("IB/core: add a MR pool for signature MRs")

You accidentally undid the above change:

@@ -20,10 +20,8 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)

        spin_lock_irqsave(&qp->mr_lock, flags);
        mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
-       if (mr) {
-               list_del(&mr->qp_entry);
+       if (mr)
                qp->mrs_used++;
-       }
        spin_unlock_irqrestore(&qp->mr_lock, flags);

        return mr;


It causes a few Oopses... :)

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
