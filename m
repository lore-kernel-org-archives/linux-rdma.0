From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/mlx5; Remove redundant allocation warning
 print
Date: Sun, 21 Jan 2018 15:41:49 +0200
Message-ID: <20180121134149.GH1393@mtr-leonro.local>
References: <20180118123424.21062-1-leon@kernel.org>
 <20180118200211.GA17561@yuvallap>
 <20180119105840.GA1393@mtr-leonro.local>
 <20180119185427.GB2624@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180119185427.GB2624@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 19, 2018 at 08:54:28PM +0200, Yuval Shaia wrote:
> > > >
> > > > Fixes: d69a24e03659 ("IB/mlx5: Move IB event processing onto a workqueue")
> > >
> > > Didn't found it in:
> > > https://kernel.googlesource.com/pub/scm/linux/kernel/git/leon/linux-rdma/
> > > branch rdma-next and didn't find it.
> > > Where should i look?
> >
> > In official place:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=d69a24e036596877ce08c25ab8e63a202412fd9e
>
> I see,
> I thought that "rdma-next" in subject stands for branch name, apparently
> not. So saying rdma-next you actually refer to for-next, right?

By writing "rdma-next", I mean "target", there is a need to distinguish between
different submissions (net/net-next/iproute2/iproute2-next/rdma-rc/rdma-next/rdma-core).

Thanks

>
> >
> > >
>

--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpkmJ0ACgkQ5GN7iDZy
WKem4g/9GqPs12IwCAQDuAdJyWTT+YOrDLe8EyPSmhpEEVLG5losFTcLoG7XQfAW
tcgHIfO4twluKMuIBusutGycKBlLQBjf6y4PLdqWzaYn0NPwUbs63ogEM9G0lx6B
f94DxkvPr60KBjBKrg59X36XX/LUz0Q6lbBwqBqAtXa7HZ/AMNq78+xTNBYOMoz8
h3zVw1PnGR4c8E9d4Wl/SOKvH62pHi6xUFj92I6p3Qkm+H3azZaWy2GGT1ZnMn+c
GG2ulCmde7o/GvorT5C3gFb1VuxSdz8fv6RWaWPJFQa8gqWn3V0EJHFdjLMgZD+4
egRLxjXYmIBuDsnb1yz2SRk4ezivUWWn6Ct9brY3gvM2imJfdq/Gqjw5ODFuZSo/
StGkmppqWjjbwtioGQUmRDGu63EXC6md3UJZZUvxMA3ds34sqilKd4V67Eh6sEQz
uR7LUJN939c0gT1LthiYydVE+oWNYA7TMJ6xq4fNobnYtyl2XMlCLjkBtOsMRmSO
vOPHiaTc70uBWar7+F4fyz6HTT3a3Odc5MIqxc+hVXO6XBCSHMjovuSC1Zv8tWiL
AKnfQ6EA2VpJibP4dUgzCeFiAVUYUjxoU5Vizzd3Iv/sbVvpzZeVHcztUu9MJCn8
FDBJ5kMivm5wpSEwk0e4wcad0c7Sd4PJot9Gj24ncHo4Z1PiwbY=
=r0yF
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
