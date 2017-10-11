From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] IB,hfi1 Add MODULE_FIRMWARE statements
Date: Wed, 11 Oct 2017 21:10:05 +0300
Message-ID: <20171011181005.GM2106@mtr-leonro.local>
References: <20171011144134.c6bba480faee444cb9881710@suse.de>
 <1d7e8d05-9a6b-6dbf-d528-41ba64129348@intel.com>
 <20171011154914.GL2106@mtr-leonro.local>
 <3e374d9f-d63d-8601-b594-a9c2a426833e@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qySB1iFW++5nzUxH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e374d9f-d63d-8601-b594-a9c2a426833e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qySB1iFW++5nzUxH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2017 at 01:13:26PM -0400, Dennis Dalessandro wrote:
> On 10/11/2017 11:49 AM, Leon Romanovsky wrote:
> > On Wed, Oct 11, 2017 at 11:31:18AM -0400, Dennis Dalessandro wrote:
> > > On 10/11/2017 8:41 AM, Thomas Bogendoerfer wrote:
> > > > Provide information about used firmware files via modinfo.
> > > >
> > > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> > > > ---
> > > >    drivers/infiniband/hw/hfi1/firmware.c | 5 +++++
> > > >    1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
> > > > index dee3c674f33d..f56ace76b42c 100644
> > > > --- a/drivers/infiniband/hw/hfi1/firmware.c
> > > > +++ b/drivers/infiniband/hw/hfi1/firmware.c
> > > > @@ -70,6 +70,11 @@
> > > >    #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
> > > >    #define HOST_INTERFACE_VERSION 1
> > > > +MODULE_FIRMWARE(DEFAULT_FW_8051_NAME_ASIC);
> > > > +MODULE_FIRMWARE(DEFAULT_FW_FABRIC_NAME);
> > > > +MODULE_FIRMWARE(DEFAULT_FW_SBUS_NAME);
> > > > +MODULE_FIRMWARE(DEFAULT_FW_PCIE_NAME);
> > > > +
> > > >    static uint fw_8051_load = 1;
> > > >    static uint fw_fabric_serdes_load = 1;
> > > >    static uint fw_pcie_serdes_load = 1;
> > > >
> > >
> > > I don't find this terribly useful, but if it's useful for you I'm sure it is
> > > for others as well, so I have no problem with it.
> >
> > Dennis,
> > Aren't those defines being constant?
> >
> > >
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Which is why I didn't find it very useful. However Thomas makes a good point
> [1].
>
> https://marc.info/?l=linux-rdma&m=150773727811239&w=2

Right, just grepped now and see mlxsw using it too.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--qySB1iFW++5nzUxH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlneXn0ACgkQ5GN7iDZy
WKdJ+Q/+Km4ByIiTxK0fzMri/iDRFul459KAc6NiG4qW0fYgJYy5X0UgCH/jWFWo
sq7lRvWnbhVyRM/HHK3oUMeUw4r2mD+SWFK1J/37WYYwmR8ZthrQQoBM1QY/HvLq
TGweb7npJETSE18gtS87ikkOvuIcbyPgzM8AMP5gcs/s7IhHyGbvlUm+HD7G1wBq
CHDBYMx7m86NFT6t/3GOYNZqrCmkDTFnriMFnoymGyY6bFnFM15sMP42Y+Z8IvTi
e0basvt8Wj7OrIsZp7kA6xhdtAkHFX9uJXnfVA2RtZ+FwVF02m72THKXtE+bhaiG
bhCEMn+rTg/7cKDorXRtemHt8f1OfCRzkrEbL/YBapNymjhWxzmuLQvzE02vb7DU
1nGRwAEXCZ46lsO+tILofLD95oQs7/tmelBZqBrbFIrL8qC3kGARcNZvgq47mO2q
0p7lfyuFZpWnlwDpwQGWjckvffKlbBRCRM0wZd4TKKg9veRrHXvTRrjdYbB0rJ9Z
obPeqhjo3aoPt1FMGsmkI5h0O6lcmd+LK3q++aPcbUrWHxTndvN6U+RD2xb6ivZS
JhUb47E3gbflDMGYGfEd3LHtVf+j7XGIpcOMpQK3nu7rb19LetKex1oIneJdl8oB
DQ3S3MwL0VWvLUyDG1RgzudHZTCguOuY0CyaeOQXkrKQX/IhnpE=
=Kzso
-----END PGP SIGNATURE-----

--qySB1iFW++5nzUxH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
