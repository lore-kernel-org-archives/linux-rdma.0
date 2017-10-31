From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Tue, 31 Oct 2017 19:06:05 +0200
Message-ID: <6e7e94e2-9b50-bfa4-a06a-b2452e1bc8a5@dev.mellanox.co.il>
References: <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca> <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca> <20171030152815.GA16127@mtr-leonro.local>
 <20171030155236.GC12392@ziepe.ca> <20171030190952.GC16127@mtr-leonro.local>
 <20171030230753.GB4081@ziepe.ca> <20171031050802.GE16127@mtr-leonro.local>
 <13d687d9-80b4-621e-87bf-c6045da98c0c@dev.mellanox.co.il>
 <20171031154046.GB9852@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171031154046.GB9852-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2017 5:40 PM, Jason Gunthorpe wrote:
> On Tue, Oct 31, 2017 at 01:31:28PM +0200, Yishai Hadas wrote:
>> On 10/31/2017 7:08 AM, Leon Romanovsky wrote:
>>> On Mon, Oct 30, 2017 at 05:07:53PM -0600, Jason Gunthorpe wrote:
>>>> On Mon, Oct 30, 2017 at 09:09:52PM +0200, Leon Romanovsky wrote:
>>>>
>>>>> However, I don't think that kernel to libibverbs API should follow the
>>>>> same path. The centralized entry points to the kernel provides better
>>>>> enforcement and minimizes system call bloat.
>>>>
>>>> How so? I didn't think selinux intersected with the CQs at all..
>>>> I've never worried about the # of verbs entries, we have so many
>>>> already.
>>>
>>> Not SELinux enforcement, but various copy_{to|from}_user checks, unified
>>> return values, easy folding in case of errors, e.t.c.
>>>
>>> It is a matter of personal view and less technical thing. You prefer bazillion
>>> entry points to the kernel and I think that such design good for user-space only,
>>> and mostly not applicable for kernel<->user interfaces.
>>
>> Even for the user area having a dedicated 'setter' per field might bring
>> some redundant overhead and limitation.
> 


>> This will prevent the option from application to modify few fields
>> in one API and resulted in a system call per field.
> 
> And this is always the argument someone brings up - and as I said, I
> don't see how it really applies to the CQ where we don't expect to
> create them at a high rate.

The above argument could be issued also on SRQ/WQ which are not expected 
to be changed in a high rate but uses the attr_mask notation with one 
system call.

As this is currently the spirit of modify_xxx verbs in both user and 
kernel, we may stay with that and consider this change for verbs2.0 all 
around when it will come.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
