From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Tue, 18 Dec 2018 17:33:11 +0100
Message-ID: <CAK8P3a0PFQCqo2Ofce7uJeWAgssMbh8u1CNWeAmUk9LzQRn35g@mail.gmail.com>
References: <20181211202520.16799-1-deepa.kernel@gmail.com>
 <20181211202520.16799-7-deepa.kernel@gmail.com> <CAF=yD-LDWrjxK+XFv-KNAoyP7NCOZiL00n5PkzQ-5aEzq+eCLQ@mail.gmail.com>
 <CABeXuvpAZfd6gAdJbKxsOowXnDnwyQQRuYMJ-6LDo9BsRDDj-g@mail.gmail.com>
 <CAF=yD-L4xTU-KXsQ=uU36fEKv5St=69mmKqT8sD1mAmT_hfuVQ@mail.gmail.com>
 <CABeXuvqrZgEDF5RYQEPJ8RyXDg0uvXx_qMq=2ER8Bc9RXFPDGQ@mail.gmail.com> <CAF=yD-KFYdXRgL-HpAJLLHuywMcaBGfz7sDL35DBNs0hoq+zxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF=yD-KFYdXRgL-HpAJLLHuywMcaBGfz7sDL35DBNs0hoq+zxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, David Miller <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 15, 2018 at 7:52 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > 3 reasons for not doing this:
> >
> > 1. We do not want to break userspace. If we move this to
> > linux/socket.h all the userspace programs now have to include
> > linux/socket.h or get this definition through a new libc.
> > 2. All the socket options are together in the file asm/socket.h. It
> > doesn't seem good for maintainability to move just a few bits
> > elsewhere.
> > 3. There are only 4 arches (after the series is applied) that have
> > their own asm/socket.h. And, this is because there seems to be
> > significant differences to asm-generic/socket.h that don't seem
> > logically obvious to group and eliminate some of the defines.
>
> Agreed. All good reasons to leave as is.
>
> > Also for the other comment. The reason the conditionals were not
> > consistent is because they were not consistent to begin with.
>
> The only difference I see is an inversion of the test. Nesting order
> is the same:
>
>         int need_software_tstamp = sock_flag(sk, SOCK_RCVTSTAMP);
>         ...
>         if (need_software_tstamp) {
>                 if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
>                 } else {
>                 }
>         }
>
> vs
>
>                 if (sock_flag(sk, SOCK_RCVTSTAMP)) {
>                         if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
>                         } else {
>                         }
>                 }
>
> I suggest just adding something like
>
>         if (need_software_tstamp) {
> +              if (sock_uses_new_tstamp(sk) {
> +                   __sock_recv_timestamp_new(msg, sk,
> ktime_to_timespec64(skb->tstamp));
> +              } else if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> -               if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
>                 } else {
>                 }
>
> and
>
>                 if (sock_flag(sk, SOCK_RCVTSTAMP)) {
> +                      if (sock_uses_new_tstamp(sk) {
> +                           __sock_recv_timestamp_new(msg, sk, ts);
> +                      else if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> -                       if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
>                         } else {
>                         }

Generally speaking, I think we want the new time handling
to be written as the default case rather than have it hidden away
in a separate function. If we didn't have the sparc64 quirk with its
unusual timeval definition, we'd only need a special flag for the
old 32-bit format, but that doesn't work as long we have to support
two different 64-bit formats for 64-bit timeval on sparc64
(32 or 64 bit microseconds).

> Note also (2) tentative helper function sock_uses_new_tstamp(const
> struct sock *sk) instead of testing sock_flag(sk, SOCK_TSTAMP_NEW)
> directly. Since the .._NEW variants are equivalent to .._OLD on 64-bit,
> I wonder if we can just compile out the branch. Something like
>
>     static inline bool sock_uses_new_tstamp(const struct sock *sk) {
>             return (sizeof(time_t) != sizeof(__kernel_long_t)) &&
>                        sock_flag(sk, SOCK_TSTAMP_NEW);
>     }

I think that would break compat handling: when we have a 32-bit
user space process, the difference between old and new timestamps
is meaningful even on 64-bit kernels, but the distinction is only made all
the way down in put_cmsg_compat().

      Arnd
