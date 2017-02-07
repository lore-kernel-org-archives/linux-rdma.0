From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 20:06:42 +0200
Message-ID: <20170207180642.GQ6005@mtr-leonro.local>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H6VDMcGxLLsLVW3N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207172752.GA12315-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--H6VDMcGxLLsLVW3N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 10:27:52AM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2017 at 11:19:59AM -0600, Steve Wise wrote:
> > >
> > > Hm, possibly yes. ibverbs first checks the new location, if the
> > > provider is not there then it will fall back to a naked dlopen which
> > > could find providers in the system library path if there was a .driver
> > > file for it.
> >
> > Hmm, so it will load the provider libraries directly specifying the
> > full path?  IE 'ldconfig -p' doesn't matter?
>
> As the first try, yes. That is the usual way to locate
> plugins. Typically you don't want the system linker searching plugin
> directories.

Jason,
I have a slightly different question, but it is still in context of
plugins and linkers.

In v0 of DV, you asked from us to create normal shared library for mlx5,
e.g. libmlx5.so. In order to be visible to "gcc -lmlx5"i command, it should be
placed in the same directory as libibverbs.so, while plugins should be placed
in libibverbs folder.

I did it by using symlinks
$l /usr/lib64/libibverbs
lrwxrwxrwx    1 root root   10 Feb  7 18:09 libmlx5-rdmav2.so -> ../libmlx5.so
$l /usr/lib64 | grep mlx5
lrwxrwxrwx    1 root root   12 Feb  7 18:09 libmlx5.so -> libmlx5.so.1
lrwxrwxrwx    1 root root   17 Feb  7 18:09 libmlx5.so.1 -> libmlx5.so.1.0.13

It works, but I don't know if it is right approach from distro/packaging
perspective. Is it ok?

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--H6VDMcGxLLsLVW3N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliaDLEACgkQ5GN7iDZy
WKf6bg/+L0jy8+3diGf3SDyyxtXqIv48Jz+3FEqCHfokJ6neM7kJxkSc+K5kbo9p
Z2vGe5QtFBukjrh2bluT6oPNvCpYHbL9V4zCfWbpZz5lwL8cVVjvU9H3jaLJ3PTY
RR2VmOE5qpSeamTzXYchQOdYoXr8kMYMU8fYxr1/WNX5vbW0vXT1CsDyVQRlVR39
sqermlAQNLRk3n4m1rjYYd6bnh61wBBT0t1KLm8Y006EDTOrpmHhr0BWFsz5i67b
xvprQv35/CgmJSY5bmokihIWTbD8a0yAl2VZKTiA63Eh8aTuQ79mM/J6N5ql13ix
MxUjtTn1Aby7/xB7Xg5R5uRZbwQWwRAwentUF9LWt4BghMqNglYr8ChtKGFaZF4i
XIIsLnc8BGNEeXqcKBZL+fUFPiiA/4jvMY7DRBIDjXNHsrCIFbPDkg/VWJrGmATm
ypxMgSvDjzA8nu3MAYyJk0lsZFM33h9+W1ae7sgJZPWwF8PAQImOczYI8YW0wjog
Uk3LvZJXAY5w71MeidfKnG7BHP/L64ktDzrw+ELK8XEn4Ry69nVUhyHuuJrGxkAL
Ux0ek5P2y8Q1aeUBbGUJIQtxobTKzMboodk6aMuYkoRmt3nfzjM1uW9A2fJ3v8Ql
LtiK2CTOwAyzApsmu9T00Wbc5NJ0iVQR9yzt7gu510U7BQSvilg=
=wWo2
-----END PGP SIGNATURE-----

--H6VDMcGxLLsLVW3N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
