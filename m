From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove the obsolete libibcm library
Date: Tue, 2 Jan 2018 16:26:59 +0200
Message-ID: <20180102142658.GF10145@mtr-leonro.local>
References: <20171225123132.6063-1-leon@kernel.org>
 <20171227201945.GG25436@ziepe.ca>
 <20171228053029.GO3494@mtr-leonro.local>
 <ea55cca5-1bf9-dd54-9be1-6450ca9002ef@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea55cca5-1bf9-dd54-9be1-6450ca9002ef-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 09:18:59AM -0500, Hal Rosenstock wrote:
> On 12/28/2017 12:30 AM, Leon Romanovsky wrote:
> > On Wed, Dec 27, 2017 at 01:19:45PM -0700, Jason Gunthorpe wrote:
> >> On Mon, Dec 25, 2017 at 02:31:32PM +0200, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>
> >>> The libibcm library was marked as obsolete long time ago,
> >>> the following patch is first step before removing ucm from
> >>> the kernel.
> >>
> >> I understand the distros will not want to loose libibcm in their
> >> stable releases.
> >>
> >> It might make more sense instead to just not build libibcm by default
> >> with a cmake option but still keep the sources..
> >
> > We are not removing it from the stable branches, so if they want to keep it
> > till last person who used this library dies, they are free to do it.
> >
> > The disabled build doesn't give much benefit at all. It will be dead code exactly
> > as now, but without any alert that it is broken. Most possible, it will be broken
> > till some distro will notice it.
>
> Since when has it been brken and how is it broken ? Last I knew it
> worked but was not used by anything in tree.

Hal,

Where did you see me saying that it is broken?

I said that it WILL be broken if we don't compile it by default.

Thanks

>
> -- Hal
>
> > Exactly as some distros have EOL, this libibcm library came to its EOL.
> >
> > Thanks
> >
> >>
> >> Jason

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpLlrIACgkQ5GN7iDZy
WKdUlxAAngIetE6egEjr2+SOae1aLHO9G56rlhcptosJSpe9seRW+vsmbC2az54/
icKDkaq+kI0yi1aNZjM8tCtSgvd5FGane2ZH6NWc+MqQ8P3xkZn/LmovcXoWXGae
t5KOKts512ko+a/wQSCVnLfXYAbXup6e58i/nX6p7PT/PaxmWSSNUY1E1SgRws3v
NgoR15ub4dU+vbTc1yHLQr7hRzDclhsBM3ajS9ZO5xFx5uoU8mVZwTcCWgBdGiIQ
7RvBppLgN5UTvAhKQdEr0ch1Qkka/A9g5jTKeUKWjFkFUvxcwxOI165s2/rk0K46
OoHqKuF7eX6pGoF1D8bhM/VhoACVh9T7vNOqLfcJ7TKRNxcYduWMgvmUwLNKoq/4
nvHfgGsgEQtEvNX2cQpWEPkEZ/uXIsqBI/aBPnWuiffaSM3VeOEU2RdMDMS4avsS
GaaSA3ZP/x2U8M5acOtz0kWg+Xpo1In27fwbT7ffcvVG8r9oO05YrMG2zRrvWXcm
LcUpDKEJ2/Gb/nPUSMp8DDWBdYbn5HgStTMQSXwU48HEZKyIy3HYdX2S0qP8uoEj
l7XBKyLBpldX5TyhLE9fS0wfGPMw3/cQt0Qc5A4cOJNtCkoDb+F0ZcbM6Mn0oJYm
QPeVHcZvZgrLB0sWONcAdP3m5fSEmzIjJ81cNNXMmadM35yL7EM=
=RXX8
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
