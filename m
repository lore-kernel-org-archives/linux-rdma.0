From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Tue, 26 Jun 2018 07:16:34 +0300
Message-ID: <20180626041634.GL17747@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sMkrXc3gAYLRVOjR"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625171157.GE5356@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--sMkrXc3gAYLRVOjR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2018 at 11:11:57AM -0600, Jason Gunthorpe wrote:
> On Mon, Jun 25, 2018 at 11:26:05AM +0200, Rasmus Villemoes wrote:
>
> >    check_shift_overflow(a, s, d) {
> >        unsigned _nbits = 8*sizeof(a);
> >        typeof(a) _a = (a);
> >        typeof(s) _s = (s);
> >        typeof(d) _d = (d);
> >
> >        *_d = ((u64)(_a) << (_s & (_nbits-1)));
> >        _s >= _nbits || (_s > 0 && (_a >> (_nbits - _s -
> >    is_signed_type(a))) != 0);
> >    }
>
> Those types are not quite right.. What about this?
>
>     check_shift_overflow(a, s, d) ({
>         unsigned int _nbits = 8*sizeof(d) - is_signed_type(d);
>         typeof(d) _a = a;  // Shift is always performed on type 'd'
>         typeof(s) _s = s;
>         typeof(d) _d = d;
>
>         *_d = (_a << (_s & (_nbits-1)));
>
> 	(((*_d) >> (_s & (_nbits-1)) != _a);
>     })
>
> And can we use mathamatcial invertability to prove no overlow and
> bound _a ? As above.

Rasmus and Jason,

Thanks for the feedback.
The reason why I introduced function, because wanted to reuse
check_mul_overflow macro, but for any reasons which I don't remember
now, I had hard time to fix compilation errors.

Anyway, I'll resubmit.

Thanks


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sMkrXc3gAYLRVOjR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMb4iAAoJEORje4g2clinBKwQAJWn7Dr7LawQOUuHxpIQ3tUx
hNKFM5PC4ekX3MCYddsN+E/DMif8dbZl5q/RIS0AT3u1kICpwv4twliHgJIOKMbk
w0dJ6k+qW9RgOGXvyglHRbX2481p9qh/tV5Wx+/jAzSY4+x0R5JfSl+YjDkSQN9m
nPfiMJzgyAs4uQ5/wGbI19REH8sxTY/wm7s8Dvde2WFFz94ksNwj35i3bpYEve5m
pSO6Z/7xTBRSa07dvC+gkHZU5W+CeyIYeGnW42F+486DGoNM8rCKeSQNXjc52CYy
qyT9G/OpCf/3H9WDVkEDcQ/06b/uM9s/iAUjb34XmLxIfmfWFtHdN6INuOWANQpL
Jiv/RUm1tV0pxE4vG3uUuFhm3Bmd010frtsfkRypqaR/N4EWfh+vBM9bFUbmrBoX
kfZw0Gdhfl7/yYrc4oYj5I54CZIo14vAzuZL9PtBn1V6ns7YyCGSPcZXVjcMgh0F
sWeZ7lLbcD0qrP6BZTOzhKyR28T9V6kSEkMUciBhS8bt0yDp27O0Q3+oXiljNSR5
OWnKOY4pizgr6OMEexh+26aGPM6hBQP1mxCaUKgXTmkB1+JylAbClB6BuD2eXymg
87EAC3j7GK/1RGhOoBKYsYslrJNRMA61dWx3vGtGEm2cAYGw9l0WKnzRZj7KAbTD
RIrR9YPhTQK5zHtf8U8R
=Kso0
-----END PGP SIGNATURE-----

--sMkrXc3gAYLRVOjR--
