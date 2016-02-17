From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 15/21] IB/srpt: Log private data associated with REJ
Date: Wed, 17 Feb 2016 10:57:08 -0500
Message-ID: <56C49854.6010204@redhat.com>
References: <56BCDAAD.7030906@sandisk.com> <56BCDC1C.107@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="38XEkNaio2G7LbvS54iW6uunC9jv0gww2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCDC1C.107-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--38XEkNaio2G7LbvS54iW6uunC9jv0gww2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 02:08 PM, Bart Van Assche wrote:
> To make it possible to determine why an initiator sent a REJ,
> log the private data associated with the received REJ packet.

This particular function is all sorts of broken...I fixed it up as I
took it in.  But, issues were:

1) We always allocate priv even when private_data_len is 0
2) Since we always allocate priv, the test for priv in the pr_info args
isn't really helpful, but the way the test is set up, if priv exists,
then we actually pass NULL, if it doesn't, we pass the static string.
3) In the event we have priv and private data, then there is a nit about
formatting because priv will end with a space right before the null
terminator, which makes the period in the pr_info format hang out in
open space.

My changes:

1) Only alloc priv if private_data_len is not 0
2) Change priv to be space prepended instead of space postpended
3) Change pr_info format to work with space prepended string
4) Fix test in pr_info args

> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband=
/ulp/srpt/ib_srpt.c
> index 10bc133..d9bac93 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2252,8 +2252,17 @@ static void srpt_cm_rej_recv(struct srpt_rdma_ch=
 *ch,
>  			     const u8 *private_data,
>  			     u8 private_data_len)
>  {
> -	pr_info("Received CM REJ for ch %s-%d; reason %d.\n",
> -		ch->sess_name, ch->qp->qp_num, reason);
> +	char *priv =3D kmalloc(private_data_len * 3 + 1, GFP_KERNEL);
> +	int i;
> +
> +	if (priv) {
> +		priv[0] =3D '\0';
> +		for (i =3D 0; i < private_data_len; i++)
> +			sprintf(priv + 3 * i, "%02x ", private_data[i]);
> +	}
> +	pr_info("Received CM REJ for ch %s-%d; reason %d; private data %s.\n"=
,
> +		ch->sess_name, ch->qp->qp_num, reason, priv ? : "(?)");
> +	kfree(priv);
>  	srpt_drain_channel(ch);
>  }
> =20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--38XEkNaio2G7LbvS54iW6uunC9jv0gww2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxJhUAAoJELgmozMOVy/dMWkP/1HuxegcqEYRv926n3gYI+rs
jwiu5WzM/OV2UlBk2myKRYSwv2wKEWqOUKsfzVbMfQH1bmYfvUfcvVWoW8A8a9y0
kqxWpyPc2dIMQSiZcGVZ4qXsOxmjlL/NRfqK/Q00QvUTA/Z+GSOQv2evBlhZrH/C
BsZZxDqw6y0T0218spCi/EkoYYWB+TyBgzuSwOGaa+HVhHDNdcrT+TjSZiQ/v0hk
Lah55WP3WCpY1l+lvG2ZPvlLQMXYUB1FfPhAFjSinOf5mcZUrKyDNIFUJNuDd3hE
fBsT6V9eO+P/ZUTTaS/fznbaQALaX0s5O2k+JIh+wXCNj1G+CQwc1hXJ9SfLBEzB
55CLu7i0ak8cmzKKHuq4V7xxGVVFbAyLZblagzBSzDdq3obzSCsLuHf5QXK+jL93
SCKK5GMTmTYverpl3Rz6dXWwrGPM9r5d5rRnoVvZUxYtLKwVVc3egc5YYkKp92Ef
2JYfYJv5CzF2wW6lbGuzXBJ3wjVTbCNdA1wtAdTdnVDp9ftvMZf8eQLhBW8+cjx7
VtBvUs0AgtFjQmM9pls4WM9s79uedj7zfXuQ9sfnvu/zEacAZHcFSWH2kRi3YJ0+
p02t+heKloY9SYwcdc2gbytxfdjX0sWEW4iyVm/h3K+L+8mlfHJVXokDBU20myFk
AcvS1agc+KtReasTS5gh
=xVyY
-----END PGP SIGNATURE-----

--38XEkNaio2G7LbvS54iW6uunC9jv0gww2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
