From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Decrease default mr cache size
Date: Wed, 27 Mar 2019 13:41:01 +0200
Message-ID: <20190327114101.GT22899@mtr-leonro.mtl.com>
References: <20190319092439.10701-1-leon@kernel.org>
 <20190319092439.10701-4-leon@kernel.org>
 <CAJ3xEMiMphpkF6B-Ns-+wPcso1Lk=12=jn3ZqLoAB5a-GLfVcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKpLca3blcvhMJ0W"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiMphpkF6B-Ns-+wPcso1Lk=12=jn3ZqLoAB5a-GLfVcw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--QKpLca3blcvhMJ0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2019 at 12:07:54PM +0200, Or Gerlitz wrote:
> On Tue, Mar 19, 2019 at 11:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> > From: Artemy Kovalyov <artemyko@mellanox.com>
> >
> > Delete initialization of high order entries in mr cache to decrease initial
> > memory footprint. When required, the administrator can populate the
> > entries with memory keys via the /sys interface.
>
> Please add here:
>
> This approach is very helpful to reduce the per HW function memory
> footprint in environments such as VMs. Before the patch we see
> consumption of 0.9GB per function and after the patch about 0.1GB
>
> > Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
> > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> Reported-by:  Shalom Toledo <shalomt@mellanox.com>
> Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
>
> Lets push it into stable kernels, a Fixes tag here will cause that
> to happen more easily, so please consider that.

Thanks,

I'll add it at the "apply" stage.

--QKpLca3blcvhMJ0W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcm2FNAAoJEORje4g2clin6+wQALK0kh1fgmGqcx9HepmCUS7v
daJVEy83EDS+IfEilt2ZGiRynS+yBbpmQ0bBZ65//nDWcwVddAJY1Ah1/WHhd2Te
1hWG07CG3LmAw/KGg2oFSsfnqL91eBGZOFpmXNpnhbXp/3XBGsLWRy16bu0gwv9+
y3ZZooduxLOoRA8dlOnVAUl4QiEk6rZIzUY2M+SXIiKSTaJoVPgM/KX0q+AbvnsH
xuBBSFNePek54x0tFVsJYKgOw86CDNSg7RRUiQJEDU/GiTQfsJPoaqlaSYQN2J56
T5MsTAyJB6xzc1eGuCFYKvtd0V0u7ZDnV193YvAaD0L+R+CWMO5e7p/JCwFe3YZK
IrbAIJCR2wAqzOW70Earu+4/nRfnxX9HtRtJG35TvdWFbOKHUO/9+8ormsxcnOlj
QeqM4vBiJZZKcq3FbJxCdKv64qupFWoDIGaEwa4iT6SUSbt49AHlJGwHBnnLXPNc
y7Vx89limWXB4B5P+zbBOte5f6VkXOoMZV9wy+CktRH9ppT9a+U3vqKBirUXhq4v
vex+YNVjtDi2Uv3o8tgpxsaK8VRupU3/eRqZwJBcno7nd7HRmNxDWzON5XhTtbGB
W649odLqH/RFMlr0riR36yAnd/dojmsSirMX7ykp4QX9jVzKL4b6EtzoFh63rdkf
tuABTMW+gRRuqGvaMUkx
=Le4F
-----END PGP SIGNATURE-----

--QKpLca3blcvhMJ0W--
