From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Wed, 12 Dec 2018 10:22:04 -0500
Message-ID: <CAF=yD-LDWrjxK+XFv-KNAoyP7NCOZiL00n5PkzQ-5aEzq+eCLQ@mail.gmail.com>
References: <20181211202520.16799-1-deepa.kernel@gmail.com> <20181211202520.16799-7-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211202520.16799-7-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-alpha@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 11, 2018 at 3:30 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> Add SO_TIMESTAMP_NEW and SO_TIMESTAMPNS_NEW variants of
> socket timestamp options.
> These are the y2038 safe versions of the SO_TIMESTAMP_OLD
> and SO_TIMESTAMPNS_OLD for all architectures.
>
> Note that the format of scm_timestamping.ts[0] is not changed
> in this patch.
>
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Cc: jejb@parisc-linux.org
> Cc: ralf@linux-mips.org
> Cc: rth@twiddle.net
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> ---
>  arch/alpha/include/uapi/asm/socket.h  | 15 ++++++-
>  arch/mips/include/uapi/asm/socket.h   | 14 ++++++-
>  arch/parisc/include/uapi/asm/socket.h | 14 ++++++-
>  arch/sparc/include/uapi/asm/socket.h  | 14 ++++++-
>  include/linux/skbuff.h                | 18 +++++++++
>  include/net/sock.h                    |  1 +
>  include/uapi/asm-generic/socket.h     | 15 ++++++-
>  net/core/sock.c                       | 51 ++++++++++++++++++------
>  net/ipv4/tcp.c                        | 57 +++++++++++++++++++--------
>  net/rds/af_rds.c                      |  8 +++-
>  net/rds/recv.c                        | 16 +++++++-
>  net/socket.c                          | 47 ++++++++++++++++------
>  12 files changed, 216 insertions(+), 54 deletions(-)
>
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 00e45c80e574..352e3dc0b3d9 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -3,6 +3,7 @@
>  #define _UAPI_ASM_SOCKET_H
>
>  #include <asm/sockios.h>
> +#include <asm/bitsperlong.h>
>
>  /* For setsockopt(2) */
>  /*
> @@ -110,12 +111,22 @@
>
>  #define SO_TIMESTAMP_OLD         29
>  #define SO_TIMESTAMPNS_OLD       35
> +
>  #define SO_TIMESTAMPING_OLD      37
>
> +#define SO_TIMESTAMP_NEW         62
> +#define SO_TIMESTAMPNS_NEW       63
> +
>  #if !defined(__KERNEL__)
>
> -#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
> -#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
> +#if __BITS_PER_LONG == 64
> +#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
> +#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
> +#else
> +#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
> +#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
> +#endif
> +

This is not platform specific. Perhaps it can be deduplicated. The
interface expects callers to include <linux/socket.h>, not
<asm/socket.h> directly. So perhaps it can go there?

> -/* Similar to __sock_recv_timestamp, but does not require an skb */
> -static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
> -                              struct scm_timestamping *tss)
> +static void tcp_recv_sw_timestamp(struct msghdr *msg, const struct sock *sk, struct timespec64 *ts)
>  {
> -       struct __kernel_old_timeval tv;
> -       bool has_timestamping = false;
> +       int new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);
> +
> +       if (ts->tv_sec || ts->tv_nsec) {
> +               if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> +                       if (new_tstamp) {
> +                               struct __kernel_timespec kts = {ts->tv_sec, ts->tv_nsec};
> +
> +                               put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
> +                                        sizeof(kts), &kts);
> +                       } else {
> +                               struct timespec ts_old = timespec64_to_timespec(*ts);
>
> -       if (tss->ts[0].tv_sec || tss->ts[0].tv_nsec) {
> -               if (sock_flag(sk, SOCK_RCVTSTAMP)) {
> -                       if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
>                                 put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
> -                                        sizeof(tss->ts[0]), &tss->ts[0]);
> +                                        sizeof(ts), &ts_old);
> +                       }
> +               } else if (sock_flag(sk, SOCK_RCVTSTAMP)) {
> +                       if (new_tstamp) {
> +                               struct __kernel_sock_timeval stv;
> +
> +                               stv.tv_sec = ts->tv_sec;
> +                               stv.tv_usec = ts->tv_nsec / 1000;
> +
> +                               put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
> +                                        sizeof(stv), &stv);
>                         } else {
> -                               tv.tv_sec = tss->ts[0].tv_sec;
> -                               tv.tv_usec = tss->ts[0].tv_nsec / 1000;
> +                               struct __kernel_old_timeval tv;
>
> +                               tv.tv_sec = ts->tv_sec;
> +                               tv.tv_usec = ts->tv_nsec / 1000;
>                                 put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
>                                          sizeof(tv), &tv);
>                         }
>                 }
> -
> -               if (sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE)
> -                       has_timestamping = true;
> -               else
> -                       tss->ts[0] = (struct timespec) {0};
>         }
> +}
> +
> +/* Similar to __sock_recv_timestamp, but does not require an skb */
> +static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
> +                              struct scm_timestamping *tss)
> +{
> +       bool has_timestamping = false;
> +       struct timespec64 ts = timespec_to_timespec64(tss->ts[0]);
> +
> +       tcp_recv_sw_timestamp(msg, sk, &ts);
> +
> +       if (sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE)
> +               has_timestamping = true;
> +       else
> +               tss->ts[0] = (struct timespec) {0};
>
>         if (tss->ts[2].tv_sec || tss->ts[2].tv_nsec) {
>                 if (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE)

This did not address yet the previous comments on consistency and
unnecessary code churn.

The existing logic to differentiate SO_TIMESTAMP from SO_TIMESTAMPNS
in both tcp_recv_timestamp and __sock_recv_timestamp is

  if (sock_flag(sk, SOCK_RCVTSTAMP)) {
      if (sock_flag(sk, SOCK_RCVTSTAMPNS))
          /* timespec case */
      else
          /* timeval case */
  }

A new level of nesting needs to be added to differentiate .._OLD from .._NEW.

Even if massively changing the original functions, please do so
consistently, either

  if (sock_flag(sk, SOCK_RCVTSTAMP)) {
      if (sock_flag(sk, SOCK_TSTAMP_NEW) {
          /* new code */
      } else {
          if (sock_flag(sk, SOCK_RCVTSTAMPNS))
              /* timespec case */
          else
              /* timeval case */
     }
  }

or

  if (sock_flag(sk, SOCK_RCVTSTAMP)) {
      if (sock_flag(sk, SOCK_TSTAMP_NEW) {
          if (sock_flag(sk, SOCK_RCVTSTAMPNS))
              /* new timespec case */
          else
              /* timespec case */
      } else {
           if (sock_flag(sk, SOCK_RCVTSTAMPNS))
               /* new timespec case */
           else
               /* timespec case */
      }
  }

But not one variant in one function and one in the other.

Deep nesting is hard to follow and, once again, massive code changes
(even indentations) make git blame harder to use. So where possible,
try to avoid both and just insert a branch to a new function for the
.._NEW cases instead:

  if (sock_flag(sk, SOCK_RCVTSTAMP)) {
+      if (sock_flag(sk, SOCK_TSTAMP_NEW)
+          __sock_recv_timestamp_new(..);
-      if (sock_flag(sk, SOCK_RCVTSTAMPNS))
+      else if (sock_flag(sk, SOCK_RCVTSTAMPNS))
          /* timespec case */
      else
          /* timeval case */
  }

and leave the rest of the function unmodified.

> +static void sock_recv_sw_timestamp(struct msghdr *msg, struct sock *sk,
> +                                  struct sk_buff *skb)
> +{
> +       if (sock_flag(sk, SOCK_TSTAMP_NEW)) {
> +               if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> +                       struct __kernel_sock_timeval tv;
> +
> +                       skb_get_new_timestamp(skb, &tv);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
> +                                sizeof(tv), &tv);
> +               } else {
> +                       struct __kernel_timespec ts;
> +
> +                       skb_get_new_timestampns(skb, &ts);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
> +                                sizeof(ts), &ts);
> +               }
> +       }

In relation to previous: note the different branching approach to
tcp_recv_timestamp.

> +       if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> +               struct __kernel_old_timeval tv;
> +
> +               skb_get_timestamp(skb, &tv);
> +               put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
> +                        sizeof(tv), &tv);
> +       } else {
> +               struct timespec ts;
> +
> +               skb_get_timestampns(skb, &ts);
> +               put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
> +                        sizeof(ts), &ts);
> +       }
> +}
>  /*
>   * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
>   */
> @@ -718,19 +750,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>                 false_tstamp = 1;
>         }
>
> -       if (need_software_tstamp) {
> -               if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> -                       struct __kernel_old_timeval tv;
> -                       skb_get_timestamp(skb, &tv);
> -                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
> -                                sizeof(tv), &tv);
> -               } else {
> -                       struct timespec ts;
> -                       skb_get_timestampns(skb, &ts);
> -                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
> -                                sizeof(ts), &ts);
> -               }
> -       }
> +       if (need_software_tstamp)
> +               sock_recv_sw_timestamp(msg, sk, skb);
>
>         memset(&tss, 0, sizeof(tss));
>         if ((sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
> --
> 2.17.1
>
