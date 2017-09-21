From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] ibacm: Close MAD port when umad_register fails
Date: Thu, 21 Sep 2017 16:18:41 +0300
Message-ID: <20170921131841.GU5788@mtr-leonro.local>
References: <20170920230442.2334-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rQAi4ZBraoACHIeu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170920230442.2334-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rQAi4ZBraoACHIeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 21, 2017 at 02:04:42AM +0300, Yuval Shaia wrote:
> Cleanup of the open port is needed when program fails to register MAD
> port.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  ibacm/src/acm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks, applied.

--rQAi4ZBraoACHIeu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnDvDEACgkQ5GN7iDZy
WKddUw//Qma0hXIGWXdKa2fCOgdX/xku+yquPU1CGTSpHqZfcY8+35fxJP0FgARP
dKtWA7PhEPWpP20OQ2qvqkFdhh3BxklzSBoeEKvf3dlsJtqj1wP7st6TDlXXU/qp
W5MBrvcXrbJ2p5Uyr5mmDAprKg1bnOyHXF5AF8DcU7RmCn0PYgpg/+j39McDqt7a
upzg1O5icaF732KRwoCWnzGVAD6Tox5GJ+nT7y3rwlqkQljh3qzNJbp/HuEdaw7v
hSkI396kCQnlqH3Y5Ag4BqeF2TDB7p2J9cdiP7/ZmEgkeaWQE0I7nKaLIYjnKquM
stVBd36DlJFeqToi7WI+Aquw5eO/7St225Aci9Aj/yj1bPhtndLcV3QgnCrnlLf2
gHUAlekq54B+5B8L6kS6qz82O8MFLbp4v8BxcLIOIjxPqcTyp0vniMGiDsTW/t79
M8ZjBPc1S5KFB+jHF/EbTsByAXlNFC88E4hwIT5giGORMX71nTLScDiZztosOpBH
iunkSEgfSzntKfIOwiQEL/MbCrn5o5faN33CBIgWr9sVmSL/yTLUQdoMLfgMi1Qx
EL+qrOZD3fhJwDXmS7iz43AAXwN4H8cp/gP+vV97WTaAD/PQ95qIqAq09/1m4mGe
XoqCcbOgPhkvLj7I525+vQvqwzP+QP2TecIOLvuRQ+hM93YlNEw=
=A+av
-----END PGP SIGNATURE-----

--rQAi4ZBraoACHIeu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
