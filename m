From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Thu, 19 Oct 2017 09:14:05 +0300
Message-ID: <20171019061405.GW2106@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
 <20171017081837.GA19107@obsidianresearch.com>
 <20171017102121.GM2106@mtr-leonro.local>
 <20171019061100.GB6555@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5LBS9LiS8wIv0ZHM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171019061100.GB6555-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5LBS9LiS8wIv0ZHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 19, 2017 at 12:11:00AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2017 at 01:21:21PM +0300, Leon Romanovsky wrote:
> > > Yes, we should add a deprecation one shot printk to the kernel for the
> > > sysfs interface to encourage people to use ip
> >
> > Please don't do that, it won't help for anyone, and especially for the people
> > who didn't hear about "ip" in 2017.
>
> This is the standard kernel way to encourage people to use the new
> interfaces...
>
> > IPoIB netlink doesn't support enhanced IPoIB device because child
> > device in netlink code was not allocated with rdma_alloc_netdev call
> > as it was done for other flows.
>
> I don't understand, isn't this just a (bad) bug to be fixed?

Yes and we want to fix it BEFORE adding discouraging warnings.

Thanks

>
> Jason

--5LBS9LiS8wIv0ZHM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnoQqwACgkQ5GN7iDZy
WKeV0BAAyPNpRROlDZzpBUrEpOpxlZNoE2sH4plosTJxLI6MMJXXjiEj/RoyTkKb
s0Zgu6XWrm9ODvWsJoumtUD26L2WHqZz9wD3L64fd9VEX+OCYfQchHNEJPNCcbRq
6uuwU8cPSbUg3xhGNp3OtEwxxKy1yVNFDJz87gcCbrepdQaTTcVWW9zmafm1mG4X
ddgEIDiuz/h1eR26IvG65sTgl8EspCep5v/S8vjVcbyf4ls+7mYGomao/aEaSv3r
URXvvrNtXEUfb73/j/6fkLpMaD7HD0izTLFNHxvK8xv69DKlH/dDRIBN0P3zn2EF
RgBRVTPToCLU438kGBQ9BFsTvj24N8hCNBvVPWAkvNf9z8vQPum/6z3ZNKiaQ4sZ
a9rI6yvfIxb0ihxmCjOS9HjIWMz0z/N26uG6+HeL0F3VrExZjN0e6EKpX8bXVI9J
apnzoqFKL5q55VLYn61e34sSkX8XDFi3BtkOJPN+MQY+ey+K3IEaCsWVpbkC9OM2
RRD2GtPNXD/l1WjxsREuWkblmLKkB8jWdip1GgbULYWVZGX9/oFc0Ih1B07WQC+G
7t0poAtwnJW3jz8M6cdKyCmKooaNrkfcBNrcJDPhOMQJDsX9dziaE1OyW38wUeLY
oi0urVcnntematBj5hXudJmPdnDDmBoWiQ+u1qI/GvQ0qONAiY0=
=ZtG7
-----END PGP SIGNATURE-----

--5LBS9LiS8wIv0ZHM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
