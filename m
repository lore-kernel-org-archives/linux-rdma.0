From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: memory registration updates
Date: Mon, 23 Nov 2015 17:17:30 +0200
Message-ID: <56532E0A.20907@dev.mellanox.co.il>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <5652D66E.5070600@dev.mellanox.co.il> <20151123141650.GA11116@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123141650.GA11116-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> I send 1-9 out separately earlier :)  The other two sit on top of them
> and they are prep patches in a sense as they remove a lot of users
> of struct ib_mr that i don't have to modify in patches 10 and 11.

Still, patches 10,11 are not really a part of this patchset.
I think they need to stand on their own while patches 1-9
are cleanups really.

I'll look at patches 10,11 once I get a bit of free time...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
