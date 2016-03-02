From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 05/13] IB/core: add a simple MR pool
Date: Wed, 2 Mar 2016 08:18:14 +0530
Message-ID: <CAG53R5W2Xi--LdMwwcB68d+2VYS100zEM+zW4Qi79SwoUiQE=w@mail.gmail.com>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
	<1456596631-19418-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456596631-19418-6-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

On Sat, Feb 27, 2016 at 11:40 PM, Christoph Hellwig <hch@lst.de> wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 267f11e..1e68dae 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1408,6 +1408,10 @@ struct ib_qp {
>         struct ib_srq          *srq;
>         struct ib_xrcd         *xrcd; /* XRC TGT QPs only */
>         struct list_head        xrcd_list;
> +
> +       spinlock_t              mr_lock;
> +       int                     mrs_used;
> +

Can you please add the comment for mr_lock as requested by the
checkpatch script?

Also you might want to consider adding this field after recv_cq so
that we find mr_lock and used count in single cache line along with
other data for the qp?
