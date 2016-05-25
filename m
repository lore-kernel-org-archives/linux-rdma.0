From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/10] IB/rdamvt: Fix rdmavt s_ack_queue sizing
Date: Wed, 25 May 2016 21:29:28 +0300
Message-ID: <20160525182928.GP25500@leon.nu>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
 <20160524195039.19706.66866.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160524195039.19706.66866.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 12:50:40PM -0700, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> rdmavt allows the driver to specify the size of the ack queue, but
> only uses it for the modify QP limit testing for setting the atomic
> limit value.
>=20
> The driver dependent size is now used to size the s_ack_queue ring
> dynamicially.
>=20
> Since the driver knows its size, the driver will use its define
> for any ring size dependent code.
>=20
> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |   22 ++++++++++++++++++++--
>  include/rdma/rdma_vt.h            |    9 +++++++++
>  include/rdma/rdmavt_qp.h          |    5 +----
>  3 files changed, 30 insertions(+), 6 deletions(-)
>=20

=2E..

>  /*
> + * Return the max atomic suitable for determining
> + * the size of the ack ring buffer in a QP.
> + */
> +static inline unsigned int rvt_max_atomic(struct rvt_dev_info *rdi)
> +{

In previous patch, you changed max_rdma_atomic to be u8 instead of int,
so why are you returning unsigned int and not u8?

> +	return rdi->dparms.max_rdma_atomic + 1;
> +}
> +

--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRe8IAAoJEORje4g2clinU3UP/2w8+HEbcEKMQRltfVd9zuSm
gBG3xVJr94jEhw1tg6sCrtQnPkwIDOk/redOXv24fAkac3+t/4gOLXYRPrw2pnPg
jIKZR/ri+0yaivvIqDEONNwROVRGm9Ercp1xcBBEbg+SVqlK7yc3gyaAMu9XJp1Y
8y8wp1hkj8E9KI5eEUcOjW3Vb3/4HQ7kVNd2ri4IHqcsUfoNMqqGa7MkohvasPI5
emiMQHeS02I0eG64Hfb/KgRgTnJ6DFEFGkwUTcEZzskOKvOjs/YdM30e/TFbeJ+l
kSFUAhGC6vLynRb96IuEg1+eoefSu6fkmyyDZ0ooVJGOkzpInaMsn0DtGhKerhXa
k1C1TDFC1IifGr5IAaEsX6lo6kv/SzNl40fcSP92s2iZz41KObG63z8BcK3M3yCR
I+1/5h8uFqjGJpGG5wKU+L7AnyqytvjZTxzozWVjzLgom2L137l6KtwD6DABfNCs
lqg7f3NbOeyzykCQsStuVUIAotvPsAVHH4SaQazURVp7+J0xw6V7QJ0A/bSJAJbQ
Hvo7HumYpdWY5O7dOuHqw7/JXOFdkLJ65/f3HYHS5Y1XCI/u0l4s7o+n0UG1Mb3A
P7OCzQuix4kG6B3eXqDApiULXpNQFi8cc9pOB1w9JQKG3YyqezPldHu1oBvmoeEX
sff7HoocHXTO1MHt6mzY
=918U
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
