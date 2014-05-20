From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: help with IB_WC_MW_BIND_ERR
Date: Tue, 20 May 2014 12:39:58 -0700
Message-ID: <CABgxfbHu8Wga6tX7iPyNb0aZaVY7XizAY_jpJW6+Nk2H9Gva5w@mail.gmail.com>
References: <B34C7243-DCF8-472B-B156-9B8791F0F475@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B34C7243-DCF8-472B-B156-9B8791F0F475-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 20, 2014 at 11:55 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hi-
>
> What does it mean when a LOCAL_INV work request fails with a
> IB_WC_MW_BIND_ERR completion?
>

Mapping an IB error code has been a great pain (at least for me)
unless you have access to the HCA firmware. In this case, I think it
implies memory protection error (registration issues).... say in cxgb4
driver, it is associated with invalidate shared MR or invalidate bound
memory window (with a QP):

                case T4_ERR_INVALIDATE_SHARED_MR:
                case T4_ERR_INVALIDATE_MR_WITH_MW_BOUND:
                        wc->status = IB_WC_MW_BIND_ERR;
                        break;

"drivers/infiniband/hw/cxgb4/cq.c" line 654 of 898 --72%-- col 11-25

You'll probably need to mention the HCA name so the firmware people,
if they are reading this, could pinpoint the exact cause.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
