From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1] RDMA/rw: Remove force_mr module parameter
Date: Sun, 2 Jul 2017 20:56:49 +0300
Message-ID: <20170702175649.GE8041@mtr-leonro.local>
References: <20170702062425.6780-1-leon@kernel.org>
 <20170702153532.GA18051@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170702153532.GA18051-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 02, 2017 at 08:35:32AM -0700, Christoph Hellwig wrote:
> NAK.  It's a very useful debug helper and should instead also be
> exposed at runtime.

So dramatic,
Last time, you wrote that you (AUTHOR) didn't use this module parameter,
so what did happen from that post?

----
https://www.spinics.net/lists/linux-rdma/msg49891.html
I think I only added it on requests from someone (you?), and when
writing the code debugged it by manually forcing it to on.
----

No one is removing the logic and the code in the IB/core, the change is
here is in removing visibility to the user.

Thanks

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllZM+EACgkQ5GN7iDZy
WKc6NA/9HW5EyLV2Rvn9JYtWmehQnP3/L0Ganjqxv4SeyjImDofbcWbh87QHYk1H
R6z+c9Nth3/jIaQdCbWQRfaUt2wmbJvQwxuVtBwxBu8+GmFtBLOdSCHlxEOkrvhq
4noGdU3clSvtbj7Te0l7o8dGS6KegvCnU/EID7dNRu+RkGbtg5OVgY8s3q4dOxuc
cBVb2pUhTugGoXFbBTPVn58M6XAMAsCBe7E7AYfQzluF3TD7zI6rT2O0CxTPahP1
Hs3IVbNibYnspSVa+/Hwgs8GDfeNjmGfOYXD+tpD8oC5mzfPzfckOqlIxFtvU7Vb
Z4zQjU3Nq0yqJfbXwaiZyztCAwoV93vbCWRMKR4IeKv0sR/deGKETDCdg9c0hp5I
L1O6OS5F25hZ1DVvUa0myLosZCtaBWkCtjZzOuDG6n3V4sBrPFdrksptdv7xOvJk
PStPtXaUsbQlOvJyOXf8Cnq6mEoymul7jiGpI33Ayr7BRcEPCpkM9JVuBISZWLXd
BtpFkw/7q7h3QResLO5jX46EsvDEFgy2t07b7dIQu3dOcKoHj9jJjx5m/hU9h6+z
WDd27Cm2GuCRqi6q1E8XOq2YURyWx+zOgxK+kf5L42isybF7qUCEe35XMj89rCJ5
C6okdldKUBv2t9cPSA1tgWT168zG/2IRpvMcB0RdIKzdLqIApFo=
=oBIj
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
