From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: crash unloading mlx4 in 3.2-rc3
Date: Tue, 6 Dec 2011 21:11:51 +0200
Message-ID: <CAJZOPZLacv5w5jZ30sH42LNkpRwT6yH4iPq4yo7WCWYuVhdgzg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373256536F5@ORSMSX102.amr.corp.intel.com>
	<CAL1RGDUkZHZqbLgOBE0PFK7xCV84f1Q-1gYH01p7UKiTYEPRBg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823732565377F@ORSMSX102.amr.corp.intel.com>
	<CAL1RGDWE1HkzWnrU0+Eke-Q2nmxc6jRaoB85s3hnEmEQs3xR6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWE1HkzWnrU0+Eke-Q2nmxc6jRaoB85s3hnEmEQs3xR6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> Yeah, no worries, since that patch works I think I understand the
> problem. =A0And it was in 3.1 AFAICT too... came in with cfcde11c3d7a
> ("IB/mlx4: Use flow counters on IBoE ports") which was in 3.1.
> I'll queue up my fix, thanks for testing.


mmm, so its an A0 thing... should be testing a bit harder next time,
thanks for the quick
debugging

Or.

 drivers/infiniband/hw/mlx4/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c
b/drivers/infiniband/hw/mlx4/main.c
index 77f3dbc..18836cd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1244,7 +1244,8 @@ err_reg:

 err_counter:
 	for (; i; --i)
-		mlx4_counter_free(ibdev->dev, ibdev->counters[i - 1]);
+		if (ibdev->counters[i - 1] !=3D -1)
+			mlx4_counter_free(ibdev->dev, ibdev->counters[i - 1]);

 err_map:
 	iounmap(ibdev->uar_map);
@@ -1275,7 +1276,8 @@ static void mlx4_ib_remove(struct mlx4_dev *dev,
void *ibdev_ptr)
 	}
 	iounmap(ibdev->uar_map);
 	for (p =3D 0; p < ibdev->num_ports; ++p)
-		mlx4_counter_free(ibdev->dev, ibdev->counters[p]);
+		if (ibdev->counters[p] !=3D -1)
+			mlx4_counter_free(ibdev->dev, ibdev->counters[p]);
 	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
