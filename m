From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 04/14] cxgb4: Update to use new udma write barriers
Date: Fri, 17 Feb 2017 14:16:56 -0600
Message-ID: <04e201d2895a$c92c47b0$5b84d710$@opengridcomputing.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com> <1487272989-8215-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Based on help from Steve the barriers here are change to consistently
> bracket WC memory writes with wc_wmb() like other drivers do.
> 
> This allows some of the wc_wmb() calls that were not related to WC
> memory be downgraded to wmb().
> 
> The driver was probably correct (at least for x86-64) but did not
> follow the idiom established by the other drivers for working with
> WC memry.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I'm not going to address any of the FIXME issues yet, but:

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
