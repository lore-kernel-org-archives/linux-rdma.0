From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/5] Fixes for IPoIB flows
Date: Thu, 15 Jun 2017 07:34:06 +0300
Message-ID: <20170615043406.GE17846@mtr-leonro.local>
References: <20170614065909.23650-1-leon@kernel.org>
 <1497468007.7171.258.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497468007.7171.258.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2017 at 03:20:07PM -0400, Doug Ledford wrote:
> On Wed, 2017-06-14 at 09:59 +0300, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > There are 5 small patches from Alex and Feras for IPoIB flows.
> >
> > Thanks
> >
> > Alex Vesker (4):
> > =A0 IB/ipoib: Fix memory leaks for child interfaces priv
> > =A0 IB/ipoib: Limit call to free rdma_netdev for capable devices
> > =A0 IB/ipoib: Delete napi in device uninit default
> > =A0 IB/ipoib: Fix access to un-initialized napi struct
> >
> > Feras Daoud (1):
> > =A0 IB/ipoib: Fix memory leak in create child syscall
> >
> > =A0drivers/infiniband/hw/mlx5/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A06=
 ++++--
> > =A0drivers/infiniband/ulp/ipoib/ipoib_ib.c=A0=A0=A0|=A0=A01 -
> > =A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++++++++--
> > =A0drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 11 +++++++----
> > =A04 files changed, 24 insertions(+), 9 deletions(-)
>
> Thanks, series applied. =A0We are close to done with -rc fixes I hope,
> yes?

Yes, we don't have anything what deserves such late rc.
Everything else will go to ->next.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllCDj4ACgkQ5GN7iDZy
WKf3oxAApNZrJeqhhqztmYL3mEoJB3BOtSKSfDJ5gFVuwVkEmnBWa98Ky88qitsl
NNHocc8DuVngxLCIA/n2FGqBhY9r2FK9EPXD/gSg3tJQ6VKA9vuaAXnBQ1TJE/ZR
HFL3UtrOcRya2L14ojvgrHf6PiJQy1vbPK/nCdfbc1JFQZWWT1SLsY4nhX+7hYMU
TYLZ1RzhdoEG/AldEkYI6spfMf+JuS5CDff4MVAtKu8+aBGkn6JqAkiF6fNhJBqT
pj2WxBEgJsNqRZEOALeGrwcGIbftVOMr117JMrs/pUC6CV0R/f3cMl2ZRKRn7VhC
aaq2KZepoYMSs6VUvCqcJbigaBvn4xQGgoFQHIZewBmVAhOzAhAN8f51dgqZlHUG
rDwSvD9uyX+CV28Y+AF6LwXjaVckyB9J/Rjva7b/X1qp00u37mor5/stDxDTQu3V
dlRh3AUv+fGhgnaEa52olUbM8U2dlV0pVJS7wrLCt8w1p4By292C9IXjmKE9TlUi
cDZrksgXvOLrj0njVxtPkoD3tpcMnWGctJ4qg1iQQmvdwFhDoWJ/IYOpcLMj3t9R
QgGaxM490rM8U18IgZa7K81oA0uwoUrseCLwEQynOm9RmBYuNuwMZFRKn796QyIW
QMALATgDCm7aJsFKIvzePIX1oinTdzU817aGK73pFElGZMREeOg=
=rkSv
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
