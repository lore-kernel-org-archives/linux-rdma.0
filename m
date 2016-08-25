From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/15] IB/pvrdma: Add helper functions
Date: Thu, 25 Aug 2016 09:29:00 +0300
Message-ID: <20160825062859.GC10342@yuval-lap>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-7-git-send-email-aditr@vmware.com>
 <20160825061643.GB10342@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160825061643.GB10342@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 09:16:43AM +0300, Yuval Shaia wrote:
> > +
> > +void pvrdma_gid_to_ib(const union pvrdma_gid *src, union ib_gid *dst)
> > +{
> > +	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
> > +	memcpy(dst, src, sizeof(*src));
> 
> If we enforce size-computability then can you consider return cast of *src
> instead of doing memcpy?

Please ignore this one.
Looking at usage of this function i don't think you want to do it.
But suggesting to rename the function to something that will imply that you
actually copying and not just convening.

> 
> > +}
> > +
> > +void ib_gid_to_pvrdma(const union ib_gid *src, union pvrdma_gid *dst)
> > +{
> > +	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
> > +	memcpy(dst, src, sizeof(*src));
> 
> Ditto.
> 
> > +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
