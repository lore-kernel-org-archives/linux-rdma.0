From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] ibacm: Incorrect usage of BE byte order of MLID
 attach/detach_mcast()
Date: Mon, 16 Oct 2017 07:56:41 +0300
Message-ID: <20171016045641.GA2106@mtr-leonro.local>
References: <20171013184347.28410.87093.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YPOU9eFKIy6Wf5kE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171013184347.28410.87093.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YPOU9eFKIy6Wf5kE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 13, 2017 at 02:43:47PM -0400, Michael J. Ruhl wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The MLID value passed to ibv_attach/detach_mcast() must be in host
> byte order.
>
> acmp.c incorrectly uses the big endian format when doing a multicast
> attach/detach (join). Multicast packets are used to do name resolution
> by the libibacmp library.
>
> There are two possible results because of this issue.
>
> If a kernel has commit 00b8a3351b2b, the attach will fail with an
> EINVAL.  ibacm will log this as a failure during the multicast join.

Kernel doesn't have such commit.
https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/commit/?h=k.o/for-next&id=00b8a3351b2b

>
> If a kernel does not have commit 00b8a3351b2b, the attach will
> complete successfully.  Packets sent to this address will be dropped
> because the packet dlid value and the multicast address information
> given by the attach will not match.
>
> Update MLID usage to use the correct byte order.
>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  ibacm/prov/acmp/src/acmp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
> index aa78416..78d9a29 100644
> --- a/ibacm/prov/acmp/src/acmp.c
> +++ b/ibacm/prov/acmp/src/acmp.c
> @@ -732,7 +732,7 @@ static void acmp_process_join_resp(struct acm_sa_mad *sa_mad)
>  			acm_log(0, "ERROR - unable to create ah\n");
>  			goto out;
>  		}
> -		ret = ibv_attach_mcast(ep->qp, &mc_rec->mgid, mc_rec->mlid);
> +		ret = ibv_attach_mcast(ep->qp, &dest->mgid, dest->av.dlid);
>  		if (ret) {
>  			acm_log(0, "ERROR - unable to attach QP to multicast group\n");
>  			ibv_destroy_ah(dest->ah);
> @@ -1429,7 +1429,7 @@ static void acmp_ep_join(struct acmp_ep *ep)
>
>  	if (ep->mc_dest[0].state == ACMP_READY && ep->mc_dest[0].ah) {
>  		ibv_detach_mcast(ep->qp, &ep->mc_dest[0].mgid,
> -				 be16toh(ep->mc_dest[0].av.dlid));
> +				 ep->mc_dest[0].av.dlid);
>  		ibv_destroy_ah(ep->mc_dest[0].ah);
>  		ep->mc_dest[0].ah = NULL;
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--YPOU9eFKIy6Wf5kE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnkPAkACgkQ5GN7iDZy
WKfMFg//QTrXeUnwV/yF/ZyblElmn/+2OxCZSnnwht90elkHrCdlOFIfwQxfEnmX
nRYPBLu6aUKrjfCGnYg//V0zQiRcyfGmkPMCfYSqN5qFoODYDO0yYuYbf4YKH+LJ
EWGgqSzY8LyxASPkjUlECUzyN9IA0YKH1HMeS+leSGyR59VH+FlXY1gb2A3EQixL
72ZviowCj7nf8+5b9I8C+jZ/ELMuamCW2BArdSqkyeKA9IIwqhV03zyLmkZyLstc
IqOIqwsYBGemL/YWdaW9MWy0/Umwca8l8J4ivuN+KJjyKoEVRa5ABS1s6nW3RnTz
FC++mOyEkAKFVgiLSC+kzWV009gdBRz4V7OcMErLxdGxWz7SpB6J+bPJkL1WAonw
rchl2ObMKJ0Rd+T2fPOm0TX0YjDUoBPFIAIWQYvWZ/VTBfZmDy5CKUktiZW/mWFo
FDeAyRrFjcrsP4/QvB70oNAC/R9RajEEDiiswWG29ezwg9f2jCnhm028YCWZkn++
oSNgw4ca3zB4Fqx74uZ8oCItdOeDK1HGfpbDrp8JGjj2B8y5AaaUzmRCHwOG+cvD
+JXwel2YM30vOig0f5Rmpp6q6xcHo01qVwQEqtcDKlx1JfTBY3JQXd9lTWkIfOcC
OXkgSkKk+2KjFFZagvB+V83flTE9LoOPKS1F1SW0jkYq054FT2g=
=FVlz
-----END PGP SIGNATURE-----

--YPOU9eFKIy6Wf5kE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
