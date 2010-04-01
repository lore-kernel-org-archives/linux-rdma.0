From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 9/26] rdma/cm: set qkey for port space IB
Date: Thu, 1 Apr 2010 11:00:44 -0700
Message-ID: <79A94ECADC4342D0A4C057DC158F0303@amr.corp.intel.com>
References: <0B94CA7CD279474EAAF856BCEC45BDED@amr.corp.intel.com> <20100401174007.GB15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100401174007.GB15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>I know we talked about this, but seeing this patch makes me ask again,
>should the QKEY be part of sockaddr_ib? Or at least be settable somehow?

I think so.  I'm not sure of the best approach.  With these patches, the qkey
seems to be the one thing blocking the rdma_cm from supporting any IB UD
application.

Another item that I wonder about putting into sockaddr_ib is the SL.  There's a
way to set it today, but I wonder if it should be part of sockaddr_ib anyway.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
