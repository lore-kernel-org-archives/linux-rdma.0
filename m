From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 14 Mar 2017 17:14:55 +0200
Message-ID: <b60069df-4c2f-6378-b9cb-b5e74acc8185@dev.mellanox.co.il>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
 <20170307181738.GC2228@obsidianresearch.com>
 <6da2bd37-62c3-af73-fe81-5be57a327c2d@dev.mellanox.co.il>
 <20170307222228.GB15314@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307222228.GB15314-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/8/2017 12:22 AM, Jason Gunthorpe wrote:
> It is very common to have 'basic' and 'complex' API entry points. I
> don't see a problem here.

It's not an issue of 'basic' and 'complex' API but a question of code 
sharing and resource managing.

Using *one* API (i.e. ibv_create_cq_ex) shares the libibverbs code on 
the creation path. Look at current code at '__lib_ibv_create_cq_ex()', 
it manages locking, ref_counting and set the IB attributes, in the 
future it may do other shared stuff as well.

Creating common IB objects as of CQ/QP/etc. with some vendor specific 
API might end-up with code duplication, missing functionality or even 
might lead to some bugs as of out-of-sync with the main path creation
of libibverbs.

Think about future feature of resource tracking per context as of
handling recovery/error flow on its objects upon getting a device fatal 
event, collecting statistics on its open objects ,etc.
We expect a shared code for the above in few places in libibverbs. Being 
part of the standard flow should guarantee that any future feature will 
be added automatically without a special care from any vendor. As the 
underlay object is really an IB standard object it makes sense to have a 
single API for its creation.

>> Once the correct structure is used there should be *no* safety issue, please
>> note that the vendor data defined to be as some extended structure which can
>> only be grown based on comp_mask so that compatibility will be saved in any
>> case.
>
> No, you still have to make sure that your ib_device is somehow a mlx5.

We are talking on an application that previously read some vendor 
capabilities using a direct API (e.g. mlx5dv_query_device) to know 
whether the vendor functionality is supported.
As same ibv_context is used in both APIs (e.g. mlx5dv_query_device, 
ibv_create_cq_ex) it should be very clear to application's writer which 
vendor is used.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
