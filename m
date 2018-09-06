From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Thu, 6 Sep 2018 07:09:50 +0300
Message-ID: <20180906040950.GX2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-6-leon@kernel.org>
 <20180904220242.GA3895@ziepe.ca>
 <20180905051025.GC2977@mtr-leonro.mtl.com>
 <20180905163800.GA21028@ziepe.ca>
 <20180905181140.GV2977@mtr-leonro.mtl.com>
 <CAJ3xEMjrrhjCRmnGyD4SYit+pgJpakXLSrF6i35qaZiDfGsAxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E50aLcSU4JxQSj/B"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjrrhjCRmnGyD4SYit+pgJpakXLSrF6i35qaZiDfGsAxw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--E50aLcSU4JxQSj/B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 06, 2018 at 12:37:17AM +0300, Or Gerlitz wrote:
> On Wed, Sep 5, 2018 at 9:11 PM, Leon Romanovsky  wrote:
> > On Wed, Sep 05, 2018 at 10:38:00AM -0600, Jason Gunthorpe wrote:
> >> On Wed, Sep 05, 2018 at 08:10:25AM +0300, Leon Romanovsky wrote:
> >> > > > -       int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
> >> > > > +       int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
> >> > > > +       int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> >> > >
> >> > > Yuk, please don't use !!.
> >> > >
> >> > >   bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
> >> >
> >> > We need to provide en_encap and en_decap as an input to MLX5_SET(...)
> >> > which is passed to FW as 0 or 1.
> >> >
> >> > Boolean type is declared in C as int and treated as zero for false
> >> > and any other value for true,
> >>
> >> No, that isn't right, the kernel uses C99's _Bool intrinsic type, which
> >> is guaranteed to only hold 0 or 1 by the compiler.
> >>
> >> See types.h:
> >>
> >> typedef _Bool                   bool;
> >
> > Exciting, it took me a while to find C99 standard and relevant 6.3.1.2.
> > Anyway, this patch didn't change previous functionality, which used "!!"
> > convention.
>
> so? if we didn't do things properly prior to the patch, why not fixing it along
> with the patch? lets fix

Or,

What exactly "to fix"? Both code lines:
1. Have correct syntax
2. Implement proper C99
3. Give same compiler code
4. Have same readability

There is nothing to fix.

And this patch is already merged, so if you truly care about this,
please go ahead and prepare patch for whole driver, or better for
whole kernel.

 kernel git:(rdma-next) git grep "\!\!" |wc -l
8125

Thanks

--E50aLcSU4JxQSj/B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkKiOAAoJEORje4g2clinocgP/0mxuSnD+RgClhrTcbCQdux+
X1V0EJmAfErVBk9Ob0840D3jn4CmkhM4A9QohagW4/a5KBOcYhLWsg2kccNtdk05
lKQ46d7hWrkMo/Vh4Bwq4JuyQ+uo19JOCb0mDIT42tT48QLrPGDGMT6G7Fz5IBIO
y2PlYRiJ5pnzSyUwDV86SnPasLZ+2Bmgq8IsBGdXRDo/zovAr+Lva8Fvpc7iw+Fa
d0URWQe74iPwrRnTdJlwbrXuyP3pHIhaQPP7EmzA39QN1Xi+dIu9DWvFyjK5Ae4s
1RJhEZrrSiH5qYjL7JGDPgkYaqafCFVVsHv/DZbExYAkafs0ECAYyIDwBbU4Vfss
gy6IpXsN4PT0LRwdsGxXtZrYmlh8zKQETYszj2a7fe+MYIG1FcZGHbZVI3s+8PDo
UliPdYfuJxBwMLVgjm0Ql83YpaPOXLBJ9hMYHSFAiI7rCEp82eeQWr4+0mazlw8U
OkFgmRB3eDnHyuBJmwHIDzLHRitwoF1WQ8WmyngAYpvFFq17uHPk4zAiIZf0t5vI
L8/XVFBMEAey/xneHgNvWb5EDdo8Jh+TI08y5RQbHZgFtDsQvQbHGXXz3cV+TYgE
o8kQjsz4GWNqTZicIgrwfS98rk6WEOXgYKpGpNkir8WlLd5/1zk9AGSZ1xChe//O
qZ0+YYQmZMbM0g0mNEAV
=WYql
-----END PGP SIGNATURE-----

--E50aLcSU4JxQSj/B--
