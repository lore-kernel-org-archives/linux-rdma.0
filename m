From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] svcrdma: handle rdma read with a non-zero initial
 page offset
Date: Tue, 6 Oct 2015 13:44:25 -0400
Message-ID: <56140879.3040000@redhat.com>
References: <20150928214605.17900.50257.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F9dRqMqJ9VqbcJ1aUoQmaRKR8sIFwcUPr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928214605.17900.50257.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F9dRqMqJ9VqbcJ1aUoQmaRKR8sIFwcUPr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 05:46 PM, Steve Wise wrote:
> The server rdma_read_chunk_lcl() and rdma_read_chunk_frmr() functions
> were not taking into account the initial page_offset when determining
> the rdma read length.  This resulted in a read who's starting address
> and length exceeded the base/bounds of the frmr.
>=20
> Most work loads don't tickle this bug apparently, but one test hit it
> every time: building the linux kernel on a 16 core node with 'make -j
> 16 O=3D/mnt/0' where /mnt/0 is a ramdisk mounted via NFSRDMA.
>=20
> This bug seems to only be tripped with devices having small fastreg pag=
e
> list depths.  I didn't see it with mlx4, for instance.

Bruce, what's you're take on this?  Do you want to push this through or
would you care if I push it through my tree?

> Fixes: 0bf4828983df ('svcrdma: refactor marshalling logic')
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>=20
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtr=
dma/svc_rdma_recvfrom.c
> index cb51742..5f6ca47 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -136,7 +136,8 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>  	ctxt->direction =3D DMA_FROM_DEVICE;
>  	ctxt->read_hdr =3D head;
>  	pages_needed =3D min_t(int, pages_needed, xprt->sc_max_sge_rd);
> -	read =3D min_t(int, pages_needed << PAGE_SHIFT, rs_length);
> +	read =3D min_t(int, (pages_needed << PAGE_SHIFT) - *page_offset,
> +		     rs_length);
> =20
>  	for (pno =3D 0; pno < pages_needed; pno++) {
>  		int len =3D min_t(int, rs_length, PAGE_SIZE - pg_off);
> @@ -235,7 +236,8 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,=

>  	ctxt->direction =3D DMA_FROM_DEVICE;
>  	ctxt->frmr =3D frmr;
>  	pages_needed =3D min_t(int, pages_needed, xprt->sc_frmr_pg_list_len);=

> -	read =3D min_t(int, pages_needed << PAGE_SHIFT, rs_length);
> +	read =3D min_t(int, (pages_needed << PAGE_SHIFT) - *page_offset,
> +		     rs_length);
> =20
>  	frmr->kva =3D page_address(rqstp->rq_arg.pages[pg_no]);
>  	frmr->direction =3D DMA_FROM_DEVICE;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--F9dRqMqJ9VqbcJ1aUoQmaRKR8sIFwcUPr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFAh5AAoJELgmozMOVy/dTIQP/i/k7T6DTJFKNX3bKRKTAhOQ
zEeY/7zWs+YjFIdfWTL0rUbA4DBHu+lV8E/Px0OvUQisf03djE3Z3XWvVYB4JH6C
c8VecgHyxhHkgkylVMaQ1zOtn2Efa/L6isXcjbCOONAIVbbNVC8j9EdHKZPgLd8r
vI44YO1cx3/fdahmz/g1Q1cVqzxnzmzEFljEImhFhNGHx1fwaNqVviD2uV6tUw/O
ub30ycXMnWXhlUdu+LgSGS8Tkj2VRaX4k3q0g2CivOWOQVsCXqY+LpjaqrW153Bj
fuL6VssM4av1BvcIEJTD8sCUcqsnIzMZdUcWEYCgD2Dh9/SegMzqqPHV+oNOu21e
yPb4+hk36k+w6XAAvyjRz9YHzU/HCflvX6NGApt5LiZo6/golCJAuhxyZRXK1EIs
gBzH9mcHvEG/e0gOfwA7lMc645Z/H7FZr0zhtXLF8L7RYFRTU+vN7FZX+E2lgdTe
wxRuK7nnxelwkoqVmfCbhsXjxXvWqzj7aH16KECryL6aXG6F5qA7mGWNbgsTW4ct
Kyh6DOKCfAWA9QGRudzgikp5E0MwFzTOufyzgDkSqGkrazzQVpN6WLygvl3YsrKv
JJnQH69EEnZLNNv6ZQQzdMcLYhXpQ7piU9r7r+Q5IP6LID+9lKX3z+Uk3qcrByEE
HpRCmpVzxmX2YfCIgf09
=jEco
-----END PGP SIGNATURE-----

--F9dRqMqJ9VqbcJ1aUoQmaRKR8sIFwcUPr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
