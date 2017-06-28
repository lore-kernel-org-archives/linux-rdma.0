From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] RDMA/netlink: Export guid and
 sys_image_guid
Date: Wed, 28 Jun 2017 19:12:45 +0300
Message-ID: <20170628161245.GJ1248@mtr-leonro.local>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-2-leon@kernel.org>
 <20170628160025.GA14375@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ao0agQACI2PjKWpV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628160025.GA14375-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ao0agQACI2PjKWpV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:00:25AM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 28, 2017 at 04:34:42PM +0300, Leon Romanovsky wrote:
> > +	[RDMA_NLDEV_ATTR_GUID]		= { .type = NLA_U64 },
>
> This should identify which guid it is. Port? Node? Device? Something
> else?

It is my mistake, I was under impression of sysfs. It is node_guid.

>
> If it is the port guid should it be able to carry the entire table,
> not just the 0th entry?
>
> Jason

--ao0agQACI2PjKWpV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllT1X0ACgkQ5GN7iDZy
WKeMixAAz65DqTN5UE+bNShxYpMadYcoGVwfsyHxKHucYZ5JlzhAjYt6SjGkA/jT
ETK6g+x0XR/rNwzxhCv5ddhoS8MNWQqsegqhguln8GEPYyIYvVbV0ZLW2+26BC70
kSuSQ7okyMTCz5Zu7gc4R7jObYDa0Q5B6gVaB+/WpeiivvW85bdB9Sj/PdtYJdOf
y3fyp7H1KLP4kcJjkp/gCXc3di7JmLRlCN3MTS6RQobX/YoKoqOT7MB2qfmHzxEj
fVjhF1ag2NEi6BSUzxNbvjqZI3rm6Hot5jzv6KOe5VEqauvbGnxh5rQZDMQOMb7q
wVoa+4nIEty7ykMoxBLleo8C4yg7mg3dksYh7XfjgOSPEbzZMAzPgVUyKJI2Cp9V
kBe4envPm+j42/3DUtf1G/STbpj08gF898j8J6YBMM5OdBNtOPspT2HUHH34egYi
OKa71Do8t7UMbJAdBvCCP5/Eicz97PWAeLD/UbYLIKW9ZBgtNRsVU+zzyQL+pC+j
f+FgJuFGLVHDSwriUzNZrY8CaAPFNnbtnxl3wLl4L/hM4iLGDXbAhP+UjxiDBSMe
6hpq+anoBSFIKxeLOBrZMcESk4mQhUJsCLBakdv1Jm6dlNy/ea40tNfHs1bjxYue
WsqL93IA7khQJVPZtutQDsykhOOxdGSXv2uxS9mevzNA/bQpou0=
=K9kY
-----END PGP SIGNATURE-----

--ao0agQACI2PjKWpV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
