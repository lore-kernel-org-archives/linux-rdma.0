From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 14:39:13 -1000
Message-ID: <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com> <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca> <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca> <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org> <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com> <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <1522186396.7364.61.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522186396.7364.61.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 11:33 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Well, we need to clarify that once and for all, because as I wrote
> earlier, it was decreed by Linus more than a decade ago that writel
> would be fully ordered by itself vs. previous memory stores (at least
> on UC memory).

Yes.

So "writel()" needs to be ordered with respect to other writel() uses
on the same thread. Anything else *will* break drivers. Obviously, the
drivers may then do magic to say "do write combining etc", but that
magic will be architecture-specific.

The other issue is that "writel()" needs to be ordered wrt other CPU's
doing "writel()" if those writel's are in a spinlocked region.

So it's not  that "writel()" needs to be ordered wrt the spinlock
itself, but you *do* need to honor ordering if you have something like
this:

   spin_lock(&somelock);
   writel(a);
   writel(b);
   spin_unlock(&somelock);

and if two CPU's run the above code "at the same time", then the
*ONLY* acceptable sequence is abab.

You cannot, and must not, ever see "aabb" at the device, for example,
because of how the writel would basically leak out of the spinlock.

That sounds "obvious", but dammit, a lot of architectures got that
wrong, afaik.

                Linus
