From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 14:48:28 -0600
Message-ID: <01a401d1758e$0a227050$1e6750f0$@opengridcomputing.com>
References: <1457028192-24965-1-git-send-email-hch@lst.de> <1457028192-24965-7-git-send-email-hch@lst.de> <019e01d17587$a7b11490$f7133db0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <019e01d17587$a7b11490$f7133db0$@opengridcomputing.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Also, in your isert WIP patch from your git repo:
> 
> patch 46debb67 ("IB/core: add a MR pool for signature MRs")
> 
> You accidentally undid the above change:
> 
> @@ -20,10 +20,8 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct
> list_head *list)
> 
>         spin_lock_irqsave(&qp->mr_lock, flags);
>         mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
> -       if (mr) {
> -               list_del(&mr->qp_entry);
> +       if (mr)
>                 qp->mrs_used++;
> -       }
>         spin_unlock_irqrestore(&qp->mr_lock, flags);
> 
>         return mr;
> 
> 
> It causes a few Oopses... :)
> 
> Steve.

With the above change undone, your rdma-rw-api branch tests out ok with iser/iwarp.

Tested-by: Steve Wise <swise@opengridcomputing.com>
