From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 09/10] IB: remove the struct ib_phys_buf definition
Date: Sun, 20 Dec 2015 16:41:37 +0100
Message-ID: <20151220154137.GA10351@lst.de>
References: <1450446906-10336-1-git-send-email-hch@lst.de> <1450446906-10336-10-git-send-email-hch@lst.de> <56765AC2.2010104@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56765AC2.2010104-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 20, 2015 at 09:37:38AM +0200, Or Gerlitz wrote:
> On 12/18/2015 3:55 PM, Christoph Hellwig wrote:
>
>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> [core]
>> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
> Here, too, please avoid empty change logs to IB core patches.

You sound like a bot :)

While I tend to ask people for better description a lot when I don't
understand a patch without them I really don't see what you might want
here.  In general it really helps  to say what you want to see.  I can't
see a useful explanation for removing an unused structure.  But if you
really want one and come up with a coherent sentence or two I can add it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
