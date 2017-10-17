From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Tue, 17 Oct 2017 13:21:21 +0300
Message-ID: <20171017102121.GM2106@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
 <20171017081837.GA19107@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zlo2GrDIozf6aQFY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171017081837.GA19107-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Zlo2GrDIozf6aQFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 17, 2017 at 02:18:37AM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 15, 2017 at 08:47:46AM +0300, Yuval Shaia wrote:
>
> > > > As far as I understand ipoib_netlink.c, ipoib_new_child_link() already
> > > > implements it and it is supported in "ip".
> > >
> > > Oh right:
> > >
> > >   ip link add DEVICE name NAME type ipoib [ pkey PKEY ] [mode MODE ]
> >
> > So with this interface we can entirely remove the sysfs interface to create
> > child, right?
>
> Yes, we should add a deprecation one shot printk to the kernel for the
> sysfs interface to encourage people to use ip

Please don't do that, it won't help for anyone, and especially for the people
who didn't hear about "ip" in 2017.

IPoIB netlink doesn't support enhanced IPoIB device because child
device in netlink code was not allocated with rdma_alloc_netdev call
as it was done for other flows.

Thanks

>
> Jason

--Zlo2GrDIozf6aQFY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnl2aAACgkQ5GN7iDZy
WKcCzQ/9G6XPvKQv52FO0XxG+ySDWZtlRPIuNboiI09QojYTa+v57NonxKOhCA8a
oZfOVAvUZisBBbDOyy5TO4YjfIDUGeq0oAbFUM2Cx+N6L6KNWLqAC/+defRiLTxV
HP52/CUTfyHJ0mC/2VzNMjnosYKIfH2EnNdxQ9NmYccTUz21aHLUpaLGXVLYFUkm
aEc1tAfxzx3Idusb8QXlXXqZQdToRsRmWpb7wYkWQ1bgWn5bPu0TlAwewcueRc02
fykmGEw1kIhcQJij418MJUm3P9y5DipBE8aEcmXAdQv3ARKULIm8aZvhr9Sf9s5w
8rNYFXx2rwb8qL/A4MlLbjuW3f3z154k3/6LdLNZuXaEpMETTU0X8ke0o9g+vERI
dIV1tZmYPLstwFc7kn8ZjLzm/XnoXC6POAS5ueK4kvP1lCZJvufdeds3xXsSwPeC
xpuWjnMHuXw3IjEBlH1xXi7S6ztzNlcpdbenW6MO5NCE0FD/yKXR7AgoTUaLYx+T
VSF7915HkcKimw6CFqKIcqr3noH2pWE4iywkvEwwt+KnfbwbSw6/HkiLjFGpg1nw
k/h0WtuO23+rrk1LJ3PiWR3nJ0CZjjL4AmNOkHFv0+EMopUzo2Dw4yeHFSCqmNcH
npMXFHM0hy6dRAFNjCLH+oQPIP6swhJcwmdl7Qi2v8TElnvUEwE=
=BQCh
-----END PGP SIGNATURE-----

--Zlo2GrDIozf6aQFY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
