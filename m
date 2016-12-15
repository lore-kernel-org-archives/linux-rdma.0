From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] libcxgb4: fixes for debug build
Date: Thu, 15 Dec 2016 16:09:50 -0600
Message-ID: <063801d2571f$f4b0dd00$de129700$@opengridcomputing.com>
References: <20161215212201.AAA3BE08C3@smtp.ogc.us> <20161215220331.GB28939@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161215220331.GB28939-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> 
> >  	PDBG("%s found vendor %d device %d type %d\n",
> > -	     __FUNCTION__, vendor, device, hca_table[i].chip_version);
> > +	     __FUNCTION__, vendor, device,
> CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));
> 
> Don't #define debug macros to {} to avoid this kind of bug
> 
> see b60ae256e7d1541edc8fd6a072a17c143ce70b4a
> 
> Jason

Thanks Jason, I'll fix this at some point.  I don't see a way to open a github
issue to track this.  Is that not enabled for rdma-core?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
