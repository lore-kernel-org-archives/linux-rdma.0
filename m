From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Wed, 31 Jan 2018 14:27:01 +0200
Message-ID: <76b5a8cf-b3ed-c76d-6157-91fc5f6f2b35@redhat.com>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
 <20180111122206.GB2800@yuvallap> <20180111164455.GA1309@ziepe.ca>
 <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180123202954.GA14007@yuvallap>
 <VI1PR05MB12787572593F02F05AA20DE1B9E10@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180128203746.GA11635@yuvallap> <20180129172717.GW23852@mellanox.com>
 <12d04e1b-6024-0763-f5c5-46ca8b0823a6@redhat.com>
 <20180130154200.GD21679@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130154200.GD21679-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/01/2018 17:42, Jason Gunthorpe wrote:
> On Tue, Jan 30, 2018 at 01:35:21PM +0200, Marcel Apfelbaum wrote:
>> On 29/01/2018 19:27, Jason Gunthorpe wrote:
>>> On Sun, Jan 28, 2018 at 10:37:47PM +0200, Yuval Shaia wrote:
>>>
>>
>> Hi Jason,
>>
>>>> But let's try to take it one step further, what if all my buffers are the
>>>> same size, of even better, all are PAGE_SIZE. So in case of "composite"
>>>> array of let's say 262144 elements i would have wasteful 262144 * 8 bytes.
>>>>
>>>> This problem could be solved with a bitmap to a given range where only the
>>>> bits that are set composed the MR.
>>>
>>> You want this for the host on virtualization right?
>>
>> Yes. (actually is more about us needing rather that wanting :) )
>>
>>> Like we talked
>>> about at plumbers?
>>>> Is it really necessary to be so optimal? A list of SGLs is not good
>>> enough?
>>
>> It is not. We think the list would need to be limited to a single page,
>> (system calls limitation? maybe we are wrong?)
> 
> The new ioctl interface isn't really limited.
> This new API(s) will run over ioctl.
> 

It is good to know, but still, passing so much information to kernel
when we can rather "compress" it, maybe it worth a second thought.


>> By the way, doing that would only solve half of our problem.
> 
> Well, actually, only a 3rd :| The new MR would likely be 0 based, but
> the VM guest doesn't know about this. So you'd need an API that can do
> arbitrary based to really solve your probably. I guess all HW should
> be able to do this so maybe it is OK?

The way we solve "the other" half is by intercepting the post-send
requests in hypervisor. At hypervisor level we don't have contiguous virtual
addresses anymore, but we don't need them for 0 based MRs:
The guest still register regular MRs, while the hypervisor will
register a 0 based MR save the guest virtual address of the MR.
At post-send we simply substract the saved MR base address from the work request
buffers and we are back to 0 based MR.

> 
>> The other problem is what is happening on post-send. We don't have a
>> virtually contiguous range to pass to post-send, and breaking the
>> Work Request into several work requests using pages as boundaries
>> will become again a problem if we want to send a big chunk (the HW
>> has a rather limited max sg elements).  We can solve it by using 0
>> based MRs, do you know if the current HW supports it?
> 
> I think some does.
> 

Do you have a model in mind? We would really want to try it out.

By the way, I tried to search in the kernel for vendors implementing it
and I saw maybe one vendor... so maybe 0 based MR is a nice idea but nothing more.

Thanks,
Marcel

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
