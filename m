From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Wed, 4 May 2016 09:15:31 +0300
Message-ID: <20160504061531.GF29160@leon.nu>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
 <1462291273-22403-12-git-send-email-hch@lst.de>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m1UC1K4AOz1Ywdkx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462291273-22403-12-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--m1UC1K4AOz1Ywdkx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 03, 2016 at 06:01:13PM +0200, Christoph Hellwig wrote:
> Replace the homegrown RDMA READ/WRITE code in isert with the generic API,
> which also adds iWarp support to the I/O path as a side effect.  Note
> that full iWarp operation will need a few additional patches from Steve.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 841 ++++----------------------=
------
>  drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
>  2 files changed, 85 insertions(+), 825 deletions(-)

Amazing, Thank you.

--m1UC1K4AOz1Ywdkx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKZODAAoJEORje4g2clinIcEQALBcwdct1MQ0CbkcyY2X3V/P
GrcWXnn+lT1wCblOlReYvgkkSlvT07emQqH6gbmoo3yoK9hydEv537ymY8i7rY9T
8uiStm8yyek14N8N00B9Oq3ujJzb1BjQ8N3mTNHcSI/Iq9FfNzE+xY//CSWvgAdw
9dPYE7Nngymy7wdBbwcDkglle1gBcyqkLhcYBdBYyhFBnTm6aFZxkpIGIxHXpjR5
dxtKwYHU+6UD+3bA6pmcPDIRw+mLrXRlu96ApBAMJ6vLWYvr2UlL0ObJdg9p/ztc
AKmryoMU7I9d8MJ1WIbGsVJxm8xUCWt2NI2Rqzl5uo3kjgvc/cVYgvNg/UiFWnDh
EbTfA9U5Y+1Qmdd1C84HuD1GoQgqkBU0CmIwIRdAIBjyFJJYzvdUE696wep5VIN8
xWexmQK8ui3stm3z+w2ZmakFQMe45R8X3IbsFiY1N8tnTZcrTfJsdsQtZnhugzij
+X9ahthbcpcdJdOH++0elEMXHw8d+Z0y7jLYYocBGe6klla+jBG/RZpIKbdy9Nra
Yi2Xgd4mfjtuhjirqZamO8KZhfOUkLFwUQHMWp+Fv47Mj/tmPEn9ctArfXIJyOE1
+psUtePsWLSU8LGnXPW7p2wixyuXbRIhj+VQTXXBk/MRG0iV+no5NVdMqIHzTEnZ
KjtE5JOhSSurtloCkWKY
=jpFH
-----END PGP SIGNATURE-----

--m1UC1K4AOz1Ywdkx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
