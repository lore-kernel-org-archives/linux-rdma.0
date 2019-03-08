From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 07:01:10 +0000
Message-ID: <20190308070107.GE32625@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
 <1552003703.45180.17.camel@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552003703.45180.17.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2019 at 04:08:23PM -0800, Bart Van Assche wrote:
> On Thu, 2019-03-07 at 08:18 +0100, Rasmus Villemoes wrote:
> > On 07/03/2019 03.14, Bart Van Assche wrote:
> > > On 3/6/19 5:24 PM, Jason Gunthorpe wrote:
> > > > >
> > > > > diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> > > > > index 40b48e2133cb..8afe0c0ada6f 100644
> > > > > +++ b/include/linux/overflow.h
> > > > > @@ -202,6 +202,24 @@
> > > > >     #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
> > > > >   +/*
> > > > > + * Evaluate a >= 0 without triggering a compiler warning if the type
> > > > > of a
> > > > > + * is an unsigned type.
> > > > > + */
> > > > > +#define is_positive(a) ({                    \
> >
> > is_non_negative, please! positive means > 0. And perhaps it's better to
> > move these utility macros closer to the top of the file, together with
> > the other type/range helpers.
>
> Hi Rasmus,
>
> Thank you for the feedback. But according to what I found online opinions
> about whether or not zero is a positive number seem to vary. From
> https://en.wikipedia.org/wiki/Sign_(mathematics):

Mathematical therm for discrete numbers greater or equal to zero is
"normal numbers".

Thanks

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcghMzAAoJEORje4g2clin3fEP/Ryga+qaXDVG2UegGY8K4NRl
Rl+/Rgpm2r5QFXi3BJnOE2DLn+2NH0W9hDptOy4STRSyU7C7iCFmm2MaDqJ7itaR
kdgy+iv4SSCLgaTsrYMWvnBM/qudXKPTzXOho6twu0j69vOD4dU/TxJNnTFY8nyD
yR96MKRINbSMQYtCTVp8pUryM7pULdJ0joPg1R5mcJm7NlyennADb8YMDEfXWuCd
O9RPvnI8gno1SqYcEdfHcnCzpOYT02kQyQ4E1ZQy/g7DA3n8G76S4ZqiFkai6vZ7
IZYc5WEYfTCcF1U4sv9rXzaPAChMTdLgxJeG79+ssZKkiNhWsXxlZpnqfh16ZyP9
tAhxJQ1bv012YM/0VlHWtp4/PI0NLb/VMl0LsoKrFdPMnXS9OrhejBP7LzUt0uCC
5gFp5gtBiT5Uvqy8m5FyBQnPAkX5N9TXyT9bZzdWUhynH1btet6HwqGYsDi8G9UA
GQ2345fynt4Bprjmc6yXCioyvWUsRJOg/+ZypYxwvl9DBTk7zijcPHSl8bpaIqnU
XX/zdmXm90EmZQuZykImwDrNDOYe6hdSa9MOmdqNoILP73VMapHY0Ko6+gCFpUsI
FB48nRuEEJDPKDTmZiIUDf/8tti5vr0BZ1Lp/OOX4SNKQ93b3wT2X+cpj3WLCoOJ
DoBkwhO/gFlbSr1w9ltz
=9dvA
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
