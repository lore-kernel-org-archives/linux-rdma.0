From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Wed, 1 Aug 2018 10:14:31 -0600
Message-ID: <20180801161431.GC10665@mellanox.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
 <20180626175435.GQ5356@mellanox.com>
 <20180801093603.GI2530@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801093603.GI2530@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 01, 2018 at 11:36:03AM +0200, Peter Zijlstra wrote:
> On Tue, Jun 26, 2018 at 11:54:35AM -0600, Jason Gunthorpe wrote:
> 
> > What about more like this?
> > 
> >           check_shift_overflow(a, s, d) ({
> 
> Should that not be: check_shl_overflow() ? Just 'shift' lacks a
> direction.

Yes, that makes sense.

> > 	      // Shift is always performed on the machine's largest unsigned
> >               u64 _a = a;
> > 	      typeof(s) _s = s;
> >               typeof(d) _d = d;
> > 
> > 	      // Make s safe against UB
> > 	      unsigned int _to_shift = _s >= 0 && _s < 8*sizeof(*d) : _s ? 0;
> 
> Should we not do a gcc-plugin or something that fixes that particular
> UB? Shift acting all retarded like that is just annoying. I feel we
> should eliminate UBs from the language where possible, like
> -fno-strict-overflow mandates 2s complement.

No idea, if someone does this they can remove the above overhead..

> >               *_d = (_a << _to_shift);
> > 
> > 	       // s is malformed
> >               (_to_shift != _s ||
> 
> Not strictly an overflow though, just not expected behaviour.

'overflow' here means the math didn't work, ie
   C = A << B
has a C that does not match A << B done on infinite precision. It is
not limited to checking overflow.

> > 	       // d is a signed type and became negative
> > 	       *_d < 0 ||
> 
> Only a problem if it wasn't negative to start out with.

> > 	       // a is a signed type and was negative
> > 	       _a < 0 ||
>
> Why would that be a problem? You can shift left negative values just
> fine. The only problem is when you run out of sign bits.

These are both a problem because of how the macro is setup, nobody had
an idea how to make this work with different types and allow for
negatives to work properly.

You could define this, but since there is no usecase..

> > 	       // Not invertable means a was truncated during shifting
> > 	       (*_d >> _to_shift) != a))
> >           })
> 
> And I'm not exactly seeing the use case for this macro. What's the point
> of a shift-left if you cannot truncate bits. I suppose it's in the name
> _overflow, but still.

It is basically a specialized case of check_mul_overflow where the
multiply is known to be a power of 2.

Jason
