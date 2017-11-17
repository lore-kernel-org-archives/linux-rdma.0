From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Fri, 17 Nov 2017 07:00:55 +0200
Message-ID: <20171117050055.GP18825@mtr-leonro.local>
References: <20171116204400.GA28216@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cwDISR/d8KKT5XXq"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116204400.GA28216@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Yaron Gepstein <yarong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--cwDISR/d8KKT5XXq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 16, 2017 at 01:44:00PM -0700, Jason Gunthorpe wrote:
> As was discussed in September and October, add Jason along with
> Doug to have a team maintainership model for the RDMA subystem.
>
> Mellanox Technologies will be funding Jason's independent work on
> the maintainership.
>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  .mailmap    | 2 ++
>  MAINTAINERS | 1 +
>  2 files changed, 3 insertions(+)
>
> My updated PGP key with the new email addresses is in the key servers
> and available here:
>
>  http://www.ziepe.ca/pgp/jgunthorpe.gpg
>
> diff --git a/.mailmap b/.mailmap
> index c021f29779a7a1..1469ff0d3f4d55 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -73,6 +73,8 @@ James E Wilson <wilson@specifix.com>
>  James Hogan <jhogan@kernel.org> <james.hogan@imgtec.com>
>  James Hogan <jhogan@kernel.org> <james@albanarts.com>
>  James Ketrenos <jketreno@io.(none)>
> +Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
> +Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
>  Javi Merino <javi.merino@kernel.org> <javi.merino@arm.com>
>  <javier@osg.samsung.com> <javier.martinez@collabora.co.uk>
>  Jean Tourrilhes <jt@hpl.hp.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f9c4f3fc9419d..d4e621e350f2cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6827,6 +6827,7 @@ F:	drivers/ipack/
>
>  INFINIBAND SUBSYSTEM
>  M:	Doug Ledford <dledford@redhat.com>
> +M:	Jason Gunthorpe <jgg@mellanox.com>


Jason,

I want to warn that you will have hard to use your @mellanox.com address
for any external to Mellanox communication, because of questionable IT
innovation - they rewrite links in all coming emails.

It will make your replies looking very bad and it will be unreadable for the people
who are using plain text readers to read emails.

The example of it, you can see here [1].

We (top Mellanox upstreamers) tried to fight for it for the more than half a year,
and gave up - using my external email for everything.

Thanks

[1] https://marc.info/?l=linux-rdma&m=151077009200628&w=2


>  L:	linux-rdma@vger.kernel.org
>  W:	http://www.openfabrics.org/
>  Q:	http://patchwork.kernel.org/project/linux-rdma/list/
> --
> 2.7.4
>



--cwDISR/d8KKT5XXq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloObQcACgkQ5GN7iDZy
WKfrBA/+JMsCX7dt043NoJtzifW/z4UjMBChv1AWRX3/m1B1gWkOdskqgjdfgDi2
kZhnwxoMnC+YkgdaKxXAGRT2YKEx9tyY7MlQ9uyn/u1wd/qF3vLsMTj5g/WYODCH
MJYSy9uZvAWGZyv0ldLu4Qx+OKB8x5eiTStQ1QxSN2+fhUv2YjHgJSdh3DM30eXd
j9973P0gBKZnNKjgi/kuTz1LQ+nnecVRsXSfCEvZupqwNZY1msQuMgj+VeeHxjUV
bJQ2Vbve7Uh8kLvXDmRhRspT5c7RcC4NBlBJl1pC6rov7ilk0uoHb01ngu5hezzL
scc8FKscY/9lcRzhYRXrS5V/bq1prD0ws+5QzaFcZNX+4bh7BsgG/3Uqfq6D9L24
5VvTHKBn9GsGsQC4hslj+ZyxrTet1AQ2/lzBoNJqM3Q/XkATCJK4QgNuxNmHJZ8b
UEXSAmxPptY67KydJzTptuUMKAYrkmzm8kNL6wYirzPBKo95OW9RsyMvB483AhWZ
S7O34ki1bk0zgAYUJ5fRmqq+iJ3kvmQEwppTfQ+lgtMEUqzStheYwmzPMiWu+gk1
tIh/hlPyyR6sGukQem1FToi26pkyfkkUGz4GYhadIBwIXM42Kb1Sj90QmpX96R+c
n8p6gN7GJECAfAi+HcBNrY1haPDK+I5SC43TzUr7l6X3LYolT3s=
=cOJo
-----END PGP SIGNATURE-----

--cwDISR/d8KKT5XXq--
