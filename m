From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 6/7] IB/rxe: Fix up one more receive queue drain path that
 might prevent cleanup
Date: Thu, 27 Jul 2017 15:13:33 +0300
Message-ID: <CAG9sBKM8rZRqpPLe5QzvpNEMe-ep+ji=+LXzO=HYXJ31OZ41hA@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com> <1500989968-30889-7-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-7-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> Fixes: 1217197142d1 ("rxe: fix broken receive queue draining")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_req.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
please improve documentation for this patch
Make sure that the commit message has a body, not just subject (which
you can make shorter and more general)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
