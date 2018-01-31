From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] RDMA/bnxt_re: Add SRQ support for Broadcom adapters
Date: Wed, 31 Jan 2018 08:48:29 +0200
Message-ID: <20180131064829.GR2055@mtr-leonro.local>
References: <20180130124546.GA9394@mwanda>
 <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg@mail.gmail.com>
 <20180131063238.ch4mcl7c6ps7ykxe@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SqfawxHnX56H7Ukl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180131063238.ch4mcl7c6ps7ykxe@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SqfawxHnX56H7Ukl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 09:32:38AM +0300, Dan Carpenter wrote:
> On Wed, Jan 31, 2018 at 11:16:55AM +0530, Devesh Sharma wrote:
> > On Tue, Jan 30, 2018 at 6:15 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > > Hello Devesh Sharma,
> > >
> > > The patch 37cb11acf1f7: "RDMA/bnxt_re: Add SRQ support for Broadcom
> > > adapters" from Jan 11, 2018, leads to the following static checker
> > > warning:
> > >
> > >         drivers/infiniband/hw/bnxt_re/ib_verbs.c:1317 bnxt_re_destroy_srq()
> > >         warn: 'srq->umem' isn't an ERR_PTR
> > >
> > > drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > >   1313                  dev_err(rdev_to_dev(rdev), "Destroy HW SRQ failed!");
> > >   1314                  return rc;
> > >   1315          }
> > >   1316
> > >   1317          if (srq->umem && !IS_ERR(srq->umem))
> > >                                   ^^^^^^^^^^^^^^^^
> > > We never store error pointers to srq->umem.  It's pretty consistently
> > > checked for error pointers though so maybe that's fine.  It causes a
> > > static checker warning because error pointer confusion is a pretty
> > > common source of bugs.  Anyway, feel free to ignore if you want...
> > Thanks for reporting Dan,
> >
> > Is there a way out, I want to call ib_umem_release only if it was valid.
> > I think if ib_umem_release checks for the validity of pointer then I
> > can get rid of this?
> > There are other places also in bnxt_re driver where such checks are present.
>
> Yeah.  Those places generate warnings as well, but I thought one was
> enough.  It's fine if you want to ignore the warning, no one will be
> upset.  :P

Not really, we are trying to clean the subsystem from the warnings
and driver authors who ignore such warnings simply and very effective
sabotage it.

Currently my checks print ~400 warnings for the drivers/infiniband/* +
drivers/net/ethernet/mellanox/*

So please don't increase this number, or fix the driver or fix the tool :)

Thanks

--SqfawxHnX56H7Ukl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxZr0ACgkQ5GN7iDZy
WKeyZA//axv9E/0Q8oLIE0cpE/56KhQXnsqwTp/yLXFIIkzO2YJMPWPwkfZ/kmWS
2lmSOaIXnC8clTlWcQEqKHuiKx3i3RO7E3dnXrwT6fxpAvJxaOn/DAjkutf92Jcy
kK5U27J0VHoG+eDCrx0035ql/T2hjaArV+WSYTVNJ0hvkaPPMnj6GPPz8kPBddel
yHQRUs+vJ5QtoJWDYVjHx+kmr5i9hluEKSJAWJhKDTkfGZ/NsNGPEGck79pNtrCe
QVSOV+Iv+X8T5CDL0/sOd68ouUvO3E/UJQz6CSxniTlKPP5jVIR78MJiL+d5ku6I
1T0CpJ3TlHKCe4sGWDsNY/Z6gCQGVGrEC9WljPj40sUQBUD2G/ro6t/5Ul4AgRfq
x1LnWuJ2cadPu+7ewEY54fR+ls9ga8/D9Q0YSbHDYoI2ZtRQvCFIz+/ofzWdq1L6
jkh/ieeqdvST1baQJvb/0nMbWzOg4fe+LNJBkCkyFdw1Wzt3JVgREmcHxTQ60vlD
UepRTORqC2GWYQqzwyqefjWp7MPWm+VrX6uqq7Cmwkx8zoBJqzboKksQR9eZenrc
NDfjulgyxCrS8pqtd6zO4uIFtqvoap/Arz/8/+PPKoRDUkhHLtfJLh64bGtlj3dd
+UlRtMLJQzjxrdcGeeatLDiq6QXMcaIwGOa04zYnrw/ksya4kPg=
=jIyN
-----END PGP SIGNATURE-----

--SqfawxHnX56H7Ukl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
