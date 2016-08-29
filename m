From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/9] IB/mlx4: Don't return errors from poll_cq
Date: Mon, 29 Aug 2016 13:04:34 +0300
Message-ID: <20160829100434.GD594@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-5-git-send-email-leon@kernel.org>
 <82f1a1be-1189-c8c6-b134-d2f582cc7fa0@grimberg.me>
 <20160829094119.GB594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xOS8do0ZRfB5pORP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160829094119.GB594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--xOS8do0ZRfB5pORP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2016 at 12:41:19PM +0300, Leon Romanovsky wrote:
> On Sun, Aug 28, 2016 at 07:05:51PM +0300, Sagi Grimberg wrote:
> >
> > > 		/* SRQ is also in the radix tree */
> > > 		msrq =3D mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
> > > 				       srq_num);
> > >-		if (unlikely(!msrq)) {
> > >-			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
> > >-				cq->mcq.cqn, srq_num);
> > >-			return -EINVAL;
> > >-		}
> > > 	}
> >
> > BTW, this is completely unrelated to this patch, but the current
> > implementation of shared receive queues in Mellanox drivers is
> > *very* inefficient. Each completion that relates to a srq the
> > mlx4/mlx5 drivers perform a device-wide locked srq lookup which
> > is pretty bad... (it kills consumers that want to use more
> > then one SRQ)
> >
> > Other drivers that support kernel SRQs that I've looked at are ocrdma a=
nd
> > i40iw and they don't seem to have this lock everything approach.
> >
> > At the very-least we should try to make it a rcu + percpu_ref
> > instead of a killer device-wide lock. It'd be even better if
> > we use refcounting in the IB core and have the drivers not worry
> > about the kernel consumers destroying SRQs while processing IO
> > (i.e. when all the related QPs and CQs are destroyed).
>
> This can be as a beginning.
> diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ether=
net/mellanox/mlx4/srq.c
> index 6714662..e53d366 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/srq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
> @@ -303,10 +303,10 @@ struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *d=
ev, u32 srqn)
>  	struct mlx4_srq *srq;
>  	unsigned long flags;
>
> -	spin_lock_irqsave(&srq_table->lock, flags);
> +	rcu_read_lock();
>  	srq =3D radix_tree_lookup(&srq_table->tree,
>  				srqn & (dev->caps.num_srqs - 1));
> -	spin_unlock_irqrestore(&srq_table->lock, flags);
> +	rcu_read_unlock();
>
>  	return srq;
>  }

Or more complete patch (untested),

=46rom 8695e5b807610e08de055b04ddd16caa6a5b61f2 Mon Sep 17 00:00:00 2001
=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 29 Aug 2016 12:42:24 +0300
Subject: [PATCH] IB/mlx4: Use RCU to perform radix tree lookup for SRQ

Radix tree lookup can be performed without locking.

Suggested-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/srq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/etherne=
t/mellanox/mlx4/srq.c
index 6714662..f44d089 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -45,15 +45,12 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int=
 event_type)
 	struct mlx4_srq_table *srq_table =3D &mlx4_priv(dev)->srq_table;
 	struct mlx4_srq *srq;

-	spin_lock(&srq_table->lock);
-
+	rcu_read_lock();
 	srq =3D radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - =
1));
+	rcu_read_unlock();
 	if (srq)
 		atomic_inc(&srq->refcount);
-
-	spin_unlock(&srq_table->lock);
-
-	if (!srq) {
+	else {
 		mlx4_warn(dev, "Async event for bogus SRQ %08x\n", srqn);
 		return;
 	}
@@ -301,12 +298,11 @@ struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *dev=
, u32 srqn)
 {
 	struct mlx4_srq_table *srq_table =3D &mlx4_priv(dev)->srq_table;
 	struct mlx4_srq *srq;
-	unsigned long flags;

-	spin_lock_irqsave(&srq_table->lock, flags);
+	rcu_read_lock();
 	srq =3D radix_tree_lookup(&srq_table->tree,
 				srqn & (dev->caps.num_srqs - 1));
-	spin_unlock_irqrestore(&srq_table->lock, flags);
+	rcu_read_unlock();

 	return srq;
 }
--
2.7.4


>
> >
> > I have some code in the works on this but it's not high on my todo
> > list at the moment. Mellanox folks, any thoughts on this?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--xOS8do0ZRfB5pORP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxAiyAAoJEORje4g2clinv0oP/A5u3tPqwT5nADycinQ7dryt
c8hqkJfGQHMfkd985lkmyfiSi1l32EOjm3zA1YKAdrIf38LaRV/qLoBo0y3izWTO
Ap3HVYpyQchQpoZF9bH+C/RFc/jSXc2mNf4dVLiyaPs6PLvbzE/TcwWHrgZmP23J
RKNW279DMz8uWqetlwUdC58oOuKj4wUzRNnwzjeRFbQ65aKqOCaS8NqYpKwBqzBw
RQ38vCG9UyUhoWuE/Iljrfrpyp7OjL3oQ2cxXPkaLpjsQEnj4y2bLDm1Sb2U4RDI
d+MdLhvcDtCnRvtMYZzk0i+JCXYTlTiLdMYRic3A7p/9w/LK9yDUDTZIf94pi7tA
JOjhlsYpCdflcL5pYDo6ycfwDxd07T7Z6vimPPkX8JnBNf16AqhJi+qSJ8yIsSYp
LE69EKciLU/pL7RZF5wIy5x+AeutFxSkw2bDw/IG6U2zPYpoJSWAXCPi9E7awMAI
59fXVhhnnGW5adWTkYNs8Qz86WI+6pfEaKer8LVsvU/yoMnfob8XBlZuYdOkIKwo
K0XzrYvyLrc+4d/ycKE3dXduBVKGcnP6x5svSBPs17k8qtuQWCrPjujqQYbspZ9l
nHiR0SEL214uliTdXwQxIC0SZp0G+P55ULWHBWYQ7Fe7CqFgAom27S/67j4FXQhS
Be6vbFtUwayXqnfPhZyZ
=9P5C
-----END PGP SIGNATURE-----

--xOS8do0ZRfB5pORP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
