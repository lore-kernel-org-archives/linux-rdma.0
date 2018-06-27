From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Wed, 27 Jun 2018 20:39:11 +0300
Message-ID: <20180627173911.GS30877@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
 <20180626175435.GQ5356@mellanox.com>
 <CAKwiHFgchr+6HYOZ4e4e1vzL9cFabe6eonNNM8NTWZypazcuKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwiHFgchr+6HYOZ4e4e1vzL9cFabe6eonNNM8NTWZypazcuKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 27, 2018 at 11:36:03AM +0200, Rasmus Villemoes wrote:
> On 26 June 2018 at 19:54, Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> > On Tue, Jun 26, 2018 at 10:07:07AM +0200, Rasmus Villemoes wrote:
> > >    On 25 June 2018 at 19:11, Jason Gunthorpe <[1]jgg@mellanox.com>
> > wrote:
> > >
> >
> > When thinking about signed cases.. The explicit u64 cast, and
> > implict promotion to typeof(d), produce something counter intuitive,
> > eg:
> >
> >   (u64)(s32)-1 == 0xffffffffffffffff
> >
> > Which would result in a shift oucome that is not what anyone would
> > expect, IMHO... So the first version isn't what I'd expect either..
> >
>
> Wouldn't check_shift_overflow(-1, 4, &someint) just put -16 in someint and
> report no overflow? That's what I'd expect, if negative values are to be
> supported at all.

Most if not all the times we don't do shifts on negative values, so I
don't think that we should support them.

Thanks

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbM8u/AAoJEORje4g2clink0cP/jiV+QHPOXCNak2/1uDE3ugE
f5JtCuus5clIWuNmzOKPrTuWIsaCRgqz7jwiyjUTRlbU0+c4JPQRaB27Rht2mzT1
YqVAVSUj3EW4Fxkxm5Fj38MRs+2z9DScpx+WxNkKeJ1+woqnaYerddCihRiaGM9l
dC0WlPbrDcT70DGHga2zIUKZd6COHcRbtZM5DgmsOtleVxM+4mTYsELwtgZFd1xT
NE0Uux83Xut0tnwolvnN3M6VsBSJuwY/rC/Mzyx7YXlNOzNCJxQx8YSORa7eD2Fb
Gn//gZvk4XQb45+dNrMNHELOd7z9TXmpddY6KZBgbo0PK5hexiKNfOyZb6fgLnlS
TmSa8qTj3EKMLaDTZXNqx3dkWnKv8PwGQ5F/19n4T+6/If7dRRrRZ/TgpFaDZQE7
yFVBQsY0t4HH105UYx4Pog1oMK8KvOWF8ZkAc5iuh0HfgZjfqDjzNtF8px1+ri0F
69tZ4tPkSF4imFB7n3f4RTA+dB/A/r0Z9FO0MIDxIteIj8x6MuEo+QnHNMdS4RG+
xphjQ3S4ZtZE9JlPdPzSRA02rbjvkK6KBNFm+QdQy0venKn1WajyN4qXGwEsfJGe
ISvTO5q1ck16wFLOW/A5l4BYXg07My3kEnf87PTYtkmD8TcjwkYKh01Lf15xhbEy
f3YosVgvAUwJV3KzBurG
=r7+A
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
