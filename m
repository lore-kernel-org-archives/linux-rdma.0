From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH 7/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Sat, 24 Nov 2018 22:59:54 -0500
Message-ID: <CAF=yD-K=ZLZ_S=Y6YnhvvkfKQS=21ujwiGd7+JB9yDMtiX_9hg@mail.gmail.com>
References: <20181124022035.17519-1-deepa.kernel@gmail.com> <20181124022035.17519-8-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181124022035.17519-8-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-alpha@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 24, 2018 at 3:58 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
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

> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8143c4c1a49d..9edf909dc176 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -801,6 +801,7 @@ enum sock_flags {
>         SOCK_RCU_FREE, /* wait rcu grace period in sk_destruct() */
>         SOCK_TXTIME,
>         SOCK_XDP, /* XDP is attached */
> +       SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */

sk_flags is getting exhausted. Commit b9f40e21ef42 ("net-timestamp:
move timestamp flags out of sk_flags") added a new u16 sk_tsflags
specifically for timestamps. That may be a better choice here, too.

> diff --git a/net/core/sock.c b/net/core/sock.c
> index e60036618205..7b485dfaa400 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -652,15 +652,23 @@ static void setsockopt_timestamp(struct sock *sk, int type, int val)
>         if (!val) {
>                 sock_reset_flag(sk, SOCK_RCVTSTAMP);
>                 sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
> +               sock_reset_flag(sk, SOCK_TSTAMP_NEW);
>                 return;
>         }
>
> +       if (type == SO_TIMESTAMP_NEW || type == SO_TIMESTAMPNS_NEW)
> +               sock_set_flag(sk, SOCK_TSTAMP_NEW);
> +       else
> +               sock_reset_flag(sk, SOCK_TSTAMP_NEW);
> +

if adding a boolean whether the socket uses new or old-style
timestamps, perhaps fail hard if a process tries to set a new-style
option while an old-style is already set and vice versa. Also include
SO_TIMESTAMPING_NEW as it toggles the same option.

> diff --git a/net/socket.c b/net/socket.c
> index d3defba55547..9abeb6bc9cfe 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -699,6 +699,38 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
>                  sizeof(ts_pktinfo), &ts_pktinfo);
>  }
>
> +static void sock_recv_sw_timestamp(struct msghdr *msg, struct sock *sk,
> +                                  struct sk_buff *skb)
> +{
> +       if (sock_flag(sk, SOCK_TSTAMP_NEW)) {
> +               if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> +                       struct sock_timeval tv;
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
>   * or sock_flag(sk, SOCK_RCVTSTAMPNS)
> @@ -719,19 +751,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>                 false_tstamp = 1;
>         }
> -       if (need_software_tstamp) {

Considerably less code churn if adding __sock_recv_timestamp_2038 and
calling that here:

                   if (sock_flag(sk, SOCK_TSTAMP_NEW))
                           __sock_recv_timestamp_2038(msg, sk, skb);
                   else if ...

Same for the tcp case above, really, and in the case of the next patch
for SO_TIMESTAMPING_NEW


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
