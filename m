From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Wed, 16 Aug 2017 10:59:52 -0400
Message-ID: <1502895592.33760.8.camel@redhat.com>
References: <1502391902-5674-1-git-send-email-aditr@vmware.com>
         <20170810200256.GA4913@yuvallap>
         <306A2D1C-3070-4BFA-B532-D5020F5D185A@vmware.com>
         <20170810210103.GA9201@yuvallap>
         <B2047B7A-49AA-4899-86F9-E80039033662@vmware.com>
         <20170810213326.GA2343@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810213326.GA2343@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-08-11 at 00:33 +0300, Yuval Shaia wrote:
> On Thu, Aug 10, 2017 at 09:26:06PM +0000, Adit Ranadive wrote:
> > On 8/10/17, 2:01 PM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > > Great, i understand that.
> > > So, at least can you consider moving this dev_err into
> > > pvrdma_idx_ring_has_data so callers do not need to handle errors?
> > 
> > Thanks for the suggestion. It's something we will have to discuss
> > internally,
> > though I'm not sure if BUG_ON is the right way to go. That just
> > seems a really
> 
> No, i agree, BUG_ON is a mistake as ring corruption can be caused by
> HW, 

BUG_ON is generally a mistake regardless.  Even if it was an issue in
the driver, another option would be to forcibly remove the ib_device
and shut it all down.  That would prevent a driver bug from taking the
machine down, and therefore is preferable to a BUG_ON.  If I see a
BUG_ON, I'm immediately going to be asking why that particular
condition is so bad that you think someone's Oracle server should die
entirely versus limping along with some disabled device or something
(because I know that's exactly what Linus will ask when he sees it).

> my
> suggestion is just to place the check and error print inside the
> function
> pvrdma_idx_ring_has_data so callers will not need to handle such
> errors.
> 
> Anyways, with or without taking the suggestion - fix lgtm.
> 
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Pulled in for -rc.  Thanks.

> > big hammer to me.
> > As it stands the patch should be added since it does fix a
> > potential race
> > condition.
> > 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
