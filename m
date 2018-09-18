From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 0/4] IB: decrease large contigous allocation
Date: Wed, 19 Sep 2018 00:23:51 +0300
Message-ID: <20180918212351.GB3661@mtr-leonro.mtl.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <20180918144623.GI11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tDYGg60iReQ7u8wj"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918144623.GI11367@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jan Dakinevich <jan.dakinevich@virtuozzo.com>, Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org


--tDYGg60iReQ7u8wj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 18, 2018 at 08:46:23AM -0600, Jason Gunthorpe wrote:
> On Tue, Sep 18, 2018 at 04:03:42PM +0300, Jan Dakinevich wrote:
> > The size of mlx4_ib_device became too large to be allocated as whole contigous
> > block of memory. Currently it takes about 55K. On architecture with 4K page it
> > means 3rd order.
> >
> > This patch series makes an attempt to split mlx4_ib_device into several parts
> > and allocate them with less expensive kvzalloc
>
> Why split it up? Any reason not to just allocate the whole thing with
> kvzalloc?

And before we are rushing to dissect mlx4_ib driver, can you
explain the rationale behind this change? The mlx4_ib driver
represents high-performance device which needs enough memory
resources to operate. Those devices are limited by number
of PCIs and SRIOV VFs (upto 126) and very rare allocated/deallocated.

I would like to see real rationale behind such change.

Thanks

>
> Jason

--tDYGg60iReQ7u8wj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboWznAAoJEORje4g2clintC8QAJxerU0oMGgBbDR4HGzsEqz/
DfJ694zTNs+ol2zSjbTxRHljws2RJ5lExH9LErpMUtzIfFMnABwl2j+2qUmJbwnd
lB2qSugb2BV6Pnd0TVoWJjklgdx2K37IIESYlNyaT0IYp5jucoAv1yd3c0rhfppu
WF3d1pgn6ysDh1yypMojpk5O71S6q+Zb/ESzo9AAqKMSoppAKo6GU36T7W3hVbmm
IyPBn+EogAmrPvEByIlLksMMJTbXnY5Lls5GR41kuLEI38VN/9occQC0iyMlGL8C
WD+BQf4wIFFEtgpzToJmE7tEwgPZch6R2UNDJ/N56T/EItqgpKpni2BMkJsPJC8B
4TF8nLywq7i9XM4ygRHag6Fzs3dMAj+GXMLnLhk8Up+KiL3d87gZCpeMlMjYNByO
0QTJvdL50OOuzxFBRryunOWbKVqMoJlHJ95OhadGSXmT5o5zF5cws0GHW6oNGKy9
WMH1U48lQrtoYoq0+V6T+PFQ69odYVTQV0NYFWNzWvxrY6OsMahUuRSDjuF2N8W3
onop1dBfcok7fbR7cUkZi0bo8hwvu9Yin/pFjwn0p6pvSzkoiQnuIKqGjn4qJlVJ
aytBCfS+WZul+n+Qcwst6Vlxa3EPix1GzuixIW0B74DYMZRz6IySs9+xBDOLKMMr
HKRytq15Z3d8+kPWTS2B
=g0eP
-----END PGP SIGNATURE-----

--tDYGg60iReQ7u8wj--
