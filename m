From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/sa: Fix netlink local service GFP crash
Date: Thu, 21 Jan 2016 12:49:29 -0500
Message-ID: <56A11A29.8010203@redhat.com>
References: <1453383691-2306-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8qiHNdL7Umutrjn89iFmhp6HS1DSsNm6R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453383691-2306-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, chamaken-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8qiHNdL7Umutrjn89iFmhp6HS1DSsNm6R
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/21/2016 08:41 AM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The rdma netlink local service registers a handler to handle RESOLVE
> response and another handler to handle SET_TIMEOUT request. The first
> thing these handlers do is to call netlink_capable() to check the
> access right of the received skb to make sure that the sender has root
> access. Under normal conditions, such responses and requests will be
> directly forwarded to the handlers without going through the netlink_du=
mp
> pathway (see ibnl_rcv_msg() in drivers/infiniband/core/netlink.c).
> However, a user application could send a RESOLVE request (not response)=

> to the local service, which will fall into the netlink_dump pathway,
> where a new skb will be created without initializing the control block.=

> This new skb will be eventually forwarded to the local service RESOLVE
> response handler. Unfortunately, netlink_capable() will cause general
> protection fault if the skb's control block is not initialized. This
> patch will address the problem by checking the skb first.
>=20
> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/sa_query.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/co=
re/sa_query.c
> index 1f91b6e..f334090 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -717,7 +717,9 @@ static int ib_nl_handle_set_timeout(struct sk_buff =
*skb,
>  	struct nlattr *tb[LS_NLA_TYPE_MAX];
>  	int ret;
> =20
> -	if (!netlink_capable(skb, CAP_NET_ADMIN))
> +	if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
> +	    !(NETLINK_CB(skb).sk) ||
> +	    !netlink_capable(skb, CAP_NET_ADMIN))
>  		return -EPERM;
> =20
>  	ret =3D nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
> @@ -791,7 +793,9 @@ static int ib_nl_handle_resolve_resp(struct sk_buff=
 *skb,
>  	int found =3D 0;
>  	int ret;
> =20
> -	if (!netlink_capable(skb, CAP_NET_ADMIN))
> +	if ((nlh->nlmsg_flags & NLM_F_REQUEST) ||
> +	    !(NETLINK_CB(skb).sk) ||
> +	    !netlink_capable(skb, CAP_NET_ADMIN))
>  		return -EPERM;
> =20
>  	spin_lock_irqsave(&ib_nl_request_lock, flags);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8qiHNdL7Umutrjn89iFmhp6HS1DSsNm6R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWoRopAAoJELgmozMOVy/dpLUP/07ixlSB4HwvMmSJPSyqZQjq
a8qu20F3sG+SSD/xU93NVyA2BAdpcQl2aVv2PoeYjkMwL3SyMaT45i7ibi0Dxjmx
tN3M5nadUyFE/rdbCV4uhQOXrH88apZ7nBKv7pBt46laVQyyItgxQxRYpNLUDdIm
1kpuEKFG3h4idvgA72W9bcn66rP6SrdK66nzD0keEcMYdJsHtnkQyLgDRmAbtJIl
VbMFY/Jhktuv5ehPDZf0RdmAJNRANdnWzvhloy9ScknLJ7UN3LbA/hXpb9d+iZfB
cYkmZyM0Y5Y+jJMpcFVYSDnor5pESOjyceBGNgkCEOKok6rMA1x3m4zjrmg0sZPF
OVhl8GLcfR6ptn8LHUuygdCYv2lZ8X7g8phgf+vV9gz9RgXFk4A6Lm+hqLf3GjWW
6Du1rpXFgIdS2xCJ8U8eFGhRu69aZLP4j2RbwfWGBLMYm0YX79qluBqZMUzW2hE0
DuiDBBqeVlQWE2wBnPRPNk2fk2gLo5uMotqdDs8GCTZBmtvwvl+Z0Oi/zdA6byOU
eIH39WRbrpid+CnvRNqOfH77JG0qobPTH2MjXw2wzj3o6epDybR4wMsE8Xhn8RmU
0NDFHmmG9Hx4uljZf7wbljfRWIuym4DQJ37Zd1LFmtGLvvjjtsuxoE6V1/KZXAnW
pzFudXBXpECcc5hkVPl1
=1zSI
-----END PGP SIGNATURE-----

--8qiHNdL7Umutrjn89iFmhp6HS1DSsNm6R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
