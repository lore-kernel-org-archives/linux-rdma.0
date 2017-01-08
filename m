From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/15] IB/rxe: Enable type checking on SKB_TO_PKT() and
 PKT_TO_SKB() arguments
Date: Sun, 8 Jan 2017 11:44:31 +0200
Message-ID: <20170108094431.GN15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353555.3592.24.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+mr2ctTDD1GjnQwB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353555.3592.24.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+mr2ctTDD1GjnQwB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:40:49AM +0000, Bart Van Assche wrote:
> Let the compiler check the type of the arguments passed to SKB_TO_PKT()
> and PKT_TO_SKB().
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/rxe/rxe_hdr.h | 12 ++++++++++--
> =A01 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_hdr.h b/drivers/infiniband/sw/=
rxe/rxe_hdr.h
> index d57b5e956ceb..6cb18406f5b8 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hdr.h
> +++ b/drivers/infiniband/sw/rxe/rxe_hdr.h
> @@ -53,8 +53,16 @@ struct rxe_pkt_info {
> =A0};
> =A0
> =A0/* Macros should be used only for received skb */
> -#define SKB_TO_PKT(skb) ((struct rxe_pkt_info *)(skb)->cb)
> -#define PKT_TO_SKB(pkt) container_of((void *)(pkt), struct sk_buff, cb)
> +static inline struct rxe_pkt_info *SKB_TO_PKT(struct sk_buff *skb)
> +{
> +	BUILD_BUG_ON(sizeof(struct rxe_pkt_info) > sizeof(skb->cb));

It is very good check, thanks for catching it.

> +	return (void *)skb->cb;
> +}
> +

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--+mr2ctTDD1GjnQwB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhyCf8ACgkQ5GN7iDZy
WKc0hA/9EFEwKzckmMCqxQnIKINYwxtk/1ookqtbSsWkSbW/iEjekcqk6CJW4VwB
pi28Wi4UUHkLsAo/qYIWxtipGY10OZGSH/P4CAA85Mf5l+l6soRn3QSU0qpNk6zp
/4a4pplbdA62unARmvB5DbNmjdrTRDK69vDZpX2rEcVqn4SxrA3y3ju8aZeGrOUV
UP+ztyx6aBBzv+QYqkVIWFmcAyqtg8hweLmLTjNMps7tUoexsl36EjkCyFBpcJ/O
uS6kO40ENiZWlZ2uWxejp/2EMqPDknyp7JOoWkDqAo6d8WoKixbtxb0GV7aeW0R0
nNSZW3b2v+x0Eu3trdqjrJgalcuIc84E5p1tQHjuM+O9H4cQhi6louDE1Q/ZiA8H
e+vTeyWcPal86dbNjnZ7WqngjLATGQ0cLH3oPPQvWxKgULJs+tTtkR7+lZJcQeoM
yv0o5/jzEtcIetA06wnprWT9L6uBKF8em614E4D8A8fSLISm4djfKqRLtEsMlQgF
LRrVv1OfvoT7jWPaXcUQCxel4GxbPPwkIT5KYdaLpmO5h27jCJSinUfI/XehQFEH
BqRArh1iRCZxJRxxA8yMjU9aBVP2MDYK2/NjyFE6uLLJDebVqaYI0azKw3EHAtvf
+YZt+Zlnfn6XH5a7eqomZei9U9gID2ROuQW7SWuLxpzL3xE6L64=
=0smt
-----END PGP SIGNATURE-----

--+mr2ctTDD1GjnQwB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
