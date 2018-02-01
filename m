From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Thu, 1 Feb 2018 20:45:10 +0200
Message-ID: <0911be63-2dec-cf89-d6e9-407fe6e384e1@redhat.com>
References: <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180123202954.GA14007@yuvallap>
 <VI1PR05MB12787572593F02F05AA20DE1B9E10@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180128203746.GA11635@yuvallap> <20180129172717.GW23852@mellanox.com>
 <12d04e1b-6024-0763-f5c5-46ca8b0823a6@redhat.com>
 <20180130154200.GD21679@mellanox.com>
 <76b5a8cf-b3ed-c76d-6157-91fc5f6f2b35@redhat.com>
 <20180131183810.GA23352@mellanox.com>
 <dded9055-a329-9b9d-943a-7a60445e2ada@redhat.com>
 <20180201182959.GN23352@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201182959.GN23352-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/02/2018 20:29, Jason Gunthorpe wrote:
> On Thu, Feb 01, 2018 at 08:22:01PM +0200, Marcel Apfelbaum wrote:
>> On 31/01/2018 20:38, Jason Gunthorpe wrote:
>>> On Wed, Jan 31, 2018 at 02:27:01PM +0200, Marcel Apfelbaum wrote:
>>>
>>>> It is good to know, but still, passing so much information to kernel
>>>> when we can rather "compress" it, maybe it worth a second thought.
>>>
>>> Not sure. Have to see the whole thing..
>>>
>>>>> Well, actually, only a 3rd :| The new MR would likely be 0 based, but
>>>>> the VM guest doesn't know about this. So you'd need an API that can do
>>>>> arbitrary based to really solve your probably. I guess all HW should
>>>>> be able to do this so maybe it is OK?
>>>>
>>>> The way we solve "the other" half is by intercepting the post-send
>>>> requests in hypervisor. At hypervisor level we don't have contiguous virtual
>>>> addresses anymore, but we don't need them for 0 based MRs:
>>>> The guest still register regular MRs, while the hypervisor will
>>>> register a 0 based MR save the guest virtual address of the MR.
>>>> At post-send we simply substract the saved MR base address from the work request
>>>> buffers and we are back to 0 based MR.
>>>
>>
>> Hi Jason,
>>
>>> That only works for lkeys, the rkey expoeses the base address to the
>>> remote - the HV can't fix it..
>>>
>>
>> Thanks for the clarification.
>>
>> What we really need is to allow to map a list of
>> pages to a IOVA different from the process address
>> space, e.g guest supplied IOVA.
>>
>> Something like req_mr (list_of_process_va_pages, base_other_iova, len_other_iova)
>>
>> Do think the new API can support that?
> 
> Well, I think we should have something like this.
> 
> I actually can't see how it could need special HW support, since this
> is basically exactly the same as creating a normal MR.
> 
> And same with 0 based, 'base_other_iova == 0' is the same as zero
> based.
> 

Agreed.

> I think the difference from the proposed API here is this requires
> full OS pages, while Alex's version can do sub-pages too using HW
> features.
> 
> I would urge you to persue an API like you described:
> 
> struct ibv_mr *ib_reg_mr_sg(const void *pages[], size_t num_pages,
>                             uint64_t mr_addr,
> 			    size_t mr_offset, // MR starts at pages[0] + mr)offset
> 			    size_t mr_length,
> 			    unsigned int flags);
> 

Sounds right, thanks for the pointer.
Marcel

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
