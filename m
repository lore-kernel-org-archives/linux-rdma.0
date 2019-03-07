From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 17:36:44 +0000
Message-ID: <20190307173640.GB32625@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <20190307072428.GJ1789@mtr-leonro.mtl.com>
 <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org>
 <20190307154020.GN1789@mtr-leonro.mtl.com>
 <CAGXu5jLBPpKOT-NV1P0nuFeSQYfoNY_8B0V4gcQg18xHPUVbhQ@mail.gmail.com>
 <20190307170230.GR1789@mtr-leonro.mtl.com>
 <CAGXu5jJDmEFA7=WuDnr0U6t9BTDFtd_WsB5HeryNKoZSaBW8oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJDmEFA7=WuDnr0U6t9BTDFtd_WsB5HeryNKoZSaBW8oA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2019 at 09:12:40AM -0800, Kees Cook wrote:
> On Thu, Mar 7, 2019 at 9:02 AM Leon Romanovsky <leonro@mellanox.com> wrote:
> >
> > On Thu, Mar 07, 2019 at 08:52:51AM -0800, Kees Cook wrote:
> > > On Thu, Mar 7, 2019 at 7:40 AM Leon Romanovsky <leonro@mellanox.com> wrote:
> > > >
> > > > On Thu, Mar 07, 2019 at 06:53:54AM -0800, Bart Van Assche wrote:
> > > > > On 3/6/19 11:24 PM, Leon Romanovsky wrote:
> > > > > > My simple patch passes too :).
> > > > >
> > > > > Can you repost your patch?
> > > >
> > > > https://patchwork.kernel.org/patch/10841079/
> > > >
> > > > As Rasmus wrote, the thing is to avoid a < 0 check. In my patch,
> > > > I converted a <= 0 to !(a > 0 || a == 0) expression.
> > >
> > > I'd be happy either way. Is there a larger benefit to having a safe
> > > "is_non_negative()" helper, or should we go with the minimal change to
> > > the shl macro?
> >
> > I personally prefer simplest possible solution.
>
> Acked-by: Kees Cook <keescook@chromium.org>

Thanks

>
> Can this go via the rdma tree?

I think so, Jason advertised that we will have second PR to Linus
this merge window.

Thanks

>
> -Kees
>
> >
> > >
> > > -Kees
> > >
> > > --
> > > Kees Cook
> > -----BEGIN PGP SIGNATURE-----
> >
> > iQIcBAEBAgAGBQJcgU6mAAoJEORje4g2clinE94P/0pHFmUgwzRrVLxjqmnynNPC
> > e+azQISKrZ4EBI5Is7VwFJuxtiZvsTveCxX0NpRxk3TLfHbA4V9jz4meJ6smp4UQ
> > Z1uRnPbj2z5iucFN/8SelQvNTmqfvbuRSKpZ08XLxBB4XIAjFaNBbmD+REe7iSGD
> > xiYNp96oHvKnzGZq/eViqz0rogewsTLHoEBwDkfgyDIqwO0/3qVElNhW7Z6g/v/7
> > 2D4yZiB82wIBf+00taEQNnpI/3naVvqdfl34iYGuq51Fd2S36lfmMZ1DUffd/Eq+
> > jRq8PiNisFK+0A/96hwi2npVN0LS4tA5at6PHhqOfVxMOt/XAmeKu3cCaxHhjbfb
> > Oi2+X9/EBDdgVmylssQFwjNaLuXB00109IVDcQGgzTsN8xoTNiwla8gt3fVhDWt+
> > X0jQuSnqtANt75/0mucirBoUppCB59aZ9ygolWe4UwBpVV0ZGH/0MFwcOhlpglGB
> > PbrKaTxP3qQeil8wGXQsJyPGOCLBGh1Qj0C6NG1wsJSX/Zq8awEoz+JlYCXezaq6
> > 4R0jSHu50BGp7gt5iePRGeUhjPFVGHucJZ2b6fuDZ3ARN8MtQYmrYDyRqnFJZsCE
> > UZFd4SZ8UzfIETd17IowOmOs62HwXyIi1WzoWjiHsNjH2dxwiB6Lh1JBvAFQgzJ1
> > 0wRa0DMnyLzmIoOdyvQm
> > =NFtk
> > -----END PGP SIGNATURE-----
>
>
>
> --
> Kees Cook

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcgVaoAAoJEORje4g2clin1mkP/jb8KmYOHBicEmayoFE3mCoW
tQyvyXfGZNoFcZ0dl8dpuS7cgKG/TIMMjf+syUer1IOzBsBL0OriQHb2p65Xbn0a
i/b+leVAcGe4b6AQCCLgbuDk/lpEvNLW8H3jA3PU5SESa+tdnTowWUJmrm3geyLw
4XPvYzI9wxToDwlUci6vEnqicv0Y8P5tjQ7Incj+J8lrf69snFvoZwpDuaHO4iE0
uDidfdmAVplIhOHpsHCUlJzwRITNLhRlCqPQRSE/+RXDG8mZRVWK8+WD8JwCl3V4
hPA26izmBcJ8buIHL2zhRnB78Zro8Bv0jG23Mz5DtLtLSoBTWGmZ8oQHqavgv5Hw
jYZK7g8N6eKCe4Jf6JfjIFxtIHx+rjGjr4/i7YI3hOo3ohJ6x1Sem2p9oScXB/6j
ajQErde2zOX5hW0uyPwTFVp306K5oqJqemfK6dxD6Xzdir592hzfNYj3o6+bNNeM
Elz5nl6q7JVuMQsKm5wZk4AVGiazR94M7PnxBplO65zO6LCm+qVKMGHZr3VGI5A1
8Q7hFJf2Zz/V0P78lRzJOrH/C8QrIvK45sFhcHCSVnK88wq3CR+97uQRc+VsN6nj
SAi/NCLpM/SSa1078KP2XLnVnoxIvRGQR3YryTyhzfAPJhCCVDRGD0EWfrR4EZKv
thuY4wOJ0b+vviJE3QCp
=xnKU
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
