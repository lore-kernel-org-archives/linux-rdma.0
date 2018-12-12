From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Wed, 12 Dec 2018 10:35:23 -0500
Message-ID: <CAF=yD-J8Ea1ope3ZBgPCufnMxDgGArhqRdvszz44u29BJAPS7w@mail.gmail.com>
References: <20181211202520.16799-1-deepa.kernel@gmail.com>
 <20181211202520.16799-7-deepa.kernel@gmail.com> <CAF=yD-LDWrjxK+XFv-KNAoyP7NCOZiL00n5PkzQ-5aEzq+eCLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF=yD-LDWrjxK+XFv-KNAoyP7NCOZiL00n5PkzQ-5aEzq+eCLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-alpha@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> This did not address yet the previous comments on consistency and
> unnecessary code churn.
>
> The existing logic to differentiate SO_TIMESTAMP from SO_TIMESTAMPNS
> in both tcp_recv_timestamp and __sock_recv_timestamp is
>
>   if (sock_flag(sk, SOCK_RCVTSTAMP)) {
>       if (sock_flag(sk, SOCK_RCVTSTAMPNS))
>           /* timespec case */
>       else
>           /* timeval case */
>   }
>
> A new level of nesting needs to be added to differentiate .._OLD from .._NEW.
>
> Even if massively changing the original functions, please do so
> consistently, either
>
>   if (sock_flag(sk, SOCK_RCVTSTAMP)) {
>       if (sock_flag(sk, SOCK_TSTAMP_NEW) {
>           /* new code */
>       } else {
>           if (sock_flag(sk, SOCK_RCVTSTAMPNS))
>               /* timespec case */
>           else
>               /* timeval case */
>      }
>   }

This first example is wrong. I meant

   if (sock_flag(sk, SOCK_RCVTSTAMP)) {
       if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
           if (sock_flag(sk, SOCK_TSTAMP_NEW)
                /* new code */
          else
                /* timespec case */
       } else {
           if (sock_flag(sk, SOCK_TSTAMP_NEW)
                /* new code */
          else
                /* timeval case */
        }
   }
