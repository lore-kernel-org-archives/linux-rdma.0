From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/9] Support mlx5 flow steering with RAW data
Date: Wed, 11 Jul 2018 08:43:15 +0300
Message-ID: <20180711054315.GL3014@mtr-leonro.mtl.com>
References: <20180708102445.25496-1-leon@kernel.org>
 <20180710182854.GA24311@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K5rlT6r/WqkiQKGB"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710182854.GA24311@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--K5rlT6r/WqkiQKGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2018 at 12:28:54PM -0600, Jason Gunthorpe wrote:
> On Sun, Jul 08, 2018 at 01:24:36PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > >From Yishai:
> >
> > This series introduces vendor create and destroy flow methods on the
> > uverbs flow object by using the KABI infra-structure.
> >
> > It's done in a way that enables the driver to get its specific device
> > attributes in a raw data to match its underlay specification while still
> > using the generic ib_flow object for cleanup and code sharing.
> >
> > In addition, a specific mlx5 matcher object and its create/destroy
> > methods were introduced. This object matches the underlay flow steering
> > mask specification and is used as part of mlx5 create flow input data.
> >
> > This series supports IB_QP/TIR as its flow steering destination as
> > applicable today via the ib_create_flow API, however, it adds also an
> > option to work with DEVX object which its destination can be both TIR
> > and flow table.
> >
> > Few changes were done in the mlx5 core layer to support forward
> > compatible for the device specification raw data and to support flow
> > table when the DEVX destination is used.
> >
> > As part of this series the default IB destroy handler
> > (i.e. uverbs_destroy_def_handler()) was exposed from IB core to be
> > used by the drivers and existing code was refactored to use it.
> >
> > Thanks
>
> >   IB: Enable uverbs_destroy_def_handler to be used by drivers
>
> I applied this one
>
> > Yishai Hadas (9):
> >   net/mlx5: Add forward compatible support for the FTE match data
> >   net/mlx5: Add support for flow table destination number
> >   IB/mlx5: Introduce flow steering matcher object
> >   IB: Consider ib_flow creation by the KABI infrastructure
> >   IB/mlx5: Introduce vendor create and destroy flow methods
> >   IB/mlx5: Support adding flow steering rule by raw data
> >   IB/mlx5: Add support for a flow table destination
> >   IB/mlx5: Expose vendor flow trees
>
> The rest will need to be resent after the comments are addressed.

Jason, Saeed

Thanks for the comments, we will fix and resubmit.

>
> Thanks,
> Jason

--K5rlT6r/WqkiQKGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbRZjzAAoJEORje4g2clindGYP/iukEV+crr7hVVSAs9FC5RhS
IDlGpgwgtxr0MlxBnfdfBCUqcx0Rs1bGyZkXBerIHCWjs8yBB70oIPYMiuqMJNKh
TVqHOHSMl7QaUMFEoUqSJ6eC4gPkTsp+FyeJV6jkzb/B9lJbtDVyLnHaxbz/n/wD
tNESGg/3r53FHHc8gJjSomyK2fv8v/jZKVnqyKb6w9e4JFwHRZrh1nmkgIAM1aT3
yJl1kLwjRjsAu7lV2WgidTwOJKXHsOXblhJJexSKqsxstEmlGQdFR9MWppT/pbKl
JwraOhiFmAxNbNhyZAxUqX46uCpfwQVfXgInnUG/Wye05pCN/l7FewsyHCsCgRYd
UrJbCs2VeD42+Z1WbVXO2qEVPJtUz5869GblZ/w4HTE1xk9aF1jfI7uUTA3eyCHB
rGtk20PHzUsknJbxTcBGqdLahrZ5ak5D0F0zUGH0aK7MYrVkuci8R+F/jQ0T4i09
rYe580XCo3GmdJvhC0Rf/10LiqgOqJy3flnsVKzM9z18WWATT27WfgyBHYi449O3
Fu2v55ZhDgDiVlB7eVTWaRQiBwreO0I1C2kbKxl5dIES2czED3AumJLdy3XvxzXm
VM7US4a2k9JexKyJwJ+H+z5GA/npZmSABNB45dLRiDxl8zhDJrWmef/ylpVE9n6o
KoU8AO7DUYstBIUmxnc8
=xO5l
-----END PGP SIGNATURE-----

--K5rlT6r/WqkiQKGB--
