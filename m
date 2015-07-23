From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Thu, 23 Jul 2015 13:09:33 +0300
Message-ID: <55B0BD5D.2040805@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9001357@ORSMSX109.amr.corp.intel.com>
 <20150723093046.GF32592@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723093046.GF32592-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 12:30 PM, Christoph Hellwig wrote:
> On Thu, Jul 23, 2015 at 12:57:34AM +0000, Hefty, Sean wrote:
>>> +enum ib_mr_type {
>>> +	IB_MR_TYPE_FAST_REG,
>>> +	IB_MR_TYPE_SIGNATURE,
>>
>> If we're going to go through the trouble of changing everything, I vote
>> for dropping the word 'fast'. It's a marketing term.  It's goofy.  And
>> the IB spec is goofy for using it.

So IB_MR_TYPE_MEM_REG?

>
> Yes.  Especially as the infrastructure will be usable to support FMR
> on legacy adapters as well except that instead of the ib_post_send it'll
> need a call to the FMR code at the very end.
>
> While we're at it  wonder if we should consolidate the type and the
> flags field as well, as the split between the two is a little confusing.

I can do that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
