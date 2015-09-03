From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Thu, 3 Sep 2015 15:23:07 -0600
Message-ID: <20150903212307.GA8026@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com>
 <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com>
 <20150825194945.GA22335@obsidianresearch.com>
 <55DDC12E.6030705@redhat.com>
 <20150826161829.GA27407@obsidianresearch.com>
 <55DDECA3.4010207@redhat.com>
 <20150827233322.GA29724@obsidianresearch.com>
 <55E8B8EB.7000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55E8B8EB.7000009-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 03, 2015 at 05:17:31PM -0400, Doug Ledford wrote:
> On 08/27/2015 07:33 PM, Jason Gunthorpe wrote:
> > On Wed, Aug 26, 2015 at 12:43:15PM -0400, Doug Ledford wrote:
> > 
> >> That still takes us back to the fact that the locking changes are
> >> unneeded.  I'm not opposed to them, but as you mentioned in your first
> >> email, they should go with the changes that require them, and none of
> >> the changes in the first patch require them.  Which means that if we
> >> want to keep them, it might be worth splitting them out and giving them
> >> their own patch with an explanation of why they are a benefit (lightly
> >> contended code, saves a release/reacquire on the failure path).
> > 
> > Lets just drop them, the cost for restructing was an added empty lock
> > grab on a non-error path.
> 
> I've reworked the patch to not perform any locking changes and applied
> the result.

Thanks Doug, I've been too busy to look at this..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
