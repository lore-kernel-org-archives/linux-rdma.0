From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] IB/rdmavt: Add functions for cq, qp, post send and recv
Date: Tue, 19 Jan 2016 18:44:11 +0200
Message-ID: <CAG9sBKMNm1bMtjoUsGjj+FVL3ZmBw--tK-6iXYMW+0N5j2VE2A@mail.gmail.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109145731.8585.48926.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 9, 2016 at 4:59 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This series continues adding support for verbs into rdmavt. This brings in
> completion queue, queue pair, and post send/recv functionality.
>
> It also introduces event tracing and moves some more of the hfi1/qib
> registration functionality.
>
> This patch set applies on top of the "Start to rely on rdmavt for qp support"
> series previously submitted.
>
> ---
>
> Dennis Dalessandro (8):
>       IB/rdmavt: Add completion queue functions
>       IB/rdmavt: Add post send to rdmavt
>       IB/rdmavt: Add support for tracing events
>       IB/rdmavt: Add modify qp
>       IB/rdmavt: Add destroy qp verb
>       IB/rdmavt: Add post receive to rdmavt
>       IB/rdmavt: Add multicast functions
>       IB/rdmavt: Add misc dev register functionality

I didn't see anywhere an API for RVT that handles received packets
Did I miss it?
If not, what is expected from the lower driver to do when a packet is received?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
