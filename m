From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 17:37:59 -0400
Message-ID: <1501537079.1180.3.camel@gmail.com>
References: <20170731065016.2947796-1-arnd@arndb.de>
         <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ@mail.gmail.com>
         <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
         <CAGXu5jJ66RY05M=sYZeAMVPEtpneOKyBN2CSNsrewj4EREeu+g@mail.gmail.com>
         <CAK8P3a045_-89OQk+qG7odJ2NeeObq6QaKXccsaC_jOJxfYbfQ@mail.gmail.com>
         <CAGXu5j+EPe7csgFt5SnDoobQWkOGH5qaoSZ=QMHHoGFFsMV45Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+EPe7csgFt5SnDoobQWkOGH5qaoSZ=QMHHoGFFsMV45Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 14:18 -0700, Kees Cook wrote:
> On Mon, Jul 31, 2017 at 2:10 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > On Mon, Jul 31, 2017 at 10:58 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > wrote:
> > > On Mon, Jul 31, 2017 at 12:30 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > > wrote:
> > > > On Mon, Jul 31, 2017 at 9:08 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > wrote:
> > > > > >                 break;
> > > > > >         default:
> > > > > >                 return -EINVAL;
> > > > > 
> > > > > what happens if you replace 16 with sizeof(struct in6_addr)?
> > > > 
> > > > Same thing: the problem is that gcc already knows the size of
> > > > the structure we
> > > > pass in here, and it is in fact shorter.
> > > 
> > > So gcc is ignoring both the cast (to 16 byte struct in6_addr) and
> > > the
> > > caller's actual 128 byte struct sockaddr_storage, and looking only
> > > at
> > > struct sockaddr? That seems really weird.
> > 
> > Using a sockaddr_storage on the stack would address the warning, but
> > the question was about just changing the hardcoded 16 to a sizeof()
> > operation, and that has no effect.
> 
> Right, I didn't mean that; I was curious why the fortify macro
> resulted in an error at all. The callers are casting from struct
> sockaddr_storage (large enough) to struct sockaddr (not large enough),
> and then the inline is casting back to sockaddr_in6 (large enough). I
> would have expected fortify to check either sockaddr_storage or
> sockaddr_in6, but not sockaddr.
> 
> -Kees
> 

I don't think that's quite what's happening. It will report unknown if
it can't find allocation sites or other guarantees of size. There are no
alloc_size markers yet so it *mostly* does stack / global checks. It
won't infer sizes based on pointer types. It's not a heuristic.

Hoowever, fortify / -fsanitize=object-size can indirectly uncover other
forms of undefined behavior though. Code may rely on doing something
undefined that GCC actively assumes can't happen for optimization. It
can have false positives due to dead code with the compile-time errors
but if the code is actually called with the size that it rejects as
invalid, then it's unlikely there isn't a bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
