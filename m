From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: memory registration updates
Date: Mon, 23 Nov 2015 15:16:50 +0100
Message-ID: <20151123141650.GA11116@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <5652D66E.5070600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5652D66E.5070600-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 11:03:42AM +0200, Sagi Grimberg wrote:
> Christoph,
>
>> This series removes huge chunks of code related to old memory
>> registration methods that we don't use anymore, and then simplifies the
>> current memory registration API
>
> Let's split out patches 10,11 from this set because these patches are
> logically completely different from the rest of the series which is a
> cleanup by nature.
>
> I suggest you send out patches 10,11 as a separate RFC series.

I send 1-9 out separately earlier :)  The other two sit on top of them
and they are prep patches in a sense as they remove a lot of users
of struct ib_mr that i don't have to modify in patches 10 and 11.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
