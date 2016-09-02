From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 5/9] ib_uverbs: Add padding to end align
 ib_uverbs_reg_mr_resp
Date: Thu, 1 Sep 2016 20:09:45 -0600
Message-ID: <20160902020945.GB30057@obsidianresearch.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
 <1472774969-18997-6-git-send-email-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472774969-18997-6-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 02, 2016 at 02:09:25AM +0200, Knut Omang wrote:
> The ib_uverbs_reg_mr_resp structure was not 64 bit end aligned
> as required by the protocol. This causes alignment issues
> if a device specific driver needs to transfer extra response
> arguments.

Can you explain in the commit message why this doesn't break anything?
How does compat work with existing libibverbs?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
