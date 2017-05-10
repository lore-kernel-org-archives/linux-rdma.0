From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Wed, 10 May 2017 19:02:01 +0300
Message-ID: <20170510160201.GD1839@mtr-leonro.local>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
 <20170509180517.GA9715@obsidianresearch.com>
 <1494408947.3739.2.camel@profitbricks.com>
 <20170510155005.GB1007@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170510155005.GB1007-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 09:50:05AM -0600, Jason Gunthorpe wrote:
> On Wed, May 10, 2017 at 11:35:47AM +0200, Benjamin Drung wrote:
> > Am Dienstag, den 09.05.2017, 12:05 -0600 schrieb Jason Gunthorpe:
> > > On Tue, May 09, 2017 at 07:43:09PM +0200, Benjamin Drung wrote:
> > >
> > > > * Can we upstream some redhat files, i.e. move them out of the
> > > > redhat
> > > > directory and maintain them in their corresponding code? Following
> > > > files fall in this category:
> > >
> > > Anything in the redhat directory could be moved out if it is going to
> > > be used by another distro. It is there waiting for other distros to
> > > look at it.
> >
> > * The ifdown-ib and ifup-ib scripts are redhat-specific. It won't work
> > with ifupdown from Debian.
> >
> > * The files related to mlx4 look like a special handling for mlx4 to me
> > and they do not following the KISS principle.
>
> One part is managing the need to setup multi-protocol ports on
> boot. This seems like a general requirement for mlx4/5 so maybe it
> should get some more common solution..
>
> > * What's the purpose of the cxgb{3,4} modprobe files?
>
> cxgb is a multi-kernel module driver, those scripts are an attempt to
> load the other parts when the main driver is loaded. I'm not sure why
> cxgb is special enough to get these files but mlx/etc are not.
>
> I suspect it is old cruft because redhat/rdma.kernel-init handles
> things uniformly on systemd environments.
>
> I've been thinking we should patch the kernel to solve this problem
> instead of using this ugly userspace solution.

Can it be related to the fact that mlx5 core calls to
request_module_nowait for mlx5_ib and chelsio doesn't do it?

>
> > Jarod already created a rdma-core package in debian/control in commit
> > 8df5873b9. Currently we do not have a rdma-core package in Debian and
> > no package with a kernel-boot service file. I know that the openibd and
> >  mlnx-ofed-kernel-utils packages shipped a openibd service that does
> > similar job.
>
> Yes, pulling something like openibd into rdma-core is the idea here..
>
> > Do we want to call the binary package that contains the kernel-boot
> > service 'rdma-core' or simplify that to 'rdma'? We should use the same
> > binary package name across the distributions (unless it's conflicting
> > with a naming convention).
>
> I think rdma-core is fine..
>
> > Can you come up with a patch set? I will be happy to review it. Note
> > that paths like /usr/libexec/rdma-init-kernel (in rdma.service) needs
> > to be made configurable. In Debian, we would install these helper
> > scripts in /usr/lib/$packagename/$filename.
>
> Maybe Leon's team will try to tackle some of this? It is complicated,
> the RH scripts do quite a bit stuff :\

I would be happy to help, but I'm not sure that I understand what should
be done :(

>
> But this doesn't seem particularly urgent for Debian packaging, right?
>
> Jason

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkTOXkACgkQ5GN7iDZy
WKdyGQ/+KEa5V4efE5PBUB3taugY3k66pkmkZnhXsR/EF8fp6OJGxFGFSZ80bEl/
g8CDehLm8GmlIyLBQESmWJX0L38fKcVQNEwm8HkrRUcOKQyQrL9/5+eIK8/Ul+GP
ubblz/aW142RSB4i7EFXd2UI8WjI6MX5acw0pKdWpb62gQRNbtzA5yBKJ8NssBz5
XEIUv7SLVdy456r0pppdp5QVSkv1IzgRxOJ++gVQLRgI5aZXjf78WlOtQ8g4W/ei
VfNBEe6ScTNWMF4VFG95sEb0DBANrm51O39/dwNOUEDhnvoQgtPIvOwDFZ6PS36C
Pu9ukQbiGZCj29Dor3hw7MpvFHevUK2nMObu4kobljfjXhCDyeBwK6YYUbnAwhdY
kCknloaBoZ5OgCGBVH254Gh9hmphkYD59wq4/CGj146dLjKVgAuh3HQn0azZ3M/X
6W2feXbMyMPec9whftpCCwiONbEh8LbisDrTTkUMni1MXpIBmg/RkZdl890qHa8E
7ba9e6/Wfbtefa4B5lSnMRd8uViPK6X96ThnlopZEKU/bDC6b4CpSiz8L02vgITm
gcxGr/nFRg7Ns7cM3qWVXrsjptk8HWV1he4yKKlKFEcTt5cKsKIMrwh9CroDIwVy
Z9GBj3Fecrk1dK70kigv9reo/+2JqZpNdb9DvyQ8+8c7q3U5FP8=
=2OyR
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
