From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Wed, 11 Nov 2015 11:09:03 +0200
Message-ID: <564305AF.3020903@dev.mellanox.co.il>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <20151110180156.GE12667@obsidianresearch.com>
 <20151111080837.GA14662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111080837.GA14662-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 11/11/2015 10:08, Christoph Hellwig wrote:
> On Tue, Nov 10, 2015 at 11:01:56AM -0700, Jason Gunthorpe wrote:
>> No need to change every driver.
>>
>> I'd suggest something like
>>
>>    unsigned int rdma_cap_rdma_read_mr_flags(const struct ib_pd *pd)
>>    {
>>       if (rdma_protocol_iwarp(pd->device, rdma_start_port(pd->device)))
>>             return IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
>>       return IB_ACCESS_LOCAL_WRITE;
>>    }
>
> Yes, this looks good!

It does, but it doesn't look like something we'd want to check for each
IO...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
