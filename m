From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Thu, 23 Jul 2015 13:07:56 +0300
Message-ID: <55B0BCFC.6040602@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <20150722163405.GA26909@obsidianresearch.com>
 <20150722164421.GA6443@infradead.org> <55AFCBAF.2000504@dev.mellanox.co.il>
 <20150722190555.GB4527@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722190555.GB4527-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 10:05 PM, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2015 at 07:58:23PM +0300, Sagi Grimberg wrote:
>> On 7/22/2015 7:44 PM, Christoph Hellwig wrote:
>>> On Wed, Jul 22, 2015 at 10:34:05AM -0600, Jason Gunthorpe wrote:
>>>>> +/**
>>>>> + * ib_alloc_mr() - Allocates a memory region
>>>>> + * @pd:            protection domain associated with the region
>>>>> + * @mr_type:       memory region type
>>>>> + * @max_entries:   maximum registration entries available
>>>>> + * @flags:         create flags
>>>>> + */
>>>>
>>>> Can you update this comment to elaborate some more on what the
>>>> parameters are? 'max_entries' is the number of s/g elements or
>>>> something?
>>>>
>>>>> +enum ib_mr_type {
>>>>> +	IB_MR_TYPE_FAST_REG,
>>>>> +	IB_MR_TYPE_SIGNATURE,
>>>>>   };
>>>>
>>>> Sure would be nice to have some documentation for what these things
>>>> do..
>>>
>>> Agreed on both counts.  Otherwise this looks pretty good to me.
>>
>> I can add some more documentation here...
>
> So, I was wrong, 'max_entries' is the number of page entires, not
> really the s/g element limit?

The max_entries stands for the maximum number of sg entries. Other than
that, the SG list must meet the requirements documented in ib_map_mr_sg.

The reason I named max_entries is because might might not be pages but
real SG elements. It stands for maximum registration entries.

Do you have a better name?

>
> In other words the ULP can submit at most max_entires*PAGE_SIZE bytes
> for the non ARB_SG case
>
> For the ARB_SG case.. It is some other more difficult computation?

Not really. The ULP needs to submit sg_nents < max_entries. The SG
list needs to meed the alignment requirements.

For ARB_SG, the condition is the same, but the SG is free from the
alignment constraints.

>
> It is somewhat ugly to ask for this upfront as a hard limit..
>
> Is there any reason we can't use a hint_prealloc_pages as the argument
> here, and then realloc in the map routine if the hint turns out to be
> too small for a particular s/g list?

The reason is that it is not possible. The memory key allocation
reserves resources in the device translation tables. realloc means
reallocating the memory key. In any event, this is not possible in
the IO path.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
