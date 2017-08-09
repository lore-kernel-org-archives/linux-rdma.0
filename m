From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 08/33] RDMA/netlink: Simplify the put_msg and
 put_attr
Date: Wed, 9 Aug 2017 13:00:21 -0400
Message-ID: <03e0ce22-ad9d-eb7d-be75-b87bc9aa1005@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aET3tDHqAvxUvDidO1aaBcHhQqntO0cN6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aET3tDHqAvxUvDidO1aaBcHhQqntO0cN6
Content-Type: multipart/mixed; boundary="1e0euEtcF9licou6Wqp04N6Mr5E4kOvGf";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <03e0ce22-ad9d-eb7d-be75-b87bc9aa1005-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 08/33] RDMA/netlink: Simplify the put_msg and
 put_attr
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170809160405.25142-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--1e0euEtcF9licou6Wqp04N6Mr5E4kOvGf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Reuse standard macros to cancel the netlink message
> in case of error.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c | 31 +++++++++----------------------=

>  1 file changed, 9 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/cor=
e/netlink.c
> index c5ee62a24960..fc8b45d4140a 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -126,36 +126,23 @@ EXPORT_SYMBOL(rdma_nl_unregister);
>  void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq=
,
>  		   int len, int client, int op, int flags)
>  {
> -	unsigned char *prev_tail;
> -
> -	prev_tail =3D skb_tail_pointer(skb);
> -	*nlh =3D nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op),
> -			 len, flags);
> -	if (!*nlh)
> -		goto out_nlmsg_trim;
> -	(*nlh)->nlmsg_len =3D skb_tail_pointer(skb) - prev_tail;
> +	*nlh =3D nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op), len, fl=
ags);
> +	if (!*nlh) {
> +		nlmsg_cancel(skb, *nlh);
                                  ^^^^ This looks funny.  It's
technically correct, but it looks like an error because you are using a
value that we just checked for an error, saw an error, and then use it
anwyay.  I would prefer that be NULL instead just like you write return
NULL just below.

> +		return NULL;
> +	}
>  	return nlmsg_data(*nlh);
> -
> -out_nlmsg_trim:
> -	nlmsg_trim(skb, prev_tail);

In the new code, on error, you cancel the message outright, while the
old code here does a nlmsg_trim().  Isn't this a functional change in
addition to just switching to using the standard helpers?  Same question
for below...

> -	return NULL;
>  }
>  EXPORT_SYMBOL(ibnl_put_msg);
> =20
>  int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		  int len, void *data, int type)
>  {
> -	unsigned char *prev_tail;
> -
> -	prev_tail =3D skb_tail_pointer(skb);
> -	if (nla_put(skb, type, len, data))
> -		goto nla_put_failure;
> -	nlh->nlmsg_len +=3D skb_tail_pointer(skb) - prev_tail;
> +	if (nla_put(skb, type, len, data)) {
> +		nlmsg_cancel(skb, nlh);
> +		return -EMSGSIZE;
> +	}
>  	return 0;
> -
> -nla_put_failure:
> -	nlmsg_trim(skb, prev_tail - nlh->nlmsg_len);
> -	return -EMSGSIZE;
>  }
>  EXPORT_SYMBOL(ibnl_put_attr);
> =20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--1e0euEtcF9licou6Wqp04N6Mr5E4kOvGf--

--aET3tDHqAvxUvDidO1aaBcHhQqntO0cN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZiz+lAAoJELgmozMOVy/dcrcP/iTCrUvSjGXyV5hpP2CY2e3/
BQtdXFmKchkaYqfh/54piQleuHBrYVfhVL16ytV7zi8t4ajCUhJrnFI5yatPN+E2
8kLMCnW0Fmi27uti8QRGsjO96dKGNe1d52Sy+ve4iffs+8hP2jobkEDgHhq1NogY
qOAXPVStMwMgH7lK9/8gE1ZoJA1GZ6FBoBCi/SLkebGb48iOiJ6egzLbRVi/ABQ5
YQSsXsjGpFvfPPDzxMlQFHbgMty2KpS3k5iln1GMydd9+Fij8dJ1saZIMQeO//0M
SjPYR+db47Prus5NedbM9UK5pGiiZYTdWfdFQEo45g9DKk8Ga1CavuQUFmQVaiUe
yaR2zckvpSjqm9iZw1HTQFZpKJ11xLmX7cvHDkS1l5My5oks05Za5ehjy9pwBSVi
iUMInVcTiSLZkUT1jfXWX4zXqTGHYE3Kxh3RWJy+Ic3dB9YZZgSOavEVwlIHO1q7
AW2A6zedUrlWPx9GYIhq8wbF7hGJVl3R39oJZ0QNfxkn4e6VbItVR7wi1VNMKmHK
tf9vf/eGXeezpMqHb81arxJO8UjzQ/piimg92ymBNSWde1tn9DJoqyZKcytw4LAJ
N+b2aw+3etYddqugcsNcurVGJKW2NfA1rwvKNQuoufC2/QJMlL0p+zttsl+xrOMI
Takp7J4yMf7IZNwgrfx3
=c0uC
-----END PGP SIGNATURE-----

--aET3tDHqAvxUvDidO1aaBcHhQqntO0cN6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
