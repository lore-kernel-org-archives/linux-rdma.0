From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Tue, 26 Jun 2018 14:37:12 +0300
Message-ID: <20180626113712.GB30877@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2018 at 10:07:07AM +0200, Rasmus Villemoes wrote:
> On 25 June 2018 at 19:11, Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> > On Mon, Jun 25, 2018 at 11:26:05AM +0200, Rasmus Villemoes wrote:
> >
> > >    check_shift_overflow(a, s, d) {
> > >        unsigned _nbits = 8*sizeof(a);
> > >        typeof(a) _a = (a);
> > >        typeof(s) _s = (s);
> > >        typeof(d) _d = (d);
> > >
> > >        *_d = ((u64)(_a) << (_s & (_nbits-1)));
> > >        _s >= _nbits || (_s > 0 && (_a >> (_nbits - _s -
> > >    is_signed_type(a))) != 0);
> > >    }
> >
> > Those types are not quite right.. What about this?
> >
> >     check_shift_overflow(a, s, d) ({
> >         unsigned int _nbits = 8*sizeof(d) - is_signed_type(d);
> >         typeof(d) _a = a;  // Shift is always performed on type 'd'
> >         typeof(s) _s = s;
> >         typeof(d) _d = d;
> >
> >         *_d = (_a << (_s & (_nbits-1)));
> >
> >         (((*_d) >> (_s & (_nbits-1)) != _a);
> >     })
> >
>
> No, because, the check_*_overflow (and the __builtin_*_overflow cousins)
> functions must do their job without causing undefined behaviour, regardless
> of what crazy input values and types they are given. Also, the output must
> be completely defined for all inputs [1]. I omitted it for brevity, but I
> also wanted a and *d to have the same type, so there should also be one of
> those (void)(&_a == _d); statements. See the other check_*_overflow and the
> commit adding them. Without the (u64) cast, any signed (and negative) a
> would cause UB in your suggestion. Also, having _nbits be 31 when a (and/or
> *d) has type int, and then and'ing the shift by 30 doesn't make any sense;
> I have no idea what you're trying to do. I haven't tested the above, but I
> know from when I wrote the other ones that gcc is smart enough not to
> actually do the arithmetic in 64 bits when only <= 32 bit types are
> involved (i.e., gcc sees that the result is anyway implicitly truncated to
> 32 bits, so only bothers to compute the lower 32 bits).
>
> [1] For this one, it would probably be most consistent to say that the
> result is a*2^s computed in infinite-precision, then truncated to fit in d.
> So for too large s, that would just yield 0. But that becomes a bit
> annoying when s is negative; we don't want to start handling a negative
> left shift as a right shift. That's also why I said that one should sit
> down and think about the semantics one really wants, then implement that,
> and write tests. For a first implementation, it might be completely
> reasonable to simply say BUILD_BUG_ON(is_signed_type(a)), but that still
> leaves open what to put in *d when s is negative. But maybe another
> BUILD_BUG_ON(is_signed_type(s)) could handle that, though that's a bit
> annoying for integer literals.
>
> And can we use mathamatcial invertability to prove no overlow and
> > bound _a ? As above.
> >
>
> It's quite possible that the expression determining whether overflow
> occured can be written differently, possibly in terms of shifting back, but
> it definitely needs to return true when s is greater than nbits;
> check_shift_overflow(1U, 32, &d) must be true. And that expression also
> must not involve UB.

Rasmus,

RDMA doesn't really need specific size_t variant, but wants to prevent
shift overflows from users commands, so any true/false function/macro
will work for us.

https://patchwork.kernel.org/patch/10484055/
https://patchwork.kernel.org/patch/10484053/

Thanks

>
> Rasmus

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMiVoAAoJEORje4g2clinyhoP/jvAlHo5XvMqqp4/1XHRIICH
uHGOAJc4GLnbNcjNb2uBjewUlr6+nZw/bXAgDxT9SPj+k5akX+s63LTtUcv5TNZO
DALicgU7GA5bq05M2tXQWyryQ/42635heVQsXP4u9EBiTKshONE8C/wGYCYIRg39
dp4z6tFMV6jKXz0dK72TmhqZ/tY5un6Rl7Gx6uNV6+adU4hqVK/ntWgL6Kr579KL
Sdb4bdaol+hft545MoC4P7P1WS0f1JmY5457lEfk9c9GjCS55ObI47ninBETos81
VhSOoOecbGE9lUcXR2XzqqT4KCyr9bSshcrENSyjlsPZetxIxx2USbVzJkoglhRI
rih8pvc1DQsdxEOd6DcSavUHitHtHZ6YJzMEiFrbfI51l2+nxflBPU3obZAQG5k8
Hd64OSNL5l+WV0CG9cycVkxqqJP6SKDMUMgdMji2vnmd1O8ypv27E7K39Gb0t3tJ
f/nGyE9G7uTzs9zYvW6XN76yQVIUUW+UYjeY4m6OOWkLBv8KAru58nV4nik2uVkb
lqbwwN7q1UxRNw3OrnESGriGkDU5a3qwG9+P6NLV9fepZvVl4VKqcRyOm9Y2l8ch
xZdWc43ySmvRxoDDuz+Fyghre4a6G8yoc88Q62VqSTJ6PuEM0cELUQ8qo2boXGlS
Y9r3CsHYzsjq8G3sdAk5
=25tp
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
