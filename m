From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v3 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Tue, 8 Jan 2019 09:03:04 -0500
Message-ID: <CAF=yD-L_KbVEbMaY6-3uA4Sp7gDMPEcF7+74J4TzukXb33t55w@mail.gmail.com>
References: <20190108032657.8331-1-deepa.kernel@gmail.com> <20190108032657.8331-7-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108032657.8331-7-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ralf Baechle <ralf@linux-mips.org>, rth@twiddle.net, linux-alpha@vger.kernel.org, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, linux-rdma@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 7, 2019 at 10:29 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
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

> @@ -1864,20 +1864,39 @@ static void tcp_update_recv_tstamps(struct sk_buff *skb,
>  static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
>                                struct scm_timestamping *tss)
>  {
> -       struct __kernel_old_timeval tv;
>         bool has_timestamping = false;
> +       int new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);

nit: move above has_timestamping to maintain reverse christmas tree ordering
