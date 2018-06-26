From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Tue, 26 Jun 2018 11:54:35 -0600
Message-ID: <20180626175435.GQ5356@mellanox.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 10:07:07AM +0200, Rasmus Villemoes wrote:
>    On 25 June 2018 at 19:11, Jason Gunthorpe <[1]jgg@mellanox.com> wrote:
> 
>      On Mon, Jun 25, 2018 at 11:26:05AM +0200, Rasmus Villemoes wrote:
>      >    check_shift_overflow(a, s, d) {
>      >        unsigned _nbits = 8*sizeof(a);
>      >        typeof(a) _a = (a);
>      >        typeof(s) _s = (s);
>      >        typeof(d) _d = (d);
>      >
>      >        *_d = ((u64)(_a) << (_s & (_nbits-1)));
>      >        _s >= _nbits || (_s > 0 && (_a >> (_nbits - _s -
>      >    is_signed_type(a))) != 0);
>      >    }
>      Those types are not quite right.. What about this?
>          check_shift_overflow(a, s, d) ({
>              unsigned int _nbits = 8*sizeof(d) - is_signed_type(d);
>              typeof(d) _a = a;  // Shift is always performed on type 'd'
>              typeof(s) _s = s;
>              typeof(d) _d = d;
>              *_d = (_a << (_s & (_nbits-1)));
>              (((*_d) >> (_s & (_nbits-1)) != _a);
>          })
> 
>    No, because, the check_*_overflow (and the __builtin_*_overflow
>    cousins) functions must do their job without causing undefined
>    behaviour, regardless of what crazy input values and types they are
>    given.

Okay, I see you are concerned about a UB during shifting signed
values. I didn't consider that..

>    Also, the output must be completely defined for all inputs [1].
>    I omitted it for brevity, but I also wanted a and *d to have the same
>    type, so there should also be one of those (void)(&_a == _d);

Humm. No, that doesn't match the use case. Typically this would take
an ABI constant like a u32 and shift it into a size_t for use with an
allocator. So demanding a and d have equal types is not good, and
requiring user casting is not good as the casting could be truncating.

>    statements. See the other check_*_overflow and the commit adding them.
>    Without the (u64) cast, any signed (and negative) a would cause UB in
>    your suggestion.

When thinking about signed cases.. The explicit u64 cast, and
implict promotion to typeof(d), produce something counter intuitive,
eg:

  (u64)(s32)-1 == 0xffffffffffffffff

Which would result in a shift oucome that is not what anyone would
expect, IMHO... So the first version isn't what I'd expect either..

>    Also, having _nbits be 31 when a (and/or *d) has type
>    int, and then and'ing the shift by 30 doesn't make any sense; I have no
>    idea what you're trying to do.

Yes, it is not helpful to avoid UB when a is signed..

>    [1] For this one, it would probably be most consistent to say that the
>    result is a*2^s computed in infinite-precision, then truncated to fit
>    in d.

I think this does not match the usual use cases, this should strictly
be an unsigned shift. The output is guarenteed to always be positive
or overflow is signaled.

Signed types are alllowed, but negative values are not.

What about more like this?

          check_shift_overflow(a, s, d) ({
	      // Shift is always performed on the machine's largest unsigned
              u64 _a = a;
	      typeof(s) _s = s;
              typeof(d) _d = d;

	      // Make s safe against UB
	      unsigned int _to_shift = _s >= 0 && _s < 8*sizeof(*d) : _s ? 0;

              *_d = (_a << _to_shift);

	       // s is malformed
              (_to_shift != _s ||
	       // d is a signed type and became negative
	       *_d < 0 ||
	       // a is a signed type and was negative
	       _a < 0 ||
	       // Not invertable means a was truncated during shifting
	       (*_d >> _to_shift) != a))
          })

I'm not seeing a UB with this?

Jason
