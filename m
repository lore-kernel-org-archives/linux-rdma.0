From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Fri, 26 Jun 2015 10:18:55 -0500
Message-ID: <558D6D5F.5000106@opengridcomputing.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int> <1828884A29C6694DAF28B7E6B8A82373A8FF9ECA@ORSMSX109.amr.corp.intel.com> <558D5B6E.6090900@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558D5B6E.6090900-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/26/2015 9:02 AM, Steve Wise wrote:
> On 6/25/2015 5:37 PM, Hefty, Sean wrote:
>>> +enum rdma_mr_roles {
>> I would drop naming the enum - it shouldn't be used, as the values 
>> are bit flags.
>
> ok.
>
>>> +    RDMA_MRR_RECV            = 1,
>>> +    RDMA_MRR_SEND            = (1<<1),
>>> +    RDMA_MRR_READ_SOURCE        = (1<<2),
>>> +    RDMA_MRR_READ_SINK        = (1<<3),
>>> +    RDMA_MRR_WRITE_SOURCE        = (1<<4),
>>> +    RDMA_MRR_WRITE_SINK        = (1<<5),
>>> +    RDMA_MRR_ATOMIC            = (1<<6),
>>> +    RDMA_MRR_MW_BIND        = (1<<7),
>>> +    RDMA_MRR_ZERO_BASED        = (1<<8),
>> There's 'something' different about this role that cause me 
>> hesitation.  Maybe that it's dependent on other roles being set to be 
>> useful?  I'm not sure.
>>
>> Maybe we need both roles and registration flags, with this declared 
>> as a flag?
>>
>>> +    RDMA_MRR_ACCESS_ON_DEMAND    = (1<<9),
>> This one is even more different, as it doesn't impact how the MR 
>> interacts with the interfaces, or change how the application uses the 
>> MR.  This is really a hint to the provider regarding the selection of 
>> different implementation flows.
>
> How about roles and attributes?  ZERO_BASED and ACCESS_ON_DEMAND would 
> be attributes and the rest roles.
>

I'm thinking now about the access flags specified in a IB_WR_FAST_REG_MR 
work request.  I think we need a similar function for this, but it will 
return the ib_access_flags bits to be stored in 
ib_send_wr->wr.fast_reg.access_flags field.  With this function defined, 
then rdma_get_dma_mr() can use it as well.

So perhaps an internal static function in verbs.c that does the bulk of 
what I put in rdma_get_dma_mr() originally called:

device_mr_access_flags(device, roles, attrs)

used by exported functions (or inlines in ib_verbs.h):

rdma_get_dma_mr(device, roles, attrs)
rdma_fast_reg_access_flags(device, roles, attrs)

I'll code this up and send for another round of review.  Eventually i'll 
get this included in the series with the iSER/iWARP patches for 
testing/further review.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
