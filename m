From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Sat, 15 Dec 2018 13:51:31 -0500
Message-ID: <CAF=yD-KFYdXRgL-HpAJLLHuywMcaBGfz7sDL35DBNs0hoq+zxQ@mail.gmail.com>
References: <20181211202520.16799-1-deepa.kernel@gmail.com>
 <20181211202520.16799-7-deepa.kernel@gmail.com> <CAF=yD-LDWrjxK+XFv-KNAoyP7NCOZiL00n5PkzQ-5aEzq+eCLQ@mail.gmail.com>
 <CABeXuvpAZfd6gAdJbKxsOowXnDnwyQQRuYMJ-6LDo9BsRDDj-g@mail.gmail.com>
 <CAF=yD-L4xTU-KXsQ=uU36fEKv5St=69mmKqT8sD1mAmT_hfuVQ@mail.gmail.com> <CABeXuvqrZgEDF5RYQEPJ8RyXDg0uvXx_qMq=2ER8Bc9RXFPDGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CABeXuvqrZgEDF5RYQEPJ8RyXDg0uvXx_qMq=2ER8Bc9RXFPDGQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Network Devel Mailing List <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, rth@twiddle.net, linux-alpha@vger.kernel.org, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 3 reasons for not doing this:
>
> 1. We do not want to break userspace. If we move this to
> linux/socket.h all the userspace programs now have to include
> linux/socket.h or get this definition through a new libc.
> 2. All the socket options are together in the file asm/socket.h. It
> doesn't seem good for maintainability to move just a few bits
> elsewhere.
> 3. There are only 4 arches (after the series is applied) that have
> their own asm/socket.h. And, this is because there seems to be
> significant differences to asm-generic/socket.h that don't seem
> logically obvious to group and eliminate some of the defines.

Agreed. All good reasons to leave as is.

> Also for the other comment. The reason the conditionals were not
> consistent is because they were not consistent to begin with.

The only difference I see is an inversion of the test. Nesting order
is the same:

        int need_software_tstamp = sock_flag(sk, SOCK_RCVTSTAMP);
        ...
        if (need_software_tstamp) {
                if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
                } else {
                }
        }

vs

                if (sock_flag(sk, SOCK_RCVTSTAMP)) {
                        if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
                        } else {
                        }
                }

I suggest just adding something like

        if (need_software_tstamp) {
+              if (sock_uses_new_tstamp(sk) {
+                   __sock_recv_timestamp_new(msg, sk,
ktime_to_timespec64(skb->tstamp));
+              } else if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
-               if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
                } else {
                }

and

                if (sock_flag(sk, SOCK_RCVTSTAMP)) {
+                      if (sock_uses_new_tstamp(sk) {
+                           __sock_recv_timestamp_new(msg, sk, ts);
+                      else if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
-                       if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
                        } else {
                        }

I think we can use the same helper for both the sock and tcp variant.
The only intended difference between the two functions, as described
in the tcp_recv_timestamp function comment, is the absence of an skb
in the tcp case. That is immaterial at this level.

Note also (2) tentative helper function sock_uses_new_tstamp(const
struct sock *sk) instead of testing sock_flag(sk, SOCK_TSTAMP_NEW)
directly. Since the .._NEW variants are equivalent to .._OLD on 64-bit,
I wonder if we can just compile out the branch. Something like

    static inline bool sock_uses_new_tstamp(const struct sock *sk) {
            return (sizeof(time_t) != sizeof(__kernel_long_t)) &&
                       sock_flag(sk, SOCK_TSTAMP_NEW);
    }

> I'm trying to follow your request to keep code churn to minimal.
> It's just that I moved to a different function as that seemed logical
> to me. Do you prefer me to remove that refactoring?

Yes, please avoid rearranging existing code as much as possible.

If there is any refactoring to be done, I think it would be to
deduplicate the shared logic between __sock_recv_timestamp and
tcp_recv_timestamp. I think the first can be rewritten to reuse the
second, if the only difference really is that the first takes an skb with
embedded timestamps, while the second directly takes a pointer to
struct scm_timestamping.

Either way, that's out of scope for this patchset.
