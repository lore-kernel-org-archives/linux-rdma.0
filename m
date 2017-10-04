From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Wed, 4 Oct 2017 20:23:23 +0300
Message-ID: <20171004172323.GH25829@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
 <20171003061657.GA13648@mtr-leonro.local>
 <20171003160059.GB30753@obsidianresearch.com>
 <20171003170140.GD25829@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB19A6C6@ORSMSX109.amr.corp.intel.com>
 <20171003180735.GE25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003180735.GE25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 09:07:35PM +0300, Leon Romanovsky wrote:
> On Tue, Oct 03, 2017 at 05:05:06PM +0000, Hefty, Sean wrote:
> > > > > >  	if ((be32_to_cpu(dlid) >=
> > > > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > > > > >  	    (be32_to_cpu(slid) >=
> > > > > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
> > > > >
> > > > > You can drop be32_to_cpu and be16_to_cpu now.
> > > > > The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
> > > > > comparison will work.
> > > >
> > > > It won't order properly for >=, the swap is still needed...
> > >
> > > Jason,
> > > Do you have reference for that?
> > >
> > > I tried to find any information about comparison of values from one
> > > endianess on machine with another endianess and didn't find anything
> > > relevant.
> >
> > The bytes are out of order, so the comparisons won't work.
>
> I understand it for the "manual" comparison (C-like arrays), but does it apply
> for the compiler-aware comparison? Both these variables are marked as
> __be32 for the compiler.

OK, I finally found time to test my question and you and Jason are right.
Thank you for your time.

For curious readers, the snippet below, tested on x86:

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bcc4c2db81d0..234105716120 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4754,6 +4754,15 @@ static int __init mlx5_ib_init(void)
 {
 	int err;

+	uint32_t u1 = 0x2233;
+	uint32_t u2 = 0x4411;
+
+	__be32 b1 = cpu_to_be32(u1);
+	__be32 b2 = cpu_to_be32(u2);
+
+	printk(KERN_ERR "test: u1 %s u1\n", (u1 < u2 ) ? "<":">");
+	printk(KERN_ERR "test: b1 %s b1\n", (b1 < b2 ) ? "<":">");
+
 	mlx5_ib_odp_init();

 	err = mlx5_register_interface(&mlx5_ib_interface);

and the result:
[    6.566979] test: u1 < u1
[    6.567147] test: b1 > b1

Thanks

>
> Thanks



--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnVGQsACgkQ5GN7iDZy
WKf93g//TQEqprX7Isk+QQccKT5+vFWMEsetOKJGXXheOaZfmlvp7JbF5rS2F179
dHK4rAKPpp4mVAPNvrIt4gPy+VEo/4k+UBhJo0OeA5MQSXkpIRhifATV/N7yCquw
ueY/wYPKr22XS9bEeF9wgSNRRCFFj+2i0n/8DlmUrjRkKaT8c4et1T3FkLd9SAtg
ZkYzmq1HvjjMzKPOL9r8ToP/FfumT1ws+fpprfigjJGwGVfU9Im5YxHZEN9hw3PO
XkEW/P2FHskykhAbt6hU73poDVh6ABsA9iZfSnaYy417P0WvGs4J8o+vxe4Hgu8V
isyY5rvG1FKOapctbRNLlkgwzaoWcB1stEnvtYxVEdAdiZOdVUb79H0QBG5pXwwd
k+XSQRH8ErRDAEjF5C7qh3nXm1cmVd0ZVYJfmVyD12TcwfgbVqj1C45eS6VXoTGU
AJby9LJQ9QDfrHRtuElwqOL2X/621r8HFzP6Ne4Pa7e2fTFFCR4pl2kbH5qEvS6K
skBpQUQbsbSC+HZk4kXS56oCY9Pj/CakYXPdC8DejwpWgv9x94xeBRQxrtPrbelb
HVAk8AXMii90CEsW23K7NFM0z5KY8KqFMmO8Ta1ZG5/aM2na6U+OUY4M9uivA2QF
OyoK6tcmGBljDvq7MV43mvCCYeoD/r6t7iqZbMLc9/vxIT18654=
=tkW0
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
