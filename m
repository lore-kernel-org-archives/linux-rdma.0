From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Fri, 11 Aug 2017 00:33:27 +0300
Message-ID: <20170810213326.GA2343@yuvallap>
References: <1502391902-5674-1-git-send-email-aditr@vmware.com>
 <20170810200256.GA4913@yuvallap>
 <306A2D1C-3070-4BFA-B532-D5020F5D185A@vmware.com>
 <20170810210103.GA9201@yuvallap>
 <B2047B7A-49AA-4899-86F9-E80039033662@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B2047B7A-49AA-4899-86F9-E80039033662-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 10, 2017 at 09:26:06PM +0000, Adit Ranadive wrote:
> On 8/10/17, 2:01 PM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > Great, i understand that.
> > So, at least can you consider moving this dev_err into
> > pvrdma_idx_ring_has_data so callers do not need to handle errors?
> 
> Thanks for the suggestion. It's something we will have to discuss internally,
> though I'm not sure if BUG_ON is the right way to go. That just seems a really

No, i agree, BUG_ON is a mistake as ring corruption can be caused by HW, my
suggestion is just to place the check and error print inside the function
pvrdma_idx_ring_has_data so callers will not need to handle such errors.

Anyways, with or without taking the suggestion - fix lgtm.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> big hammer to me.
> As it stands the patch should be added since it does fix a potential race
> condition.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
