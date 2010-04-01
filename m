From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/26] rdma/cm: set qkey for port space IB
Date: Thu, 1 Apr 2010 12:23:32 -0600
Message-ID: <20100401182332.GC15629@obsidianresearch.com>
References: <0B94CA7CD279474EAAF856BCEC45BDED@amr.corp.intel.com> <20100401174007.GB15629@obsidianresearch.com> <79A94ECADC4342D0A4C057DC158F0303@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <79A94ECADC4342D0A4C057DC158F0303-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 01, 2010 at 11:00:44AM -0700, Sean Hefty wrote:
> >I know we talked about this, but seeing this patch makes me ask again,
> >should the QKEY be part of sockaddr_ib? Or at least be settable somehow?
 
> I think so.  I'm not sure of the best approach.  With these patches,
> the qkey seems to be the one thing blocking the rdma_cm from
> supporting any IB UD application.

Right.. qkey is kinda a funny thing, and pkey too I suppose.

I'm not sure, I don't really know the usage model for qkey..

> Another item that I wonder about putting into sockaddr_ib is the SL.
> There's a way to set it today, but I wonder if it should be part of
> sockaddr_ib anyway.

SL is the LRH form of TClass/FlowLabel, like sockaddr_in6 sockaddr_ib
should have those two. If you want to control the SL then I think it
is reasonable that you'd have to use the APIs you added to set the
entire path record.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
