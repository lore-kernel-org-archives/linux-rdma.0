From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: memory registration updates
Date: Mon, 23 Nov 2015 20:43:50 +0100
Message-ID: <20151123194350.GA17760@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <5652D66E.5070600@dev.mellanox.co.il> <20151123141650.GA11116@lst.de> <56532E0A.20907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56532E0A.20907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 05:17:30PM +0200, Sagi Grimberg wrote:
>
>> I send 1-9 out separately earlier :)  The other two sit on top of them
>> and they are prep patches in a sense as they remove a lot of users
>> of struct ib_mr that i don't have to modify in patches 10 and 11.
>
> Still, patches 10,11 are not really a part of this patchset.
> I think they need to stand on their own while patches 1-9
> are cleanups really.

Already, I'll split the patches next.  Still hoping I won't have to resend
the first 9..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
