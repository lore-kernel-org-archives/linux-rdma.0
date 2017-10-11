From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] IB,hfi1 Add MODULE_FIRMWARE statements
Date: Wed, 11 Oct 2017 18:49:14 +0300
Message-ID: <20171011154914.GL2106@mtr-leonro.local>
References: <20171011144134.c6bba480faee444cb9881710@suse.de>
 <1d7e8d05-9a6b-6dbf-d528-41ba64129348@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bFUYW7mPOLJ+Jd2A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1d7e8d05-9a6b-6dbf-d528-41ba64129348-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bFUYW7mPOLJ+Jd2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2017 at 11:31:18AM -0400, Dennis Dalessandro wrote:
> On 10/11/2017 8:41 AM, Thomas Bogendoerfer wrote:
> > Provide information about used firmware files via modinfo.
> >
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> > ---
> >   drivers/infiniband/hw/hfi1/firmware.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
> > index dee3c674f33d..f56ace76b42c 100644
> > --- a/drivers/infiniband/hw/hfi1/firmware.c
> > +++ b/drivers/infiniband/hw/hfi1/firmware.c
> > @@ -70,6 +70,11 @@
> >   #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
> >   #define HOST_INTERFACE_VERSION 1
> > +MODULE_FIRMWARE(DEFAULT_FW_8051_NAME_ASIC);
> > +MODULE_FIRMWARE(DEFAULT_FW_FABRIC_NAME);
> > +MODULE_FIRMWARE(DEFAULT_FW_SBUS_NAME);
> > +MODULE_FIRMWARE(DEFAULT_FW_PCIE_NAME);
> > +
> >   static uint fw_8051_load = 1;
> >   static uint fw_fabric_serdes_load = 1;
> >   static uint fw_pcie_serdes_load = 1;
> >
>
> I don't find this terribly useful, but if it's useful for you I'm sure it is
> for others as well, so I have no problem with it.

Dennis,
Aren't those defines being constant?

>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--bFUYW7mPOLJ+Jd2A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnePXoACgkQ5GN7iDZy
WKfKhw/9EClZr4FeyoWY21D5XA+r8N9i/wPgz65PEPAx4R5rOZgM8fhFciF81cYy
4w95VEcVdxbBPSfE2oDTYc5MSSWSq7v6KspDPM4RWT818nWYM/A6Fx+jXk9x62kO
a0gVbnHXmXHGDy8xbrWTIeMwUVx0UvKTJYsi4oEdjdsfeoglLAX7I5Xa+vdvub4p
apTQGy7Xn0IQVp1H/xmgnGRxt+Jd757tgvA+itZoSoQe99iHd4xEvXDKmCU6YBRa
xPYSY83bECuY3q9NAMSIv/h1vfA5IdUivlyh6sgfPOB9JhYF23OUr2O+3VYQvz7V
RA0EjUQ8cbiA6V/60P+1M/rUFoZXFHuD22I5XkDmpaFcuztwk3VUQ7eHK3dXBXdH
30abQCtNfdsGICBpmNwjSzPPSg23yYPR9otxNZwEsi2cK7iWI0XdTKKHeJRPGv0B
k6t+M1M2O0Q6oqEf1jvhDn2YoLZbau/IUixzQoIHdMp0Tn1EMjTaoQNmfvcGTbWj
uTp9tqswGfDKZ4gRhSrfP/AQajA45nINP2fmh126uwFL1W/fO5g+IrXuEdTTunkB
bH2/3TDWYP5OAkk01GKly3alUhibXFjdCoVHQzK6RrRPbiUxAP9SvmwX5LP2sChA
UsigulemFrsWdngOjd+QBjDL5RzmAVaCoaZzyFC74bKLBXOE5GI=
=s4Kf
-----END PGP SIGNATURE-----

--bFUYW7mPOLJ+Jd2A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
