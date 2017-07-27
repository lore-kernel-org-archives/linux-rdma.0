From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/7] IB/rxe: Move refcounting earlier in rxe_send()
Date: Thu, 27 Jul 2017 11:57:50 +0300
Message-ID: <CAG9sBKMixbqWu5cpvTR+K5j5WU67BBbEBsgR26KkiC3OAg6hFg@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com> <1500989968-30889-2-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-2-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> The network stack will call nskb's destructor, rxe_skb_tx_dtor(), if the
> packet gets dropped by ip_local_out()/ip6_local_out(). Thus we need to add
> the QP ref before output to avoid extra dereferences during network
> congestion. This could lead to unwanted destruction of the QP.
>
> Fix up the skb_out accounting, too.
>
> Fixes: fda85ce91240 ("IB/rxe: Fix kernel panic from skb destructor")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
