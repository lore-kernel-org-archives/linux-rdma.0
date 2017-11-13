From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] iw_cxgb4: atomically flush the qp
Date: Mon, 13 Nov 2017 17:00:24 -0500
Message-ID: <1510610424.3735.45.camel@redhat.com>
References: <20171110182310.259318761@linode.aoot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iEVKFmDjRYDciion4ghq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110182310.259318761-4JwuKsrtP3INXE9Dec0ohg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-iEVKFmDjRYDciion4ghq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-09 at 07:21 -0800, Steve Wise wrote:
> __flush_qp() has a race condition where during the flush operation,
> the qp lock is released allowing another thread to possibly post a WR,
> which corrupts the queue state, possibly causing crashes.  The lock was
> released to preserve the cq/qp locking hierarchy of cq first, then qp.
> However releasing the qp lock is not necessary; both RQ and SQ CQ locks
> can be acquired first, followed by the qp lock, and then the RQ and SQ
> flushing can be done w/o unlocking.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-iEVKFmDjRYDciion4ghq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKFfgACgkQuCajMw5X
L92slQ/8DihQ4biYzc32RG/1ShgNVrdxvYA6xKUaDLQjHQgtYWGelPJ5vOkhvQGW
nvlaAsZNm1LBP83sUpbAQuVNVfJvdq5nen6/V6EKaaLsbePMnAd4YCZ462arok1d
9ELZ6fB8YQiDdWBW9MtEWx5iL5ZdKUqb+DY1dj8qQYQ3/VikKrX/ijVZkyJtfso4
xZL2IGcOgzz4bVavhBHOR2AFPNNh4kc1yWk+cCU6Hzw0Yopi78H0anHWA+JBTi3B
Gmunu2ztX1gOkY/1VSygfRXnC7aSX1YapydTa2ZU/8mW/TXKOST0lc3qI7V1wm+H
8HHsYSmFnA3nMfzcO2vqB++TMh10AeGMFbBxNnupt9qlQOUl3I/IKGROHct+/pP5
v4SvsXwtDNQULgAo/zoahT3KJs1nPxCm+WACz7Zfq1oYns+ErQCTnL4eO5LKw9Hg
Vsk2Z0dIjakaH5uKh/eguibRXzHtH/E9FQGD1ziklSmfZE6dnQVLx9jV8wiN0rik
ndab0NKHLqq0gxI+dj0bC1nQZVTw02PGjpB0+NNdtFBrE8BYCCYVd8gQQi388OOa
mbWzsMvDwF6lUYIlg/Rog9Qbhr/OyUUgUQmLMr8Ga/b7s6lKom/G7R4fI2NXTzd0
PT7PTIPMu38seH0JqmtOyp7MUPtS1hmMxUzKPAPWDR2bG8rgs8Y=
=9Ab9
-----END PGP SIGNATURE-----

--=-iEVKFmDjRYDciion4ghq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
