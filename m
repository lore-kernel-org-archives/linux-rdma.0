From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Wed, 27 Jun 2018 11:44:23 -0700
Message-ID: <CAGXu5jL-_o0mQGzWoOg5VHj0sUfrkDH-yrOg0A3BxQRe+VRmDw@mail.gmail.com>
References: <20180624082353.16138-1-leon@kernel.org> <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com> <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
 <20180626175435.GQ5356@mellanox.com> <CAKwiHFgchr+6HYOZ4e4e1vzL9cFabe6eonNNM8NTWZypazcuKA@mail.gmail.com>
 <20180627181012.GM20754@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627181012.GM20754@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 27, 2018 at 11:10 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> Leon? Seems like agreement, Can you work with this version?
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
>         ({                                                                     \
>                 typeof(a) _a = a;                                              \
>                 typeof(s) _s = s;                                              \
>                 typeof(d) _d = d;                                              \
>                 u64 _a_full = _a;                                              \
>                 unsigned int _to_shift =                                       \
>                         _s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;               \
>                                                                                \
>                 *_d = (_a_full << _to_shift);                                  \
>                                                                                \
>                 (_to_shift != _s || *_d < 0 || _a < 0 ||                       \
>                  (*_d >> _to_shift) != a);                                     \
>         })
>
> int main(int argc, const char *argv[])
> {
>         int32_t s32;
>         uint32_t u32;
>
>         assert(check_shift_overflow(1, 0, &s32) == false && s32 == (1 << 0));
>         assert(check_shift_overflow(1, 1, &s32) == false && s32 == (1 << 1));
>         assert(check_shift_overflow(1, 30, &s32) == false && s32 == (1 << 30));
>         assert(check_shift_overflow(1, 31, &s32) == true);
>         assert(check_shift_overflow(1, 32, &s32) == true);
>         assert(check_shift_overflow(-1, 1, &s32) == true);
>         assert(check_shift_overflow(-1, 0, &s32) == true);
>
>         assert(check_shift_overflow(1, 0, &u32) == false && u32 == (1 << 0));
>         assert(check_shift_overflow(1, 1, &u32) == false && u32 == (1 << 1));
>         assert(check_shift_overflow(1, 30, &u32) == false && u32 == (1 << 30));
>         assert(check_shift_overflow(1, 31, &u32) == false && u32 == (1UL << 31));
>         assert(check_shift_overflow(1, 32, &u32) == true);
>         assert(check_shift_overflow(-1, 1, &u32) == true);
>         assert(check_shift_overflow(-1, 0, &u32) == true);
>
>         assert(check_shift_overflow(0xFFFFFFFF, 0, &u32) == false && u32 == (0xFFFFFFFFUL << 0));
>         assert(check_shift_overflow(0xFFFFFFFF, 1, &u32) == true);
>         assert(check_shift_overflow(0xFFFFFFFF, 0, &s32) == true);
>         assert(check_shift_overflow(0xFFFFFFFF, 1, &s32) == true);
> }

Oh yes, please include these tests in lib/test_overflow.c too! Nice. :)

-Kees

-- 
Kees Cook
Pixel Security
