From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 0/7] Preparation to DevX extension series
Date: Tue, 25 Sep 2018 10:33:07 +0300
Message-ID: <20180925073307.GB3519@mtr-leonro.mtl.com>
References: <20180920183526.13995-1-leon@kernel.org>
 <20180922170207.GA13493@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oJFDFiWc3BlD0xT/"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180922170207.GA13493@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--oJFDFiWc3BlD0xT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 22, 2018 at 11:02:07AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 20, 2018 at 09:35:19PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog v0->v1:
> >  * Update commit messages
> >  * Split DevX series to small sub-series.
> >  * Change static initialization from {0} to be {}
> >
> >
> > Set uid as part of various IB commands so that the firmware can manage
> > the IB object in a secured way.
> >
> > The firmware should mark this IB object with the given uid so that it
> > can be used later on only by objects with the same uid.
> >
> > Upon DEVX flows that use this objec, the pointed object must have
> > the same uid as of the issuer uid command.
> >
> > When a command is issued with uid=0 it means that the issuer of the
> > command is trusted (i.e. kernel), in that case any pointed object
> > can be used regardless of its uid.
> >
> > Thanks
> >
> > Leon Romanovsky (1):
> >   net/mlx5: Update mlx5_ifc with DEVX UID bits
> >
> > Yishai Hadas (6):
> >   net/mlx5: Set uid as part of CQ commands
> >   net/mlx5: Set uid as part of QP commands
> >   net/mlx5: Set uid as part of RQ commands
> >   net/mlx5: Set uid as part of SQ commands
> >   net/mlx5: Set uid as part of SRQ commands
> >   net/mlx5: Set uid as part of DCT commands
>
> This and the next series look OK to me. Let me know when it is applied
> to the mlx branch

Applied after fixing Or's comments (typo and extra description in last patch).

bd37197554eb net/mlx5: Update mlx5_ifc with DEVX UID bits
774ea6eea290 net/mlx5: Set uid as part of DCT commands
a0d8c0543189 net/mlx5: Set uid as part of SRQ commands
430ae0d5a3ce net/mlx5: Set uid as part of SQ commands
d269b3afffcb net/mlx5: Set uid as part of RQ commands
4ac63ec72587 net/mlx5: Set uid as part of QP commands
9ba481e2eb3b net/mlx5: Set uid as part of CQ commands

Thanks

>
> Thanks,
> Jason

--oJFDFiWc3BlD0xT/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbqeSzAAoJEORje4g2clin1OIP/3ZbPa5xIAHdG8D0OwRoe/cU
y8HKc51imDsNXylQtdEHcSk7FdN3uU/pITlkMDBhBGalLJHLwGd+C9Ui85V8g+af
QoECX+d4GUt8vFvPu4yLwwxXe+kpXnPmg2KnE+aJjRLxdyRhIQ8aPCNfKI58nJ74
RbbUpLwbsqJ4f9r60TK01HwDM89It7XYbm8pgvt0Ncd6j9zbfT2Xk/nq6GW1CLXF
dIpJDRO6v7mgp4+owrAqpl5SQxelRc8hpMUdp+0PCoHsAio3FmMxHz3kdTcJBB3y
JY8Apn8XEhqAd898DwVMSsVhlBi1ldv+q8+j/LypBN2ZMcDsr5XySDWxPqGSvZS8
lchtGy53fUBeljWEQTwt4BXix96BidwlUDfSWcCGNj9ra2OSB5nGXzgAWEIHJrXM
UddMSj1/hr4Ueelwgiy2G31HZgGvzd84gpFtrUXg8QtpAJhoaD/5e6ajbiCxExcZ
pVAtlMpV+JAS12ZfgapWA+UhQLD9vxh+y5PQrd5Eq38RMITYV5eCKwVwQNgB5lFI
WEL9z83i2fFKqzesYd9W3GJOgonJ/qi7MV1KpknVbl7l7CGDloBLi3arXG9RamX7
ylroOL9dK3FGtym92MDLrB4PAT0LCNuR8NG39bcf7mt9Yu0lDlZ0tNoz3aQSy1oh
r8/vzPDLUZTLaDFUp3Fm
=ebRx
-----END PGP SIGNATURE-----

--oJFDFiWc3BlD0xT/--
