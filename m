From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Do not set skb truesize since using one
 linearskb
Date: Thu, 4 Feb 2016 07:16:37 -0500
Message-ID: <56B34125.6000109@redhat.com>
References: <1454532937-22649-1-git-send-email-clsoto@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SbGR3Hi0iq7j7LpgEm7KTXgfC7RrKFmh0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454532937-22649-1-git-send-email-clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SbGR3Hi0iq7j7LpgEm7KTXgfC7RrKFmh0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/03/2016 03:55 PM, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org wrote:
> From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>=20
> We are seeing this warning: at net/core/skbuff.c:4174
> and before commit a44878d10063 ("IB/ipoib: Use one linear skb in RX flo=
w")
> skb truesize was not being set when ipoib was using just one skb.=20
> Removing this line avoids the warning when running tcp tests like iperf=
=2E=20
>=20
> Fixes: a44878d10063 ("IB/ipoib: Use one linear skb in RX flow")
> Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>=20
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_ib.c
> index 5ea0c14..fa9c42f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -245,8 +245,6 @@ static void ipoib_ib_handle_rx_wc(struct net_device=
 *dev, struct ib_wc *wc)
>  	skb_reset_mac_header(skb);
>  	skb_pull(skb, IPOIB_ENCAP_LEN);
> =20
> -	skb->truesize =3D SKB_TRUESIZE(skb->len);
> -
>  	++dev->stats.rx_packets;
>  	dev->stats.rx_bytes +=3D skb->len;
> =20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SbGR3Hi0iq7j7LpgEm7KTXgfC7RrKFmh0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWs0ElAAoJELgmozMOVy/djLAQAKpPqgzbZDdcSFj4k7Y35nn6
wxSxDF95J/jHFuaHUd4bmSk5BeLi/rPtQxEsXBIyRbh67mlMjGkEKGE5uI/uGCwh
0CKqKKpMaOsP8pbZ4AN8qah3WE1uO+sHHQyEFN1GaBk4N6hQrtYAscftMC3KzEL/
Xt0PSb1saTpKd/C4pRS1/yYuHJgLWEz1ErTl0eTOSP5BxXMU2U1bkHTkA+vvWhDM
04bMsKeF0Yl7xOHD4I4VX3hTVixqDY/vfSqc9s7cPGDm+HqZxOew0MioJl57LQFW
vwGq+7YXcsMa8fNwAkPX1Tkgt6ZUoUtaTM+dWn5PTQMBSGwljlWw864Il8iQ9Vgz
rx4mHyxxi+QrXiQS5mnPc+CFGhB0VArSLj37DVyxyi1I6GANUdzoHncK7Ddgr0d5
QMCJUFd3ctjDIMbNJZpsgPIpT8ETU7ci76ybrl2x/XyXYwTeKUop06PPdYwmRnwu
vsovRwzHS0927CEV5jGZFU7gt/gIed57+iUk38E/VqR8Xkv3CzhTd83MZaVfOgbd
wvKx6PMrIdI8mM2iA+bB3eYJltZN+6t8nGjsbdTDrNPgQiqewslWNn096/nWv+zA
VfI/Iyye/crgog7fgCcgTIJlcOEaxbJoe7s2sLxGjwzbYxfJj28Wvomoew4dzMLe
IDKqrxBAIM3uLZuxBFjm
=i7g5
-----END PGP SIGNATURE-----

--SbGR3Hi0iq7j7LpgEm7KTXgfC7RrKFmh0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
