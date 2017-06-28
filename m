From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/4] RDMA/netink: Export lids and sm_lids
Date: Wed, 28 Jun 2017 19:16:16 +0300
Message-ID: <20170628161616.GK1248@mtr-leonro.local>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-4-leon@kernel.org>
 <20170628160513.GC14375@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q+W+CH9ft+eKPnpy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628160513.GC14375-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Q+W+CH9ft+eKPnpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:05:13AM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 28, 2017 at 04:34:44PM +0300, Leon Romanovsky wrote:
> > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_LID, attr.lid))
> > +		return -EMSGSIZE;
> > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_SM_LID, attr.sm_lid))
> > +		return -EMSGSIZE;
>
> Is this careful to only stuff attributes if they actuall exists? Eg
> these should not be present for iwarp/roce/etc
>
> Same comment for all attributes. Only present if they are valid.

It will be zero if it is not exist, but you are right it is better to
avoid to fill unneeded fields.

>
> Jason

--Q+W+CH9ft+eKPnpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllT1lAACgkQ5GN7iDZy
WKfOVQ/+PDQWdaRmjzjxFRsxghRaTxY3EFxqTaPzG02fcb0kZRjK9kew2cU6DdVO
QRvhxVgrK6ECTWzR9KHNZOA55uVntmlbd4XCiriERH4dU5paCBiKkJxIGkQa39+6
JjpnkJGkcg31DlhHK15oZO0m2LMCclhE2OAviVygm2YYKgYoSKUbVqzfAG/DpcDG
XAfhmslfNfzzCSUoyOs6cb+n9TzVwV7UXvZiMoccwz6Of9bz7RPangGql/2+8Vac
IVLmRE5BARYUi9icfpP6Ab13szbz0lpkYJi1zSujtjXiAlSsTpGItNFZeZmaDoUq
yqa+hoxDzCb0MmDc47KER5h28WtC1MRhc7UvHrw4UgQqGpK3RruFvUZGryvl6gVa
LEQ2uliLoMZDFLAeCcikcx74qgF9VXMMKYyC7OiVMh8+RvIZRStnzDoejrWUcglW
PUG/LppFsrywKqLJPWYG+9865Rt3fou3u0C/JBWjyTF3diJCK7eIufG+urfOPaxF
+ntVAvqQQmCpHm6ws77d9F597zkXbeB3ZbnIOwQY2ceTA9JjsuxwVl4lfEob4XR9
bG3PLNB3fbraI/KWopgQbcEoEV0kUfMkYG5UqKoH699/frnupj1m5vAi5Sbog9Ca
FLPR+kjrOxtdd+8Z40KJgPLDLuGW5ka1U6AhqvuFoszrjp0648I=
=Iyj4
-----END PGP SIGNATURE-----

--Q+W+CH9ft+eKPnpy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
