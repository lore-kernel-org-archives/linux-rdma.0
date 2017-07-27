From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/rxe: Bug fixes
Date: Thu, 27 Jul 2017 16:27:11 +0300
Message-ID: <CAG9sBKMjZX7+y_q+4=+KJOJqBbTJ-Xd===qefzgARE_-zsFKWQ@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hubbe, Allen" <allen.hubbe-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> This patch set addresses a few issues which we have found in RXE.
> The first patch fixes a serious issue that causes kernel panics during
> network congestion.
>
> Andrew Boyer (7):
>   IB/rxe: Move refcounting earlier in rxe_send()
>   IB/rxe: Disable completion upcalls when a CQ is destroyed
>   IB/rxe: Remove dangling prototype
>   IB/rxe: Fix up the responder's find_resources() function
>   IB/rxe: Fix destination cache for IPv6
>   IB/rxe: Fix up one more receive queue drain path that might prevent
>     cleanup
>   IB/rxe: Avoid ICRC errors by copying into the skb first
>
Thanks for the effort and time you invested here Andrew
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
