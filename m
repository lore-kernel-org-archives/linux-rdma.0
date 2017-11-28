From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 21:08:26 +0200
Message-ID: <20171128190826.GR29104@mtr-leonro.local>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca>
 <20171128061517.GO29104@mtr-leonro.local>
 <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
 <20171128183910.GA21325@ziepe.ca>
 <1511895042.28512.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GeONROBiaq1zPAtT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511895042.28512.6.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xavier_huwei-9Onoh4P/yGk@public.gmane.org" <xavier_huwei-9Onoh4P/yGk@public.gmane.org>, "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-WVlzvzqoTvw@public.gmane.org" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GeONROBiaq1zPAtT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 28, 2017 at 06:50:44PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-28 at 11:39 -0700, Jason Gunthorpe wrote:
> > On Tue, Nov 28, 2017 at 08:20:09AM -0500, Dennis Dalessandro wrote:
> > > I could resubmit just the series, or you could just pick the 4 driver
> > > patches from patchworks whatever is easiest.
> >
> > I marked them in patchworks, but can you review the commit messages
> > and make sure you think Linus will see them as rc material too?
>
> My understanding is that the rc stage is intended primarily for fixes for
> bugs introduced during the merge window. For all patches that do not fix
> bugs introduced during the merge window it should be evaluated carefully
> whether or not these are important enough to be included in a rc pull request.

I had the same feeling in the previous cycles.

Thanks

>
> Bart.

--GeONROBiaq1zPAtT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlodtCoACgkQ5GN7iDZy
WKcD6Q//abxQsWpE0usSVrtVwROdm1c1268DbcuFdXukHJY3ybo6ap7jiDjSPTCm
zdOhg7AwGSZms2LU7wLJrr0vnAcrgs9rNJ+IZpBir/sW0Q7qGfgGqhT3BOPs94ot
yDjJA3i5ioAzt6v9VHmJz0JNsHivhHtaMEIXu62KGXHu0T+Y0fcXNQ1Fq2I3qzvQ
2UttwSbT7ZjD6SaQov9K7b/nuG3113uw2aLFFrd0O6LqGmqynRFyK0gl5Dq1sah3
91lO0J/vxEh6e6+NkVE050fvP1kZeCoBXkAjFeYIb7AubDVzbvncwiOTJxmoJuDO
TkQKvoUw2OI5++nXDq17Tshv5xA2QgjDX6ppzmEowJQTx3PvtLIKA4AaeYFHyomg
qCwSbEQEJC0cj63XovqJocNFAsqP8DCwfPHVaVMiO3ft8GK9LSee44cJTKUCKMLV
s6x+wiuA+FfCAdKH6eJQeIdaEDjxHHAOkl5pQKPC/0mkqWOQCp8XBav3vBGwUQRq
chBMnGgfMtKINQygQU1Rm/W8ihnGNpra5wuAWCIrhFR2EQnJc4cUpTSD4A+7yEaJ
CEGQjtt33cz/kKHI1UdTNu6XcjhKNdzPqezhP2QnbIQmdY/oPHCkUA2uNmwQ3KDd
jkso6chUZe5uVgpo81N6zqtLZEKvG6W1c1IRtScVRWaRWNqqbNE=
=pQnt
-----END PGP SIGNATURE-----

--GeONROBiaq1zPAtT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
