From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] IB: Switch from struct ib_dma_mapping_ops to struct
 dma_mapping_ops
Date: Mon, 19 Dec 2016 11:42:08 -0500
Message-ID: <52e8398f-a146-721c-3b92-0892b4abbff8@intel.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
 <25d066c2-59d7-2be7-dd56-e29e99b43620@sandisk.com>
 <20161209182429.GF16622@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161209182429.GF16622-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/09/2016 01:24 PM, Christoph Hellwig wrote:
>> Additionally, use dma_noop_ops instead of duplicating it.
>
> Oops, I don't think that part actually is correct.  Both rdmavt
> and the weird intel drivers want the _virtual_ address in their dma
> address instead of the physical one set by dma_noop_ops.

Yes, Christoph is correct in that our drivers use the virtual address. 
It would require more changes in the rest of the driver to make it use 
the physical address. Possible I think, but more work.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
