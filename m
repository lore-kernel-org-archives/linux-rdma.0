From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/uapi: expose uverbs WC opcodes
Date: Tue, 29 Dec 2015 13:02:54 +0200
Message-ID: <5682685E.90700@dev.mellanox.co.il>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-4-git-send-email-hch@lst.de>
 <20151227061202.GB8501@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151227061202.GB8501-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> +	IB_WC_SEND		= IB_UVERBS_WC_SEND,
>> +	IB_WC_RDMA_WRITE	= IB_UVERBS_WC_RDMA_WRITE,
>> +	IB_WC_RDMA_READ		= IB_UVERBS_WC_RDMA_READ,
>> +	IB_WC_COMP_SWAP		= IB_UVERBS_WC_COMP_SWAP,
>> +	IB_WC_FETCH_ADD		= IB_UVERBS_WC_FETCH_ADD,
>> +	IB_WC_LSO		= IB_UVERBS_WC_SEND_END,
>> +	IB_WC_LOCAL_INV		= IB_UVERBS_WC_SEND_END + 1,
>> +	IB_WC_REG_MR		= IB_UVERBS_WC_SEND_END + 2,
>> +	IB_WC_MASKED_COMP_SWAP	= IB_UVERBS_WC_SEND_END + 3,
>> +	IB_WC_MASKED_FETCH_ADD	= IB_UVERBS_WC_SEND_END + 4,
> As you did it in the first patch, just don't assign after IB_WC_LOCAL_INV.
> Compiler will handle IB_UVERS_WC_SEND_END + X calculations by itself.

I disagree, I'd say its better to keep the code verbosity level here...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
