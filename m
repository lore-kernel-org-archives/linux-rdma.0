From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Add flow control to the portmapper
Date: Sat, 16 Jul 2016 09:37:12 +0300
Message-ID: <20160716063712.GC10556@leon.nu>
References: <1468601997-63396-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468601997-63396-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 15, 2016 at 11:59:57AM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Add flow control to port-mapper by changing ibnl unicast
> to use netlink messaging with blocking.

Please add justification why you need it, what the problem you are
solving and why it deserves adding new inline function to
include/net/netlink.h file.

>=20
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c |  4 ++--
>  include/net/netlink.h             | 17 +++++++++++++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/=
netlink.c
> index 9b8c20c..6b09580 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -229,7 +229,7 @@ static void ibnl_rcv(struct sk_buff *skb)
>  int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			__u32 pid)
>  {
> -	return nlmsg_unicast(nls, skb, pid);
> +	return nlmsg_unicast_block(nls, skb, pid);
>  }
>  EXPORT_SYMBOL(ibnl_unicast);
> =20
> @@ -251,7 +251,7 @@ int __init ibnl_init(void)
>  		pr_warn("Failed to create netlink socket\n");
>  		return -ENOMEM;
>  	}
> -
> +	nls->sk_sndtimeo =3D 10 * HZ;
>  	return 0;
>  }
> =20
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 254a0fc..5434279 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -598,6 +598,23 @@ static inline int nlmsg_unicast(struct sock *sk, str=
uct sk_buff *skb, u32 portid
>  }
> =20
>  /**
> + * nlmsg_unicast_block - unicast a netlink message with blocking
> + * @sk: netlink socket to spread message to
> + * @skb: netlink message as socket buffer
> + * @portid: netlink portid of the destination socket
> + */
> +static inline int nlmsg_unicast_block(struct sock *sk, struct sk_buff *s=
kb, u32 portid)
> +{
> +	int err;
> +
> +	err =3D netlink_unicast(sk, skb, portid, 0);
> +	if (err > 0)
> +		err =3D 0;
> +
> +	return err;
> +}
> +
> +/**
>   * nlmsg_for_each_msg - iterate over a stream of messages
>   * @pos: loop counter, set to current message
>   * @head: head of message stream
> --=20
> 2.8.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXidYYAAoJEORje4g2clinfhsP/iXTTBz9tHPpIA4+mykMcMXT
jRkpcb575XIZrLUiCZHGAZuI+D8oYRtYFE9PgRd/PgkNuPOmNrFLJPsXl1ROOFgE
0yo5cgC1WVYLvo4fckePozNFVjUXoiwlM7fuzDNYJEbaiKj8jX1zyt6ayNsdUR0s
CFL6piK4LSTAeVP+U7DnioSMc9NPJURT5HzRE85Zg9IiH/+8oTfQIKVqLv7RLOk9
ek5kA2dPTNcZ6k2SWydIQjmQPgM1O9s5tzt8vUjMwCssWLyVEMfOVQaE2e70eyBV
ooDISF4EiL+BjLjLF56ORDcFJ4NlBmfb8/ScT7KNrr8daI7j6KALfTsOFvKA1u9C
zj/2d7pDy3uGP//tGSX7/OvVEb3BZzkIuEHGGQpra3l0IXaMMR1p6iDRmk3gu9b9
u0Ma7NqCzd7Yf6Vn/Yr2y3iqVTNOT8kFCtE84mJIj7/JP5M70VWmL4eN1WmEvOHZ
KL16EXHTa6hpbFnJStamCdrDK4KmbyxVQU/lN075DCpeXlkj8/TQO7jDjzboPfA+
uPOTb1bYgCg3A70FMIGcKwmnGtWL7noKy5ykP2MmVLDle1VHvNjRjUK6In9i8/oi
QwpwUQN2xdquK6b/3r9dwDgTZS0pd6Xi+TRGt5FbyhOMdLgYGZfCQKl44v7jVA20
/Sn87VQWn4Tc0+w93cJ8
=GjH9
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
