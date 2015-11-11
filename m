From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Wed, 11 Nov 2015 11:25:06 +0200
Message-ID: <56430972.8080703@dev.mellanox.co.il>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org> <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <20151110182546.GI12667@obsidianresearch.com> <56425AFB.30202@talpey.com>
 <20151110211716.GA21631@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110211716.GA21631-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason,

> It is always acceptable to use a lkey MR instead of the local dma
> lkey, but ULPs should prefer to use the local dma lkey if possible,
> for performance reasons.

I don't necessarily agree with this statement (at least with the second
part of it), the world is not always perfect.

For RDMA READs, a HCA will perform the memory scatters when on the RX
path, when receiving the read responses containing the data. This means
that the HCA needs to perform a lookup of the relevant scatter entries
upon each read response. Due to that, modern HCAs keep a dedicate cache
for this type of RX-path lookup (which is limited in size naturally).

So, having *small* sgls for rdma_read is much (much) more friendly to
the HCA caches which means that for large transfers, even for IB, it
might be better to register memory than having endless sgls.
I was able to see that under some workloads.

This is yet another non-trivial consideration that ULPs need to be aware
of... We really are better off putting this stuff in the core...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
