From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/9] IB/mlx4: Don't return errors from poll_cq
Date: Mon, 29 Aug 2016 12:41:19 +0300
Message-ID: <20160829094119.GB594@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-5-git-send-email-leon@kernel.org>
 <82f1a1be-1189-c8c6-b134-d2f582cc7fa0@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gz4FNQG/2iJjJcgR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <82f1a1be-1189-c8c6-b134-d2f582cc7fa0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gz4FNQG/2iJjJcgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 07:05:51PM +0300, Sagi Grimberg wrote:
>
> > 		/* SRQ is also in the radix tree */
> > 		msrq = mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
> > 				       srq_num);
> >-		if (unlikely(!msrq)) {
> >-			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
> >-				cq->mcq.cqn, srq_num);
> >-			return -EINVAL;
> >-		}
> > 	}
>
> BTW, this is completely unrelated to this patch, but the current
> implementation of shared receive queues in Mellanox drivers is
> *very* inefficient. Each completion that relates to a srq the
> mlx4/mlx5 drivers perform a device-wide locked srq lookup which
> is pretty bad... (it kills consumers that want to use more
> then one SRQ)
>
> Other drivers that support kernel SRQs that I've looked at are ocrdma and
> i40iw and they don't seem to have this lock everything approach.
>
> At the very-least we should try to make it a rcu + percpu_ref
> instead of a killer device-wide lock. It'd be even better if
> we use refcounting in the IB core and have the drivers not worry
> about the kernel consumers destroying SRQs while processing IO
> (i.e. when all the related QPs and CQs are destroyed).

This can be as a beginning.
diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index 6714662..e53d366 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -303,10 +303,10 @@ struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *dev, u32 srqn)
 	struct mlx4_srq *srq;
 	unsigned long flags;

-	spin_lock_irqsave(&srq_table->lock, flags);
+	rcu_read_lock();
 	srq = radix_tree_lookup(&srq_table->tree,
 				srqn & (dev->caps.num_srqs - 1));
-	spin_unlock_irqrestore(&srq_table->lock, flags);
+	rcu_read_unlock();

 	return srq;
 }

>
> I have some code in the works on this but it's not high on my todo
> list at the moment. Mellanox folks, any thoughts on this?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gz4FNQG/2iJjJcgR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxAM/AAoJEORje4g2clinEQUQAJFegU18EVSGkLIf0AcVW1Tm
0jmaevhMl4ESpJbF92egsdkojmx12O2Qmj9jb6nFvzHwIUlP2/pRFTg3SfmOsxdd
gU6K3fvwEAuZNpLZmpE9aEhb5W/rvRFM4d6wMwq8DIhhXhjBV8UqSdvq6pOSRi5o
K//SxIhBcjKisSRaKJMxuXfrJWsLxwabjWWJzWfHU+8Feak/AgXSgSH7/3qJSTb+
yZATX+gfXhy3bUtB4XozDJbcUA2P9wFPUPn7n0eZ8kVRK6DcZizAlXu01NZCciwQ
5CXdl7rxrWPxu6/2CvT+IHsL91wXcMibhK1VT7adbH5XR+2BwmJHPrfODqfshYrw
a0qRnCPfc3zpNIH3yTfL4S3wWIglqxbsbiKHPy2mg2UKilutusjxs0rtBuetn/BP
qeD5oHhJCVavirUDlZwFwlEGuXNI/BrRFY/rVsAZHz+PvRTJ4h6Q1QVIWcmu2iyF
6x9+DgmQxsrOjqqfvWrSVen3/61qdkeRWgmFnibiYrt6n2lWOvmpHweyEXlaNYlC
t4FPy0ii2e2Sds+0u1d0NK7F6VHHjtbJra44MxeRNhpT6lkHtRGncW1nah8OUN8W
Wex/nFo89g+1aW8r+Q+3gQEpZQ/Y4brFn9/qP7Xi+8mWzTTGpjxA3BTdh/Og1W7C
zpq0+x2SdsdOc8hlN5Xd
=V+mB
-----END PGP SIGNATURE-----

--gz4FNQG/2iJjJcgR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
