From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Thu, 19 Jan 2017 11:36:48 +0200
Message-ID: <20170119093648.GR32481@mtr-leonro.local>
References: <20170119054102.20135-1-leon@kernel.org>
 <20170119054102.20135-6-leon@kernel.org>
 <HE1PR0502MB3004E6D28AED46720C428576D17E0@HE1PR0502MB3004.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i+iWqY68NNxfGGlH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR0502MB3004E6D28AED46720C428576D17E0-692Kmc8YnlL9PhveBwpv4cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--i+iWqY68NNxfGGlH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 19, 2017 at 06:06:04AM +0000, Parav Pandit wrote:
> Minor nit for safer code.
>
> > -----Original Message-----
>
> > diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c
> > b/drivers/infiniband/hw/mlx4/alias_GUID.c
> > index 06020c5..4648374 100644
> > --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> > +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> > @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
> >  	struct list_head *head =
> >  		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
> >
> > +	memset(&attr, 0, sizeof(struct ib_port_attr));
>
> Can you please change above code to,
> 	memset(&attr, 0, sizeof(attr));

Sure,
We will wait a little bit more to gather additional comments
if any and resubmit the series.

Thanks for the feedback.

>
> > diff --git a/drivers/infiniband/hw/mlx4/sysfs.c
> > b/drivers/infiniband/hw/mlx4/sysfs.c
> > index 69fb5ba..5835165 100644
> > --- a/drivers/infiniband/hw/mlx4/sysfs.c
> > +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> > @@ -226,6 +226,7 @@ static int add_port_entries(struct mlx4_ib_dev
> > *device, int port_num)
> >  	int ret = 0 ;
> >  	struct ib_port_attr attr;
> >
> > +	memset(&attr, 0, sizeof(struct ib_port_attr));
> Ditto.
> 	memset(&attr, 0, sizeof(attr));
>
>
> > a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index 4e8e78f..176417b 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -174,7 +174,7 @@ static int mlx5_query_port_roce(struct ib_device
> >
> >  	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports);
> > port++) {
> > +		memset(pprops, 0, sizeof(struct ib_port_attr));
> Here too.
> 		memset(pprops, 0, sizeof(*pprops));
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i+iWqY68NNxfGGlH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAiLAACgkQ5GN7iDZy
WKcPsA/+I0/m6u4ArDlooXIGJ6O1unN9ueVvJi61/hRrkD9ltg/kzcRYazjFMtG1
S/ec3pp4yBi4KCdloXfzReTa8F4kDWVxxhyMBYebIuq71KHFvAF+2WCnrC/gFyhW
zQkvdHrtALXY9tOdVUj57ihCwmZoVyboBI7kr6Zo0GfqvgjxkD502xBrOLINH2cm
g3pBQ+1if34z5i2rQXVM3D+4lvHVvuEQdt53Yt1LWfjhL8qS8NYu7Zsp73fxaewL
uyceKu0ZRsVS4qkvVh8zElhdoBM9hbEKVIWdSFpKiYsjKGy4ryn3wyx/ywEfL9lG
94kYhX3LFdekhmMpv6gokKsdPI4t4OiTmMsWV2LKaCwBegOScgMKWV+I0xTQsEiz
Vk0F9Mcf/f0gpOroLQt5c95dBHC46HSPf9xQp2fTvkDEVm33P6HwFDSq5ZQqreGB
4UgaWYo/pmNz34/11C0OPTetoOGTUSk85xub6X2kP7phZbmRwbJVLBrlxV2QwjPO
STxsTWgyhTqC1Xw1mpCpdIs5I0nafV60r5KH3DftD/agUpalKBuvDx6jSJkkw4Ro
cO3Ou4J3j9d0Pg1yj8sUC5xy2nMeivJ9yxb4FmnhFxy7d+f8x09AeIIjZH7Jn9TV
ULc64TMNQ4954KnxWtCNSXFH5Edn7608ZJJsLAlrcH6aUGPkNrA=
=q9FS
-----END PGP SIGNATURE-----

--i+iWqY68NNxfGGlH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
