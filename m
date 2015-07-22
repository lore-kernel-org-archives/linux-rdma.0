From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Wed, 22 Jul 2015 19:58:23 +0300
Message-ID: <55AFCBAF.2000504@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <20150722163405.GA26909@obsidianresearch.com>
 <20150722164421.GA6443@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722164421.GA6443-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 7:44 PM, Christoph Hellwig wrote:
> On Wed, Jul 22, 2015 at 10:34:05AM -0600, Jason Gunthorpe wrote:
>>> +/**
>>> + * ib_alloc_mr() - Allocates a memory region
>>> + * @pd:            protection domain associated with the region
>>> + * @mr_type:       memory region type
>>> + * @max_entries:   maximum registration entries available
>>> + * @flags:         create flags
>>> + */
>>
>> Can you update this comment to elaborate some more on what the
>> parameters are? 'max_entries' is the number of s/g elements or
>> something?
>>
>>> +enum ib_mr_type {
>>> +	IB_MR_TYPE_FAST_REG,
>>> +	IB_MR_TYPE_SIGNATURE,
>>>   };
>>
>> Sure would be nice to have some documentation for what these things
>> do..
>
> Agreed on both counts.  Otherwise this looks pretty good to me.

I can add some more documentation here...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
