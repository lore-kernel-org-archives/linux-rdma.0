From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Tue, 22 Mar 2011 08:51:19 -0400
Message-ID: <1300798279.21813.6.camel@lap75545.ornl.gov>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
 <4D885748.6060600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4D885748.6060600-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By default, each device is assumed to be able only handle 64 KB chunks
during DMA. By giving the segment size a larger value, the block layer
will coalesce more S/G entries together for SRP, allowing larger
requests with the same sg_tablesize setting.

This ups the value on Mellanox hardware to 1 GB, corresponding to
reported firmware limits on mlx4.

Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
--

On Tue, 2011-03-22 at 10:01 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > This ups the value on Mellanox hardware to 2 GB, though there is no=
 HW
> > limit.
>=20
> You've expressed intention to reduce that value to 1GB as of HW=20
> limitations, it would also let you get rid from the warnings on the=20
> current version
>=20
> >  CC [M]  drivers/infiniband/hw/mthca/mthca_main.o
> > drivers/infiniband/hw/mthca/mthca_main.c: In function =E2=80=98__mt=
hca_init_one=E2=80=99:
> > drivers/infiniband/hw/mthca/mthca_main.c:1047: warning: integer ove=
rflow in expression

Well, that's embarrassing. I don't recall seeing those when I tested,
but I don't see how the compiler could have not complained... here's an
updated patch -- against Linus's tree as of a few days ago; work is
currently blocking my git access on wireless. :/

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infinib=
and/hw/mthca/mthca_main.c
index 8a40cd5..f24b79b 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1043,6 +1043,9 @@ static int __mthca_init_one(struct pci_dev *pdev,=
 int hca_type)
 		}
 	}
=20
+	/* We can handle large RDMA requests, so allow larger segments. */
+	dma_set_max_seg_size(&pdev->dev, 1024 * 1024 * 1024);
+
 	mdev =3D (struct mthca_dev *) ib_alloc_device(sizeof *mdev);
 	if (!mdev) {
 		dev_err(&pdev->dev, "Device struct alloc failed, "
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 2765a3c..c835011 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1109,6 +1109,9 @@ static int __mlx4_init_one(struct pci_dev *pdev, =
const struct pci_device_id *id)
 		}
 	}
=20
+	/* Allow large DMA segments, up to the firmware limit of 1 GB */
+	dma_set_max_seg_size(&pdev->dev, 1024 * 1024 * 1024);
+
 	priv =3D kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv) {
 		dev_err(&pdev->dev, "Device struct alloc failed, "

--=20
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
