From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Wed, 8 Mar 2017 00:10:18 +0200
Message-ID: <6da2bd37-62c3-af73-fe81-5be57a327c2d@dev.mellanox.co.il>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
 <20170307181738.GC2228@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307181738.GC2228-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/7/2017 8:17 PM, Jason Gunthorpe wrote:
> On Tue, Mar 07, 2017 at 07:18:40PM +0200, Yishai Hadas wrote:
>
>>> I'm not sure I like this, why not create a mlx5dv_create_cq?
>>>
>>
>> Below notes justify the suggested scheme comparing adding mlx5dv_create_cq()
>> API for that purpose:
>>
>> 1) From developer point of view it's fully preferred to use single API (e.g.
>> ibv_create_cq_ex) otherwise developer should choose, do I use
>
> Why? That isn't right, from a developer point of view it is better to
> have strong type safety so the API is obvious how to use correctly.

Having 2 APIs for similar purpose usually doesn't make sense and might 
bring confusion and code duplication. The mlx5dv_create_cq() from 
application point of view can be used to create a regular CQ when no 
vendor data will be supplied, the idea is to have a single API for clarity.

> How is the developer to know to pass some random mlxdv struct in the
> void *? How do they know when that is even safe to do?

The developer who passes vendor data should compile his code with the 
vendor H file to have the input structure, this is true in both options.

The structure to be used is defined in the vendor H file and its name 
should match the API, in the mlx5 case it's named as 
mlx5dv_create_cq_vendor_data. An explicit comment can be added if it's 
not clear enough. This is the expected behavior for coming vendor 
structures in mlx5 and in any other vendors if will come.

Once the correct structure is used there should be *no* safety issue, 
please note that the vendor data defined to be as some extended 
structure which can only be grown based on comp_mask so that 
compatibility will be saved in any case.


> Other calls can be evaluated when we get to them, but I can't see why
> they would be any better..

Better think from day one on coming ones which may come soon(e.g. QP 
vendor data), the suggested scheme can fit to all objects and prevent 
the need to introduce more APIs each time.

>> 3) Other vendors can use the suggested scheme without the need to expose any
>> xxx_create_cq() API, all that is needed is just to expose direct H file,
>> this can be done also by mlx5 customers who don't want to use the mlx5_dv
>> direct calls but to enjoy from the option to supply vendor data as part of
>> CQ creation.
>
> I don't think this is a positive.

This is an option that can be easily adapted by other vendors.

> Using the dv interface should be obvious and *always* create a
> link-time dependency on the driver. If someone doesn't want to do that
> then they shouldn't use the interface.
>
> This makes it very clear to the user that they are touching a
> non-portable API and they need to plan accordingly.

This is correct for using DV APIs which are fully driver specific but 
its not a must to add an API which is quite similar to the ibv_xxx one.

> We have caused ourselves alot of pain by trying to be too clever with
> function pointers in the past. That totally defeats the usual symver
> mechanism for compatability and should *NOT* be done by this dv stuff.

That's why we want to prevent from new APIs when really not required.

I believe that we should get input from Doug and other people re the 
above discussion.

Doug,
Can we get please your input here ?

Thanks,
Yishai


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
