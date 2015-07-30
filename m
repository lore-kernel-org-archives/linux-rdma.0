From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 30 Jul 2015 10:13:09 +0300
Message-ID: <55B9CE85.40007@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55B4AA73.3090803@dev.mellanox.co.il>
 <20150727170459.GA18348@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727170459.GA18348-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Can you explain what do you mean by "downgrades everything to a 2k
>> alignment"? If the ULP is responsible for a PAGE_SIZE alignment than
>> how would this get out of alignment with swiotlb?
>
> swiotlb copies all DMA maps to a shared buffer below 4G so it can be
> used with 32 bit devices.
>
> The shared buffer is managed in a way that copies each s/g element to
> a continuous 2k aligned subsection of the buffer.
>

Thanks for the explanation.

> Basically, swiotlb realigns everything that passes through it.

So this won't ever happen if the ULP will DMA map the SG and check
for gaps right?

Also, is it interesting to support swiotlb even if we don't have
any devices that require it (and should we expect one to ever exist)?

>
> The DMA API allows this, so ultimately, code has to check the dma
> physical address when concerned about alignment.. But we should not
> expect this to commonly fail.
>
> So, something like..
>
>    if (!ib_does_sgl_fit_in_mr(mr,sg))
>       .. bounce buffer ..

I don't understand the need for this is we do the same thing
if the actual mapping fails...

>
>    if (!ib_map_mr_sg(mr,sg)) // does dma mapping and checks it
>       .. bounce buffer ..

Each ULP would want to do something different, iser
will bounce but srp would need to use multiple mrs, nfs will
split the request.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
