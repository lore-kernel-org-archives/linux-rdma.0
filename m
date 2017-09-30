From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: delete some stray tabs
Date: Sat, 30 Sep 2017 13:23:47 +0300
Message-ID: <20170930102347.GE2965@mtr-leonro.local>
References: <20170929074943.cs2jea5xttk2r6vm@mwanda>
 <20170929102929.GA2723@mtr-leonro.local>
 <20170929104004.svcnntqmgdxnzgnn@mwanda>
 <20170929144554.GB2965@mtr-leonro.local>
 <20170929203409.gd3yczvfnflwrwth@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AsxXAMtlQ5JHofzM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929203409.gd3yczvfnflwrwth@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AsxXAMtlQ5JHofzM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 11:34:09PM +0300, Dan Carpenter wrote:
> On Fri, Sep 29, 2017 at 05:45:54PM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 29, 2017 at 01:40:04PM +0300, Dan Carpenter wrote:
> > > On Fri, Sep 29, 2017 at 01:29:29PM +0300, Leon Romanovsky wrote:
> > > > On Fri, Sep 29, 2017 at 10:49:43AM +0300, Dan Carpenter wrote:
> > > > > These lines were indented too far by mistake.
> > > > >
> > > > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > > >
> > > > Dan,,
> > > >
> > > > I saw in your patches and don't know if it important. There is no
> > > > diffstat after your Signed-off-by and there is no "---" trailing line
> > > > too.
> > >
> > > Yeah.  I leave those out.  I normally write two line patches like this
> > > one so the diffstat is normally -2+2 and I figure people will see that
> > > they're tiny just from glancing at the email.  When I create patches
> > > that touch multiple files, what I do is just merge the diffs together in
> > > my email client.  If I tried to create diffstats for those, I'd just end
> > > up messing up a lot.
> >
> > What are the benefits avoiding them?
> >
>
> The way I develop the kernel is way different from how other people do
> and different from how I develop Smatch.  I've spent 9 years tweaking
> my scripts to make it work for me.  Please don't force me to use git
> commit...  :(

I had no intentions to do so.

>
> regards,
> dan carpenter
>
>

--AsxXAMtlQ5JHofzM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnPcLMACgkQ5GN7iDZy
WKfOvw//ZLBzdTjfdYYregTkZv0LUshTk4I8cZqbjPppO87OfndBIugovoDqIih9
bBOEHzkd3WNb2HZzuYSeMGz4YoPNN4BXikz7MRToei5HSmhSkNfw527ps6O3wDN7
oTHnQXzinrZS16QRm4A3TH7cjMGY1wsS7OYFiXENitjSevdcyy5p99dXV7Jcal6J
VX9hHXMx3Yju2s19XXg9wPb4XL+5DlO5KIZzIzebSAm+0l4dlm9VIgJEHwSyHqu8
7kiqAJ5sMB2dYumEkacOlYPuEIwQptFTN6BBCpRArYwR8irBXnO2KEJRS19sOtVt
sudLNRzvkRV+khTCE+jIodRSmpWORDcrT94bu65t+TeUiMfA4stj2ey7rNPLSfP4
H+qO2rxt9HINbF8gUojQ3D6P3MbU470Z+E+/8wuDyY8yCFBaVRYdhjgyIRiRy5SH
/8XeqY5w3/iG8J0sq+irR9gP1/F2KzSIYzY+wN4eckVSwwy97N1XwXA5eWesfdH+
TkfuK2srz5G090Zo1QpwPbjINILsg5EnfHp8Q+sE1/7HuI4JcvtsmWOK8lWfm7gg
hp7kkkft1UTZ41jIbQl+GcveCB5iSDMAebStK5IZGRwQw9ZN64qCRCvZpT/XIWs6
Aj1LN+5LgxpJYJSaDqqam0M3tH0up/CqrUg71v/gv7sW+DoztTM=
=L3/D
-----END PGP SIGNATURE-----

--AsxXAMtlQ5JHofzM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
