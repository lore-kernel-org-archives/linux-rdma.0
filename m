From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Sat, 15 Dec 2018 12:56:07 -0800
Message-ID: <CABeXuvr7je=LG9+xO286b7HH2WNLSfoOL4V6nN0AkjsGr_SoCQ@mail.gmail.com>
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
To: willemdebruijn.kernel@gmail.com
Cc: "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Network Devel Mailing List <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, rth@twiddle.net, linux-alpha@vger.kernel.org, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

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
>
> I think we can use the same helper for both the sock and tcp variant.
> The only intended difference between the two functions, as described
> in the tcp_recv_timestamp function comment, is the absence of an skb
> in the tcp case. That is immaterial at this level.

I will just not refactor things into a function: __sock_rescv_timestamp_new().
I will just add new conditionals for the new timestamps.
When you guys refactor the other timestamp stuff like you mentioned
below maybe you can move the new timestamps to a new funtcion as you
see fit.

The helper functions in skbuff.h might first need to be refactored
first. But I again leave this to you guys.

> Note also (2) tentative helper function sock_uses_new_tstamp(const
> struct sock *sk) instead of testing sock_flag(sk, SOCK_TSTAMP_NEW)
> directly. Since the .._NEW variants are equivalent to .._OLD on 64-bit,
> I wonder if we can just compile out the branch. Something like
>
>     static inline bool sock_uses_new_tstamp(const struct sock *sk) {
>             return (sizeof(time_t) != sizeof(__kernel_long_t)) &&
>                        sock_flag(sk, SOCK_TSTAMP_NEW);
>     }
>

You could just ifdef CONFIG_64BIT if you are worried about branching.
Note that SO_TIMESTAMP is by default SO_TIMESTAMP_OLD on 64 bit machines.
But, I will again leave the optimization to you. I will implement in a
straight forward way and you guys can deicde how you want to optimize
the fast path or what should it even be.

-Deepa
