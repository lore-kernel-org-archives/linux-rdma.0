From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/26] rdma/cm: set qkey for port space IB
Date: Thu, 1 Apr 2010 11:40:07 -0600
Message-ID: <20100401174007.GB15629@obsidianresearch.com>
References: <0B94CA7CD279474EAAF856BCEC45BDED@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0B94CA7CD279474EAAF856BCEC45BDED-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 01, 2010 at 10:08:41AM -0700, Sean Hefty wrote:
> Include RDMA_PS_IB checks when setting the qkey for UD QPs.

I know we talked about this, but seeing this patch makes me ask again,
should the QKEY be part of sockaddr_ib? Or at least be settable somehow?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
