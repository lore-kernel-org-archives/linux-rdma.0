From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Mon, 25 Jun 2018 11:11:57 -0600
Message-ID: <20180625171157.GE5356@mellanox.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 25, 2018 at 11:26:05AM +0200, Rasmus Villemoes wrote:

>    check_shift_overflow(a, s, d) {
>        unsigned _nbits = 8*sizeof(a);
>        typeof(a) _a = (a);
>        typeof(s) _s = (s);
>        typeof(d) _d = (d);
> 
>        *_d = ((u64)(_a) << (_s & (_nbits-1)));
>        _s >= _nbits || (_s > 0 && (_a >> (_nbits - _s -
>    is_signed_type(a))) != 0);
>    }

Those types are not quite right.. What about this?

    check_shift_overflow(a, s, d) ({
        unsigned int _nbits = 8*sizeof(d) - is_signed_type(d);
        typeof(d) _a = a;  // Shift is always performed on type 'd'
        typeof(s) _s = s;
        typeof(d) _d = d;
 
        *_d = (_a << (_s & (_nbits-1)));

	(((*_d) >> (_s & (_nbits-1)) != _a);
    })

And can we use mathamatcial invertability to prove no overlow and
bound _a ? As above.

Jason
