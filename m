From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Tue, 26 Jun 2018 07:24:05 +0300
Message-ID: <20180626042405.GN17747@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MdEjg5WkSuUg8x46"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--MdEjg5WkSuUg8x46
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2018 at 11:26:05AM +0200, Rasmus Villemoes wrote:
> On 24 June 2018 at 10:23, Leon Romanovsky <leon@kernel.org> wrote:
>
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Add shift_overflow() helper to help driver authors to ensure that
> > shift operand doesn't cause to overflow, which is very common pattern
> > for RDMA drivers.
> >
>
> Not a huge fan. The other _overflow functions have a different behaviour
> (in how they return the result and the overflow status) and are
> type-generic, and I think someone at some point will use such a
> generically-named helper for stuff other than size_t. At least the
> array_size and struct_size helpers have size in their name and are
> specifically about computing the size of something, and are designed to be
> used directly as arguments to allocators, where SIZE_MAX is a suitable
> sentinel. I can't see the other patches in this series, so I don't know how
> you plan on using it, but it should also be usable outside rdma.
>
> Aside: why does b have type size_t?
>
> Does __must_check really make sense for a function without side effects? It
> doesn't tell gcc to warn if the result is not used in a conditional, it
> just warns if the result is not used at all, which wouldn't realistically
> happen for a pure function.
>
> I'd much rather see a type-generic check_shift_overflow (we can agree to
> leave "left" out of the name) with semantics similar to the other
> check_*_overflow functions. Then, if a size_t-eating, SIZE_MAX-returning
> helper is more convenient for rdma, that should be easy to implement on top
> of that. It shouldn't really be that hard to do. Something like
>
> check_shift_overflow(a, s, d) {
>     unsigned _nbits = 8*sizeof(a);
>     typeof(a) _a = (a);
>     typeof(s) _s = (s);
>     typeof(d) _d = (d);
>
>     *_d = ((u64)(_a) << (_s & (_nbits-1)));
>
>     _s >= _nbits || (_s > 0 && (_a >> (_nbits - _s - is_signed_type(a))) !=
> 0);
> }
>
> which should also handle shifts of signed types (though it allows << 0 for
> negative values; that's easy to also disallow). But the exact semantics
> should be documented via a bunch of tests (hint hint) exercising corner
> cases.

I'll respin.

Thanks for the feedback.

>
> Rasmus

--MdEjg5WkSuUg8x46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMb/lAAoJEORje4g2clinA0UP/1wEsqeZqLyxrMn+BKXOTs8R
QuEQ/Bwcwq9tEEt5dl51NFAqliFIifh6+fdghet0gAo2G/uKxbrIyd/WR3NQVvp/
8W65VA9Ms1LJHUi8Gx/IloaocXvjlKXK1cqlj4l3VNqxU+7xQ3c51kspih+ND4qW
aMHk9xK2fzk05vOtuwDtyCxNNPKSTz4et11MdMet2t8z6fAIvYD+zfLtfSq/wbRA
PYYVa3mFxygrc+NWyKWdlchJEOpAnzCXC6Llu9nyxUrhdZnKcsLAT1fM7LQDnBrH
zyfqbiUCv7XnkKaG/pkcT2+qC1YqLc/BXjtfjMwUN4FZWDyh1UhTdtDxnGugG8FD
RhZade6sabLvC1V8NJKgaoHD8L6E/Fk8FpB1ep+CYNydJgcW6YED0myNt2jcFNW1
t/cpX0D7hm5wz+HWQ7qj7aF/yt66lwCwEqlqf1lpEUAXXusd+b8k6hFJahgT8BPd
fqkAwHE6Dv2DBfSdiErDSIYMBtH6ZMHw4o8bfsmfrO94VZN3wIlcWYkIkhqV6WD4
jBDSN/3IHBbETzsBmYLgtIvX/Vo2SlfGepIsR7zRj/fX93gy4xzmOLTFMc0cbJEV
xWY/x6VYTsE5/8sqZ12ecfpk5VLc2v3zNXe1K3SlPnOdfTC4zoX4+dLsVfk2Pyvw
3ZD3bb24h3h1zWKSUJqD
=ySnk
-----END PGP SIGNATURE-----

--MdEjg5WkSuUg8x46--
