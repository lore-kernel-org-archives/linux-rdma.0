From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/14] RDMA/uverbs: Convert command mask
 validity check function to be bool
Date: Thu, 15 Feb 2018 16:27:45 +0200
Message-ID: <20180215142745.GJ2197@mtr-leonro.local>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-2-leon@kernel.org>
 <20180214234141.GC1718@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WQ40utMgiyDduspJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214234141.GC1718-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WQ40utMgiyDduspJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 04:41:41PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 14, 2018 at 02:38:31PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The function validate_command_mask() returns only two results: success
> > or failure, so convert it to return bool instead of 0 and -1.
> >
> > Reported-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/uverbs_main.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> > index b36cb12b3f38..1be9a93f628c 100644
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -635,7 +635,7 @@ struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file
> >  	return filp;
> >  }
> >
> > -static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
> > +static bool verify_command_mask(struct ib_device *ib_dev, __u32 command)
>
> Shouldn't be __u32, just u32 for in-kernel stuff
>
> Same comment for all patches

Yes, it was __u32 from the beginning.

>
> Jason

--WQ40utMgiyDduspJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqFmOAACgkQ5GN7iDZy
WKdS9g/7BUYyzupjbUXDTVW7MvwUYK24TugIIiq23Izv+UG/VzzAwRNFTESEEQhD
R/baMq8UR6Eqxz/B8IdojNB+3HFwuJCPerK/PRXcOj+I0FM2Ek4UoWcolDrT5/9s
9LSGvD2dgZsaNcUHx68xlQe2qXofZE9kAjd0kGfWnpqFESfHeOitGWo2aHrweRrv
SoFb8RERB24/8Y2em0eRY5vSqDfvfej9IXIpDYS8tjY51+ZRT6zYn3LwBJPYmLM6
31VYgCXnqvEA2rkI/tSiKkafzMy7NK0yWjbeb8QR56DEg65pN8lhVhSlsT5bLGe7
emryEGtukENyeH+8IijZL7J+o/90t3Rim65dC0OzoLICemv8joB31YV/zU/rcuOb
Uqc9k2UaHaUHVn5bPRHsdNWwg0FDraaxdJ9xWC1iWLU900N3E0gnjL+Mrp2vnXNB
OwFAver5ikJgPIej1DbzpiLIIRfrSA/IfV61TuAgSn/SB6Ogi28n5y02KgfIgZwj
UlOhYh6wLkEhKurhaLTunT7L0ENYylEZeFtd0uFrjxrYQLgh+VGbJMANsRIAHLbb
fNMuk4yLNvtJu9J4YPfzxCgDT20GQEqkgiJf2qYo58TKIv+fqiYcxEWPxngmjPeC
gUGpkZg1leX4TSvVTqotZBNTNL5ao+pxRK5E+l1C3Sddf48m07U=
=HNT8
-----END PGP SIGNATURE-----

--WQ40utMgiyDduspJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
