From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Decrease default mr cache size
Date: Wed, 27 Mar 2019 15:36:07 +0200
Message-ID: <20190327133606.GY22899@mtr-leonro.mtl.com>
References: <20190319092439.10701-1-leon@kernel.org>
 <20190319092439.10701-4-leon@kernel.org>
 <CAJ3xEMiMphpkF6B-Ns-+wPcso1Lk=12=jn3ZqLoAB5a-GLfVcw@mail.gmail.com>
 <20190327114101.GT22899@mtr-leonro.mtl.com>
 <CAJ3xEMiSo5p_hUodKbja7ux0+7W+9rGYq0d_jc=Vn47VNM3J6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K0M4iRgkWWXhiQ9N"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiSo5p_hUodKbja7ux0+7W+9rGYq0d_jc=Vn47VNM3J6g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--K0M4iRgkWWXhiQ9N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2019 at 01:58:17PM +0200, Or Gerlitz wrote:
> On Wed, Mar 27, 2019 at 1:41 PM Leon Romanovsky <leon@kernel.org> wrote:
> > On Wed, Mar 27, 2019 at 12:07:54PM +0200, Or Gerlitz wrote:
> > > On Tue, Mar 19, 2019 at 11:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > From: Artemy Kovalyov <artemyko@mellanox.com>
> > > >
> > > > Delete initialization of high order entries in mr cache to decrease initial
> > > > memory footprint. When required, the administrator can populate the
> > > > entries with memory keys via the /sys interface.
> > >
> > > Please add here:
> > >
> > > This approach is very helpful to reduce the per HW function memory
> > > footprint in environments such as VMs. Before the patch we see
> > > consumption of 0.9GB per function and after the patch about 0.1GB
> > >
> > > > Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
> > > > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Reported-by:  Shalom Toledo <shalomt@mellanox.com>
> > > Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
> > >
> > > Lets push it into stable kernels, a Fixes tag here will cause that
> > > to happen more easily, so please consider that.
>
> > I'll add it at the "apply" stage.
>
> Just to make sure, by "add it" you mean the signatures, the text and
> the Fixes that?

Yes, of course.

>
> Also, is there any reason not to eliminate the mr cache pre-population
> all together?

AFAIK, pre-populated cache helps MPI application to start faster and
with out-of-box experience. Nobody seems to care enough to challenge
this internal assumption.

>
> Currently we consume 100-200MB per function after the patch which is
> also problematic for some
> environments.

--K0M4iRgkWWXhiQ9N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcm3xGAAoJEORje4g2clinLcsP/0YcbbLKj6k71w6Hv7c8U0Rj
JdwBtuSBJXUo/VCPUkO4U1uCZRROdx+YfkMAmfYHWxBaKzw8OAQksc3m3xt/FqPu
vmOwPfabpP4mP769p86tZz1nTBlgTBoQKOPoCm+i1U+0TTV79b5ykaIuuRReLEgK
7PVGyi8cdsR5B2lNyO4fStoss4ZRm8n3nN9qyZAO/aAwKlrvTltbKAMnjmOxdyw1
PQ1eX308E3fjUm6YrnbywALqBjko8Q/5YDt777TUoyS66A0d16jAjikoGfeVw/dA
djTg4Ge9u/VfSiUkgVy3ZXw8pRx1zX9ZBAmEa+L+1DLvc8KJKXohxqi/ziBM2X41
AEELhttresXkKIOygJ2CZ1aTooyDVzxGC9jZoTQUsDbvSa8xXwIaeEOhg7XQ9Zy3
FVpMFKTU9SNWxuunAKvRaoHIiEGSlDLZqgHn8ItPSBMRXT+3lmI8epdF9//fi9w3
VrZTFvrZILptU9GhlygXMYredgTNpnfXrIx4by3NCgBX294LlZfgw5Rgn+sE2DP7
HxG/kGLOh8kG89U0qWuq+ApnjWcQZTozHA/sZ+5haGpye24Jjq9sPdyUlrzNyntM
KG64jR2j58bHNy5tKRMW2AuGxJUH7dhRcg2B8nY0QcFkD/aHScFaFHn+hTEUNYqN
D2OnF+jqazIH8i5k2VsV
=QJYi
-----END PGP SIGNATURE-----

--K0M4iRgkWWXhiQ9N--
