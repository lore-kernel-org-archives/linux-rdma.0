From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Tue, 21 Nov 2017 08:37:26 +0200
Message-ID: <20171121063726.GQ18825@mtr-leonro.local>
References: <20171116204400.GA28216@mellanox.com>
 <20171120161016.GL18825@mtr-leonro.local>
 <20171120180631.GE626@mellanox.com>
 <20171121050456.GM18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N0gANzrc4gG6a8qX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121050456.GM18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--N0gANzrc4gG6a8qX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 07:04:56AM +0200, Leon Romanovsky wrote:
> On Mon, Nov 20, 2017 at 11:06:31AM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 20, 2017 at 06:10:16PM +0200, Leon Romanovsky wrote:
> > > On Thu, Nov 16, 2017 at 01:44:00PM -0700, Jason Gunthorpe wrote:
> > > > As was discussed in September and October, add Jason along with
> > > > Doug to have a team maintainership model for the RDMA subystem.
> > > >
> > > > Mellanox Technologies will be funding Jason's independent work on
> > > > the maintainership.
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >  .mailmap    | 2 ++
> > > >  MAINTAINERS | 1 +
> > > >  2 files changed, 3 insertions(+)
> > > >
> > >
> > > Doug and Jason,
> > >
> > > Can you forward the current fixes to Linus?
> > >
> > > I have more fixes from Parav and fix to iWARP from Daniel, but I prefer
> > > to have proper RDMA branches before I'm posting them.
> >
> > I belive Doug has already sent the pull request for this merge window,
> > and the new shared tree location is fully up to date, and there are
> > no accepted but unset patches at this time?
>
> I still see for-rc points to old (4.14) code.
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=k.o/for-rc
>
> There is a need to advance -rc to be equal to -next during merge window,
> so we will be able to actually base our -rc/-next patches.

And for-next misses one patch, which I sent directly to Linus
https://patchwork.kernel.org/patch/10032391/
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband/core/nldev.c?id=287683d027a3ff83feb6c7044430c79881664ecf
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=k.o/for-next

Thanks

--N0gANzrc4gG6a8qX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloTyaYACgkQ5GN7iDZy
WKf2Vw/9EbKj75kTc7XOSUlDDBLnKw+0BVZ9eETylcW3XyDgcPoAz+S/t80k1fJk
cDyZ8G3Oqt7vnVWtUohHtCe97AxaVQWbRykLMsBeSOY/m6l+uG8z1sSdXdBjBeWz
x0/PyRVHfAFAyMpcUBnpubFQlz5Jtr0diygZRdPoWygrFhE25konI8loTIwjt81A
tsXXrO1ir+3oVuU9e2VIdOhc0fxmFrlp+TisPQnnwVytE5UKS++67bdPh0CPUNq1
e2g/0qARts5uEuSNvjCYiGTSuSkIL98C5m9kz9AwWyEJRMkkB1I2LwKUvKOyvIpy
l+7vFw1KC1h7hixDXl/9eaL6FPLu7rZLlMFd7759rHddVCPWR/oUtUrbm2YkU8ot
ULL+hLIw/t5XlYfbPtZR5h48233hcKztCpZP8xxRyBIXQTyCSP/2+QHU1iK1b2/p
RWS4tFPLWBY6ymiwKoxrdF6iOXbTA8dC7RZX29yvJ8RdqlOf/PHbFP0f7KP7oCP1
luVE2J74z5Qm2A0tZtC7vmpsge/VaV2R/FTzyO9hIyvD5ouMzX7raBifu5xNGirx
TNzzf+Pn6Xgs4Myafvu9tQLj2Uyw8SkKt01Q61zmkT5OBIPbkIgw6bOpHKZrXJ4v
2v9W7Hun4Cwfu3yUsdBUJ8D44j1NxWVyCQzdWp15ZHAEYzNPcEY=
=CCvd
-----END PGP SIGNATURE-----

--N0gANzrc4gG6a8qX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
