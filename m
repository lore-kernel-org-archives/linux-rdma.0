From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 15:53:22 +0000
Message-ID: <20190308155318.GG32625@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
 <1552003703.45180.17.camel@acm.org>
 <20190308070107.GE32625@mtr-leonro.mtl.com>
 <ca0d8714-3258-3155-247c-af2d63c28273@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ca0d8714-3258-3155-247c-af2d63c28273@rasmusvillemoes.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2019 at 09:09:46AM +0100, Rasmus Villemoes wrote:
> On 08/03/2019 08.01, Leon Romanovsky wrote:
> >
> > Mathematical therm for discrete numbers greater or equal to zero is
> > "normal numbers".
>
> Sorry, WHAT? "Normal" is used and abused for a lot of things in
> mathematics, but I have never heard it used that way. When attached to
> the word "number", it means a real number with certain properties
> related to its digit expansion(s). And then of course there's the
> isnormal() thing for floating point values in C/computing.

It is hard to argue with this type of arguments: "never heard -> doesn't
exist". Luckily enough for me who can't find my fifth grade textbook
=66rom school, we have Wikipedia which has pointer to ISO standard with
clear declaration of "normal numbers" as 0,1,2, ....

https://en.wikipedia.org/wiki/Natural_number#cite_note-ISO80000-1
 "Standard number sets and intervals". ISO 80000-2:2009. International
 Organization for Standardization. p. 6.

>
> Strong NAK to using is_normal/is_negative.
>
> Rasmus
>
>

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcgo/uAAoJEORje4g2clind/0QAJOqxgxotPh9GL4ZtVmTw7z2
f34auUTr+b0kOf75wVidwT3vKwj7t8AusO2TWB+vUflWEB7GPxU0GH8/RowS19eK
3ErShQkPUoPjfVMf563twCh9GVigffWl513t/6/Gf2YghA+T8iMTZywVAqIIUPgU
a/Nl5/OzKLbbkzQez06NVFLf0sOalas8H601HWdZ5SeilmH4+1JXqGw8LQVrsElX
OByYOag9kAESwN+PrWReoSDb2hbLbVh1Fag/c9PG4ZG/7SMOzvWUxDxH8Uh2MGlk
5MpOR3HXR4F5sZi79KtrQ8vQoj8jfNLaQuwgbJKRgqmBREBbbSrsQndah5nzX8lS
lmZW2lThKBy/CnHMIYkqD2WdqnRA32Jy0AhVHNoXoYZGda5AExjSVzJ2X61kkGct
4hYveN/ZuUXBjlpD1FmU/CgbAlGWy6DGA3K8shFGrpc17qWPTt1X8N4//k/mAsvw
BIH4oeo8NXtFMGnqTCRmtRzGD9RWgDiInXq93J2yyeVRhXXUln5c9LO9VgCD/Q2h
SpIR/Z3zAObPU0q3rZkLK+AZ0V2cdoVbMQQRcfz2fRQmYCqi3ubS871f94PEaR+N
O0TdmGgRgaF4zsjXd7OWzdooWo0OdAoS8c6fVuY8P1xwy8oiZSIEE9x7HMkxt9Pj
KLbvewlWk9H6zZZttcIF
=Kvh+
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
