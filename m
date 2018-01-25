From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 10:45:29 -0700
Message-ID: <20180125174529.GB3739@ziepe.ca>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125151227.28202-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 05:12:22PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> +
> +/**
> + * struct rdma_restrack_entry - metadata per-entry
> + */
> +struct rdma_restrack_entry {
> +	/**
> +	 * @valid: validity indicator
> +	 *
> +	 * The entries are filled during rdma_restrack_add,
> +	 * can be attempted to be free during rdma_restrack_del.
> +	 *
> +	 * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> +	 */
> +	bool			valid;
> +	/*
> +	 * @kref: Protect destroy of the resource
> +	 */
> +	struct kref		kref;

Sticking a kref in a random structure that is itself not malloc'd is a
big red flag:

@@ -1746,6 +1756,11 @@ struct ib_qp {
+       struct rdma_restrack_root     res;


Not seeing how this works at all.

qp does this:

+       rdma_restrack_del(&qp->res);
        ret = qp->device->destroy_qp(qp);

And for instance the mlx5 implementation of destroy_qp() does:

int mlx5_ib_destroy_qp(struct ib_qp *qp)
{
        struct mlx5_ib_qp *mqp = to_mqp(qp);
[..]

        kfree(mqp);

So we kfree the kref containing memory outside the kref's release
function. Super big red flag.

rdma_restrack_del is just:

+       return kref_put(&res->kref, restrack_release);

So we don't do anything to block progress to the kfree unless
the kref drefs to 0. But the reader holds a get/put across its
critical section so we never hit the 0 case when there is another
user.

Not even remotely right.

Adding a kref means it has to be added to struct ib_qp and then kfree's
in the drivers need to change to kref_put. That is alot of work.

The best idea I've had to make this locking work is what I emailed you
a few days ago..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
