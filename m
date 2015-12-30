From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/uapi: expose uverbs WC opcodes
Date: Wed, 30 Dec 2015 10:44:29 +0100
Message-ID: <20151230094429.GD12904@lst.de>
References: <1450967967-12479-1-git-send-email-hch@lst.de> <1450967967-12479-4-git-send-email-hch@lst.de> <20151227061202.GB8501@leon.nu> <5682685E.90700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5682685E.90700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 01:02:54PM +0200, Sagi Grimberg wrote:
>> As you did it in the first patch, just don't assign after IB_WC_LOCAL_INV.
>> Compiler will handle IB_UVERS_WC_SEND_END + X calculations by itself.
>
> I disagree, I'd say its better to keep the code verbosity level here...

I really don't like enum auto assignment for constants that are fixe
as part of an ABI.  There is too much chance of things going wrong.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
