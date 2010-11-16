From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: Support for Memory windows.
Date: Tue, 16 Nov 2010 15:01:49 +0200
Message-ID: <4CE280BD.8080505@mellanox.co.il>
References: <4CE14C82.9020907@cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE14C82.9020907-rh8NL+sEX9E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Romulo Goncalves <R.A.Goncalves-rh8NL+sEX9E@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 11/15/2010 5:06 PM, Romulo Goncalves wrote:
> Hello,
>
> For my PhD project I have been using RDMA over inifiniband.
> Until now I have used memory regions, but now I would like to also define memory windows.
>
> The steps taken are the following ones:
> Register a memory region.
> Alloc a window
> bind the window to the registered memory region.
>
> The memory region registration worked as expected, however, the call of the function to alloc the memory window did not.
> It seems there is not an implementation for the functions to alloc, bind, and dealloc a memory window.
>
> I looked into verbs.h and I found the reference to the functions in the context_ops:
>
> struct ibv_context_ops {
> ....
>           struct ibv_mw * (*alloc_mw)(struct ibv_pd *pd, enum ibv_mw_type type);
>           int                     (*bind_mw)(struct ibv_qp *qp, struct ibv_mw *mw, struct ibv_mw_bind *mw_bind);
>           int                     (*dealloc_mw)(struct ibv_mw *mw);
> ....
> }
>
> However, I do not see their declaration or implementation anywhere else.
> Could be the version of my openfabrics does not support memory windows?
>
Memory Windows have not been implemented

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
