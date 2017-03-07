From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 7 Mar 2017 19:18:40 +0200
Message-ID: <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170306180723.GD11805-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/6/2017 8:07 PM, Jason Gunthorpe wrote:
> On Mon, Mar 06, 2017 at 04:06:43PM +0200, Yishai Hadas wrote:
>> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> This patch drops the need to extend the verbs layer each time with
>> some non generic fields when creating a CQ. It adds an option to set
>> some opaque vendor data in some generic way which can fit any vendor.
>>
>> The solution introduced for creating a CQ but expects to fit for
>> other IB objects as of QP, SRQ, etc.
>>
>> It comes as a pre-patch for supplying some private mlx5 fields in
>> downstream patches.
>>
>> The solution:
>> 1) Introduce a new comp_mask bit (i.e. IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA)
>>    and a matching void* vendor data field.
>>
>> 2) Vendor should expose its header file for direct access with
>>    relevant private structures.
>>
>> 3) Application should supply the input based on vendor-defined structure.
>>
>> 4) Upon getting the private data the vendor will cast to its internal
>>    structure and use the data as part of CQ creation.
>
> I'm not sure I like this, why not create a mlx5dv_create_cq?
>

Below notes justify the suggested scheme comparing adding 
mlx5dv_create_cq() API for that purpose:

1) From developer point of view it's fully preferred to use single API 
(e.g. ibv_create_cq_ex) otherwise developer should choose, do I use 
ibv_create_cq_ex() or mlx5dv_create_cq(). If I use the latter, do I need 
mlx5dv_destroy_cq() or can I use ibv_destroy_cq()...

2) We would like to support this scheme for other calls as well and 
enjoy libibverbs generic services on top, that's can be achieved by the 
suggested scheme.

3) Other vendors can use the suggested scheme without the need to expose 
any xxx_create_cq() API, all that is needed is just to expose direct H 
file, this can be done also by mlx5 customers who don't want to use the 
mlx5_dv direct calls but to enjoy from the option to supply vendor data 
as part of CQ creation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
