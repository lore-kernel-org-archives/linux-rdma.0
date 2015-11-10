From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 16:30:23 -0500
Message-ID: <564261EF.4000008@talpey.com>
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
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2015 4:17 PM, Jason Gunthorpe wrote:
> On Tue, Nov 10, 2015 at 04:00:43PM -0500, Tom Talpey wrote:
>
>> Hmm, agreed, but it must still be acceptable to perform a registration
>> instead of using the local_dma_lkey. As mentioned earlier, there are
>> scatter limits and other implications for all-physical addressing that
>> an upper layer may choose to avoid.
>
> It is always acceptable to use a lkey MR instead of the local dma
> lkey, but ULPs should prefer to use the local dma lkey if possible,
> for performance reasons.

Sure, the key words are "if possible". For example, a single 1MB
RDMA Read is unlikely to be possible with the dma lkey, assuming
worst-case physical page scatter it would need 256 SGEs. But 1MB
can be registered easily.

In any case, my point was that the ULP gets to choose, so, it looks
like we agree.

Tom.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
