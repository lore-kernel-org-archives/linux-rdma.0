From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/8] IB/rxe: Remove buffer used for printing IP address
Date: Wed, 23 Nov 2016 19:48:41 +0200
Message-ID: <CAG9sBKOmLwY7mMmVKGbtCU3_G+mmic2+rANcoDtcRK1EwCagWA@mail.gmail.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com> <1479922764-13091-2-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-2-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 46f0628..252b4d6 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -391,16 +391,15 @@ int rxe_rcv(struct sk_buff *skb)
>                              payload_size(pkt));
>         calc_icrc = cpu_to_be32(~calc_icrc);
>         if (unlikely(calc_icrc != pack_icrc)) {
> -               char saddr[sizeof(struct in6_addr)];
> -
>                 if (skb->protocol == htons(ETH_P_IPV6))
> -                       sprintf(saddr, "%pI6", &ipv6_hdr(skb)->saddr);
> +                       pr_warn_ratelimited("bad ICRC from %pI6c\n",
> +                                           &ipv6_hdr(skb)->saddr);
>                 else if (skb->protocol == htons(ETH_P_IP))
> -                       sprintf(saddr, "%pI4", &ip_hdr(skb)->saddr);
> +                       pr_warn_ratelimited("bad ICRC from %pI4\n",
> +                                           &ip_hdr(skb)->saddr);
>                 else
> -                       sprintf(saddr, "unknown");
> +                       pr_warn_ratelimited("bad ICRC from unknown\n");
>
> -               pr_warn_ratelimited("bad ICRC from %s\n", saddr);
>                 goto drop;
>         }

Have you considered Bart's suggestion to use  %pIS instead of %pI4 and %pI6
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1067964305df
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
