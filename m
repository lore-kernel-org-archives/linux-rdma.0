From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 23/37] add rxe_mcast.c
Date: Sat, 20 Aug 2011 18:13:38 +0200
Message-ID: <CAO+b5-p1f796QMteE8xLPVS=NSZE+ZJGkCjDH8qkv6UnxxMF1Q@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.264963653@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.264963653-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +int rxe_mcast_drop_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
> +			    union ib_gid *mgid, u16 mlid)
> +{
> +	struct rxe_mc_grp *grp;
> +	struct rxe_mc_elem *elem, *tmp;
> +
> +	grp = rxe_pool_get_key(&rxe->mc_grp_pool, mgid);
> +	if (!grp)
> +		goto err1;
> +
> +	spin_lock_bh(&qp->grp_lock);
> +	spin_lock_bh(&grp->mcg_lock);
> +
> +	list_for_each_entry_safe(elem, tmp, &grp->qp_list, qp_list) {
> +		if (elem->qp == qp) {
> +			list_del(&elem->qp_list);
> +			list_del(&elem->grp_list);
> +			grp->num_qp--;
> +
> +			spin_unlock_bh(&grp->mcg_lock);
> +			spin_unlock_bh(&qp->grp_lock);
> +			rxe_drop_ref(elem);
> +			rxe_drop_ref(grp);	/* ref held by QP */
> +			rxe_drop_ref(grp);	/* ref from get_key */
> +			return 0;
> +		}
> +	}

The above loop is left after a match has been found. Do we really need
list_for_each_entry_safe() here ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
