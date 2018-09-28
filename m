From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 17:55:43 -0700
Message-ID: <CAKwvOd=9AjrKu52bEvdgsZ_eK8uwiqRjgMHz3j069Q+w97FO2A@mail.gmail.com>
References: <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
 <20180925023722.GA32600@ziepe.ca> <20180927010803.GA7640@flashbox>
 <20180927044826.GC24889@ziepe.ca> <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
 <20180927202849.GA11120@flashbox> <CAKwvOdnMOcdKPNHwKbcsg8rJX3_hDTgY752Nb4hgMC2D4p5aRg@mail.gmail.com>
 <20180927222821.GC28301@ziepe.ca> <1538087622.226558.8.camel@acm.org>
 <CAKwvOd=qNZsfSFJUFZqBbSYt4T_T7TudohzhTqpigvDAHek78A@mail.gmail.com> <20180927225823.GD28301@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927225823.GD28301@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca
Cc: bvanassche@acm.org, Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 3:58 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Sep 27, 2018 at 03:42:24PM -0700, Nick Desaulniers wrote:
> > On Thu, Sep 27, 2018 at 3:33 PM Bart Van Assche <bvanassche@acm.org> wrote:
> > >
> > > On Thu, 2018-09-27 at 16:28 -0600, Jason Gunthorpe wrote:
> > > > On Thu, Sep 27, 2018 at 01:34:16PM -0700, Nick Desaulniers wrote:
> > > >
> > > > > > Neither ib_qp_create_flags nor mlx4_ib_qp_flags have negative values, is
> > > > > > signedness necessary?
> > > > >
> > > > > enums are by default restricted to the range of ints.
> > > >
> > > > That's not quite right, the compiler sizes the enum to be able to fit
> > > > the largest value contained within, today that is int, but if we added
> > > > 1<<31, then it would become larger.
> > >
> > > Hi Jason,
> > >
> > > Are you perhaps confusing C and C++? For C++, an enumeration whose underlying
> > > type is not fixed, the underlying type is an integral type that can represent
> > > all the enumerator values defined in the enumeration. For C however I think
> > > that enumeration values are restricted to what fits in an int.
> > >
> > > Bart.
> > >
> >
> > To quote the sacred texts (ANSIIISO9899-1990):
>
> > 6.5.2.2 Enumeration specifiers
> > The expression that defines the value of an enumeration constant shall
> > be an integral constant
> > expression that has a value representable as an int.
>
> This is the wrong part of the standard to quote it is talking about
> *enumeration constants* not the 'enum X' itself.
>
> Anyhow, the standard is hard to read in this area, but reality is
> this:

You mean undefined behavior?

>
> #include <stdio.h>
>
> enum a
> {
>         A1 = 1,
>         A2 = 1ULL<<40,
> };
>
> int main(int argc, const char *argv[])
> {
>         printf("%zu\n", sizeof(enum a));
>         return 0;
> }
>
> $ gcc -Wall -std=c11 test.c && ./a.out
> 8
>
> I forget if this a common compiler extension, unclear standard, or was
> formally revised in C11 or what, but it is the real world the Linux
> kernel lives in.
>
> It is even more confusing if you wonder what types A1 and A2 are!
>
> Jason

This example is a strawman; we're talking about the minimum sizeof an
enum when all initialized values are representable within an int,
which is well defined behavior by the citation I cited earlier.  The
point is, unless you use __attribute__((packed)) on your enum, it will
NEVER be *smaller* than an int for compilers and C standard that the
Linux kernel cares about.

And if you're going to throw type safety out the window by converting
values from one enum to another, for storage you MUST use an int
(anything larger as in your example is undefined behavior).

I don't disagree with your point that values should be unsigned for
bitwise operations, but it's not clean to reconcile that with
converting values between different enums.  I suggest explicit casts
to unsigned types before bitwise operations.

https://wiki.sei.cmu.edu/confluence/display/c/INT13-C.+Use+bitwise+operators+only+on+unsigned+operands
-- 
Thanks,
~Nick Desaulniers
