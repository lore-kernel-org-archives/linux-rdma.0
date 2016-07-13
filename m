From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Skip napi_schedule if ib_poll_cq fails (v2)
Date: Wed, 13 Jul 2016 21:44:10 +0300
Message-ID: <20160713184408.GA2985@yuval-lap>
References: <1468423316-28246-1-git-send-email-yuval.shaia@oracle.com>
 <20160713153252.GG10079@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713153252.GG10079-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2016 at 06:32:52PM +0300, Leon Romanovsky wrote:
> On Wed, Jul 13, 2016 at 08:21:55AM -0700, Yuval Shaia wrote:
> > v0 -> v1:
> > 	* Initialize n before use
> > 
> > v1 -> v2
> > 	* Add reviewers
> 
> You don't need to resend patches with tags changes only.
> Patchworks handles it and adds automatically when Doug
> collects them before apply.

I also added some off-list reviewers.

> 
> And it will be great if you avoid adding cover letter for one patch.

Sure, will do.

> 
> Thanks
> 
> > 
> > [PATCH v2] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
