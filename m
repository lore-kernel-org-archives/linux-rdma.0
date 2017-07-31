From: Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 15:35:37 -0400
Message-ID: <1501529737.1180.1.camel@gmail.com>
References: <20170731065016.2947796-1-arnd@arndb.de>
         <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ@mail.gmail.com>
         <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
         <1501515117.2466.9.camel@wdc.com>
         <CAK8P3a1r22C-Uxs93OSbS4_eRNhKUTv8xwc6wwGahE80whCjyA@mail.gmail.com>
         <1501517853.2466.12.camel@wdc.com>
         <CAK8P3a04DR6NT5jXJSmcw_cDjuKQ-y6f1SQz0cD9Bp=OaoaAhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a04DR6NT5jXJSmcw_cDjuKQ-y6f1SQz0cD9Bp=OaoaAhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "parav@mellanox.com" <parav@mellanox.com>, "monis@mellanox.com" <monis@mellanox.com>, "Michal.Kalderon@cavium.com" <Michal.Kalderon@cavium.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "Ariel.Elior@cavium.com" <Ariel.Elior@cavium.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "dledford@redhat.com" <dledford@redhat.com>, "noaos@mellanox.com" <noaos@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 21:19 +0200, Arnd Bergmann wrote:
> On Mon, Jul 31, 2017 at 6:17 PM, Bart Van Assche <Bart.VanAssche@wdc.c
> om> wrote:
> > On Mon, 2017-07-31 at 18:04 +0200, Arnd Bergmann wrote:
> > > On Mon, Jul 31, 2017 at 5:32 PM, Bart Van Assche <Bart.VanAssche@w
> > > dc.com> wrote:
> > > > So inetaddr_event() assigns AF_INET so .sin_family and gcc warns
> > > > about code
> > > > that is only executed if .sin_family == AF_INET6? Since this
> > > > warning is the
> > > > result of incorrect interprocedural analysis by gcc, shouldn't
> > > > this be
> > > > reported as a bug to the gcc authors?
> > > 
> > > I think the interprocedural analysis here is just a little worse
> > > than it could
> > > be, but it's not actually correct.  It's not gcc that prints the
> > > warning (if
> > > it did, then I'd agree it would be a gcc bug) but the warning is
> > > triggered
> > > intentionally by the fortified version of memcpy in
> > > include/linux/string.h.
> > > 
> > > The problem as I understand it is that gcc cannot guarantee that
> > > it
> > > tracks the value of addr->sa_family at  least as far as the size
> > > of the
> > > stack object, and it has no strict reason to do so, so the inlined
> > > rdma_ip2gid() will still contain both cases.
> > 
> > Hello Arnd,
> > 
> > Had you already considered to uninline the rdma_ip2gid() function?
> 
> Not really, that would prevent the normal optimization from happening,
> so that would be worse than uninlining addr_event() as I tried.
> 
> It would of course get rid of the warning, so if you think that's a
> better
> solution, I won't complain.
> 
>        Arnd

You could also use __memcpy but using a struct assignment seems cleaner.

The compile-time fortify errors aren't perfect since they rely on GCC
being able to optimize them out and there can be dead code that has
intentional overflows, etc. Their purpose is just to move many runtime
errors (which don't have these false positives) to compile-time since
it's a lot less painful to deal with a few false positives like this
than errors slipping through to runtime (although it's less important
since it's going to be using WARN for the time being).

If the compile-time errors would removed, all of the real overflows
would still be detected at runtime. One option would be having something
like #define __NO_FORTIFY but *only* disabling the compile-time part of
the checks to work around false positives. *shrug*
