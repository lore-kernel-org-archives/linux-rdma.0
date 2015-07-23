From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Thu, 23 Jul 2015 19:59:48 +0300
Message-ID: <55B11D84.102@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
 <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il>
 <20150722175755.GH26909@obsidianresearch.com>
 <55B0C18B.4080901@dev.mellanox.co.il>
 <20150723163124.GD25174@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723163124.GD25174-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 7:31 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 01:27:23PM +0300, Sagi Grimberg wrote:
>>> ib_post_fastreg_wr would be a function that needs 3 register passed
>>> arguments and does a simple copy to the driver's actual sendq
>>
>> That will require to take the SQ lock and write a doorbell for each
>> registration and post you want to do. I'm confident that constructing
>> a post chain with a single sq lock acquire and a single doorbell will
>> be much much better even with conditional jumps and memsets.
>
> You are still thinking at a micro level, the ULP should be working at
> a higher level and requesting the MR(s) and the actual work together
> so the driver can run the the whole chain of posts without extra stack
> traffic, locking or doorbells.

But I'd also want to chain the subsequent RDMA(s) or SEND (with the
rkey(s) under the same post.

I'm sorry but the idea of handling memory region mapping (possibly more
than one), detecting gaps and deciding on the strategy of what to do
and who knows what else under the send queue lock doesn't seem like a
good idea, its a complete overkill IMO.

I don't mean to be negative about your ideas, I just don't think that
doing all the work in the drivers is going to get us to a better place.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
