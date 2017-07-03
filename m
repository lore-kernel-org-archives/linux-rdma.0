From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Set dma_mask and coherent_dma_mask
Date: Mon, 3 Jul 2017 18:55:28 +0300
Message-ID: <CAG9sBKNoZ=14vL+DRoBD4+1Hnfw6L8EWt14W6j4Lm2m4LTtp6w@mail.gmail.com>
References: <20170622141000.9899-1-leon@kernel.org> <20170622141000.9899-2-leon@kernel.org>
 <20170627100433.GB6554@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170627100433.GB6554@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 27, 2017 at 1:04 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Yonatan and Leon,
> In one of my servers i got kernel oops also in ib_register_device when
> using dummy device (macvtap) with rxe so was blindly hoping this patch
> would solve it but is is not.
>
> Crash is in alloc_name somewhere in the "list_for_each_entry" loop, i think
> first line of it.
>
> Anyway, steps that i'm doing are:
> $ ip link add link eth0 name macvtap3 type macvtap mode bridge
> $ modprobe ib_core ib_umad rdma_ucm ib_uverbs rdma_rxe
> $ echo eth0 > /sys/module/rdma_rxe/parameters/add
> $ echo macvtap3 > /sys/module/rdma_rxe/parameters/add
> At this point the system crash.
>
> I'm using 4.12.0-rc6.
> This is 100% reproduced.
> Interesting thing is that i'm unable to reproduce it on my workstation.
>
thanks for the report Yuval
You said that it happens in only one of your servers but not in your
workstation, right?
Did you try to reproduce with the above scenario on different servers
with the same configuration?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
