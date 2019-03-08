From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 07:03:02 +0000
Message-ID: <20190308070258.GF32625@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <20190307072428.GJ1789@mtr-leonro.mtl.com>
 <4d90c392-5b6a-fea0-e6cf-c49ac19fdf30@acm.org>
 <20190307154020.GN1789@mtr-leonro.mtl.com>
 <CAGXu5jLBPpKOT-NV1P0nuFeSQYfoNY_8B0V4gcQg18xHPUVbhQ@mail.gmail.com>
 <20190307170230.GR1789@mtr-leonro.mtl.com>
 <CAGXu5jJDmEFA7=WuDnr0U6t9BTDFtd_WsB5HeryNKoZSaBW8oA@mail.gmail.com>
 <926da814-b21d-d01d-d0bb-6304bf545218@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <926da814-b21d-d01d-d0bb-6304bf545218@rasmusvillemoes.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2019 at 09:28:45PM +0100, Rasmus Villemoes wrote:
> On 07/03/2019 18.12, Kees Cook wrote:
> > On Thu, Mar 7, 2019 at 9:02 AM Leon Romanovsky <leonro@mellanox.com> wrote:
> >>
> >> On Thu, Mar 07, 2019 at 08:52:51AM -0800, Kees Cook wrote:
> >>> On Thu, Mar 7, 2019 at 7:40 AM Leon Romanovsky <leonro@mellanox.com> wrote:
> >>>>
> >>>> On Thu, Mar 07, 2019 at 06:53:54AM -0800, Bart Van Assche wrote:
> >>>>> On 3/6/19 11:24 PM, Leon Romanovsky wrote:
> >>>>>> My simple patch passes too :).
> >>>>>
> >>>>> Can you repost your patch?
> >>>>
> >>>> https://patchwork.kernel.org/patch/10841079/
> >>>>
> >>>> As Rasmus wrote, the thing is to avoid a < 0 check. In my patch,
> >>>> I converted a <= 0 to !(a > 0 || a == 0) expression.
> >>>
> >>> I'd be happy either way. Is there a larger benefit to having a safe
> >>> "is_non_negative()" helper, or should we go with the minimal change to
> >>> the shl macro?
> >>
> >> I personally prefer simplest possible solution.
>
> So, I played around with a few variants on godbolt.org, and it seems
> that gcc is smart enough to combine (a > 0 || a == 0) into (a >= 0) - in
> all the cases I tried Leon's patch resulted in the exact same generated
> code as the current version. Conversely, and rather surprising to me,
> Bart's patch seemed to cause worse code generation. So now I've changed
> my mind and also support Leon's version - however, I would _strongly_
> prefer if it introduced
>
> #define is_non_negative(a) (a > 0 || a == 0)
> #define is_negative(a) (!(is_non_negative(a))
>
> with appropriate comments and used that. check_shl_overflow is hard
> enough to read already.

What about if we call them is_normal(a) and is_negative(a)?

Thanks

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcghOiAAoJEORje4g2clin97QQAL6HF9ZSrST2hp50uEBHhn6R
DPczPjlSiClkDkd/khZ5/+50IXlJsZmeVPwnJ9qsfw6y65xD/Wufn498I/5ylgfF
m+yG5oJmt13ejF7XocEr3rRjY3gXCfi8wWYgomjaWyn028ty47xup6eAwFU+LEXA
aKcGm89Xa5HJcHY4KgkBuWT6AXyQjRrmWeQoCqw8hZZoCl0HC4S/8MQw7MTeptT7
xiRJLBrae9eJxnHpvh7myIIU7gU5CJlj88xONKCJ0HqKYEvQT4VH5gYPGvVUXls8
lkqoKhAhEsIhJy7nXQcPsNblTqmaNo1xkICd9rC16pQ5OCe3IPJt2rILdezPdu4w
IPUU0k66+vQod2t7glumpBaMQAZkOFlobadtV7q19H9ZK+cyuRL2F5XIn5gZF6gV
NLkGfO972V1bYcd25S1XJWn5p463u4Q1Jk2GqH+sBj2dKApogJXS/FJ1Q0RhPoTo
Qt4hn285CoFBPYHxEgLp5KRnvArUFP3H40KIm3daDudif4UiaXOHLc+9ebdhMtIA
XVLSEg7K7Kbcf/2fHKGKj8R+6T4C8ErmXxRpw2E0jkfBamdGhRDVoMJJpq+O7c4k
Auwz9jqfrlZafZxOky9KGIGfnkIPZl4/Cyre5ZcTlkuNAVHyUiF5Kc+/REf3dr5q
fQMbtd2nytU79Op65uO+
=wVhp
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
