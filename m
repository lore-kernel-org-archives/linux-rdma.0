From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Wed, 20 Dec 2017 22:01:15 +0200
Message-ID: <20171220200115.GC2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
 <20171220163655.GW2942@mtr-leonro.local>
 <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
 <20171220171146.GX2942@mtr-leonro.local>
 <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
 <20171220180549.GY2942@mtr-leonro.local>
 <020801d379c4$eaaa0c00$bffe2400$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zu8lIfFVzXMVnfzp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <020801d379c4$eaaa0c00$bffe2400$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--zu8lIfFVzXMVnfzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 01:01:18PM -0600, Steve Wise wrote:
> >
> > Check filters options too, to filters by numbers and display columns.
>
> [root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link cxgb4_0/-
> display lqpn,type,state,pid lqpn 1000-1030
> DEV/PORT  LQPN       TYPE  STATE  PID
> cxgb4_0/- 1027       RC    RTS    0
> [root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link cxgb4_0/-
> display lqpn,type,state,pid lqpn 1000-1033
> DEV/PORT  LQPN       TYPE  STATE  PID
> cxgb4_0/- 1027       RC    RTS    0
> cxgb4_0/- 1033       RC    RTS    0
> [root@stevo1 ~]#
>
> Working!

Thanks,
It supports various combinations with "," and "-", like
990,1000-1030,1031-1032,1033

>
>
>

--zu8lIfFVzXMVnfzp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6wYsACgkQ5GN7iDZy
WKeBvxAAi613kk5+pGheKs7XzxgzwTIo/BWyQyg4VmDv5NRJiI4l+TPqerINTQjA
6t11X9S81S1L5YDU4hD+xdZIA/BSN4tncBcnjvXBl/DmA9ayb2JsQManA2OOKrDV
BYxUEeJtLkoOt5HrjVXaKR0cawe/h2XGmpAszP12VfKZ9D5skEGsnrZNwir8G7MM
v+osNBhaAKZshvSycDHnnu3n2litXcQbw6EyhKPaqXM0vfPnxjqGJEh1BITxBRoZ
zgOmLiEWUACUWRer2lBi7xT6f4CXlj5HLgM+lJVE+exD699ifmsif6cub79ejzvO
FkQU3arI3LOJ863O1g5vSv9wQ8ifqTw89/uvlEnamUllXGdilJGADZDb33gmuiWH
yQoBoM+iGt6kYndfOHukHXhbwp31uY/WpWBDFJXxWiETVA3ZNLtr8Mt5XwGS6+I3
yWifdHZwfMfJCYKs7bH9CDc5oWXyfgScjXxHRWEQqyb/JIj33bnezvwSgSVxeW5V
9JEseD9jp+QGyK15/JNJL7phu2xIWWq96Y7igz7ex0X4q/9iRgqUaC2nue7uXrcx
2VLpT7IFjMbxIGBCByHHn93q4HEKZ8g51RBm2WEyXoMsfRLe4UmaFHt3uigIjAHq
WWH9Ol1hxCx5XgMuC6Rem9hZqTyWGQDwd84GSRasRPnVpwWYekk=
=uS4/
-----END PGP SIGNATURE-----

--zu8lIfFVzXMVnfzp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
