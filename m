From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Wed, 27 Jun 2018 21:22:20 +0300
Message-ID: <20180627182220.GV30877@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
 <20180626175435.GQ5356@mellanox.com>
 <CAKwiHFgchr+6HYOZ4e4e1vzL9cFabe6eonNNM8NTWZypazcuKA@mail.gmail.com>
 <20180627181012.GM20754@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180627181012.GM20754@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 27, 2018 at 12:10:12PM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 27, 2018 at 11:36:03AM +0200, Rasmus Villemoes wrote:
> >    OK. The requirement of everything having the same type for the
> >    check_*_overflow when gccs builtins are not available was mostly a
> >    consequence of my inability to implement completely type-generic
> >    versions (but also to enforce some sanity, so people don't do
> >    check_add_overflow( s8, size_t, int*)). There's no gcc builtin for
> >    shift, but if it's relatively simple to one allowing a and *d to have
> >    different types, then why not. It's of course particularly convenient
> >    to allow a bare "1" (i.e. int) as a while having *d have some random
> >    type.
>
> Yes
>
> >    Wouldn't check_shift_overflow(-1, 4, &someint) just put -16 in someint
> >    and report no overflow? That's what I'd expect, if negative values are
> >    to be supported at all.
>
> I would say that is not a desired outcome, bitshift is defined on
> bits, if the caller wanted something defined as signed multiply they
> should use multiply.
>
> IMHO, nobody writes 'a << b' expecting sign preservation..
>
> >    Well, the types you can check at compile-time, the values not, so you
> >    still have to define the result, i.e. contents of *d, for negative
> >    values (even if we decide that "overflow" should always be signalled in
> >    that case).
>
> Why do a need to define a 'result' beyond whatever the not-undefined
> behavior shift expression produces?
>
> >      What about more like this?
> >                check_shift_overflow(a, s, d) ({
> >                    // Shift is always performed on the machine's largest
> >      unsigned
> >                    u64 _a = a;
> >                    typeof(s) _s = s;
> >                    typeof(d) _d = d;
> >                    // Make s safe against UB
> >                    unsigned int _to_shift = _s >= 0 && _s < 8*sizeof(*d) : _s ? 0;
> >                    *_d = (_a << _to_shift);
> >                     // s is malformed
> >                    (_to_shift != _s ||
> >                     // d is a signed type and became negative
> >                     *_d < 0 ||
> >                     // a is a signed type and was negative
> >                     _a < 0 ||
> >                     // Not invertable means a was truncated during
> >      shifting
> >                     (*_d >> _to_shift) != a))
> >                })
> >      I'm not seeing a UB with this?
> >
> >    Something like that might work, but you're not there yet. In
> >    particular, your test for whether a is negative is thwarted by using
> >    u64 for _a and testing _a < 0...
>
> Oops, yes that was intended to be 'a', and of course we need to
> capture it..
>
> Leon? Seems like agreement, Can you work with this version?

Yes, sure, I waited for an agreement.

>
> #include <stdint.h>
> #include <stdbool.h>
> #include <assert.h>
>
> #define u64 uint64_t
>
> /*
>  * Compute *d = (a << s)
>  *
>  * Returns true if '*d' cannot hold the result or 'a << s' doesn't make sense.
>  * - 'a << s' causes bits to be lost when stored in d
>  * - 's' is garbage (eg negative) or so large that a << s is guarenteed to be 0
>  * - 'a' is negative
>  * - 'a << s' sets the sign bit, if any, in '*d'
>  * *d is not defined if false is returned.
>  */
> #define check_shift_overflow(a, s, d)                                          \
> 	({                                                                     \
> 		typeof(a) _a = a;                                              \
> 		typeof(s) _s = s;                                              \
> 		typeof(d) _d = d;                                              \
> 		u64 _a_full = _a;                                              \
> 		unsigned int _to_shift =                                       \
> 			_s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;               \
>                                                                                \
> 		*_d = (_a_full << _to_shift);                                  \
>                                                                                \
> 		(_to_shift != _s || *_d < 0 || _a < 0 ||                       \
> 		 (*_d >> _to_shift) != a);                                     \
> 	})
>
> int main(int argc, const char *argv[])
> {
> 	int32_t s32;
> 	uint32_t u32;
>
> 	assert(check_shift_overflow(1, 0, &s32) == false && s32 == (1 << 0));
> 	assert(check_shift_overflow(1, 1, &s32) == false && s32 == (1 << 1));
> 	assert(check_shift_overflow(1, 30, &s32) == false && s32 == (1 << 30));
> 	assert(check_shift_overflow(1, 31, &s32) == true);
> 	assert(check_shift_overflow(1, 32, &s32) == true);
> 	assert(check_shift_overflow(-1, 1, &s32) == true);
> 	assert(check_shift_overflow(-1, 0, &s32) == true);
>
> 	assert(check_shift_overflow(1, 0, &u32) == false && u32 == (1 << 0));
> 	assert(check_shift_overflow(1, 1, &u32) == false && u32 == (1 << 1));
> 	assert(check_shift_overflow(1, 30, &u32) == false && u32 == (1 << 30));
> 	assert(check_shift_overflow(1, 31, &u32) == false && u32 == (1UL << 31));
> 	assert(check_shift_overflow(1, 32, &u32) == true);
> 	assert(check_shift_overflow(-1, 1, &u32) == true);
> 	assert(check_shift_overflow(-1, 0, &u32) == true);
>
> 	assert(check_shift_overflow(0xFFFFFFFF, 0, &u32) == false && u32 == (0xFFFFFFFFUL << 0));
> 	assert(check_shift_overflow(0xFFFFFFFF, 1, &u32) == true);
> 	assert(check_shift_overflow(0xFFFFFFFF, 0, &s32) == true);
> 	assert(check_shift_overflow(0xFFFFFFFF, 1, &s32) == true);
> }
>
> Thanks,
> Jason
