From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 9/9] IB/srp: Add fast registration support
Date: Wed, 14 May 2014 10:51:58 +0200
Message-ID: <53732EAE.9010207@acm.org>
References: <53722E4F.7070709@acm.org> <53722FE2.4010808@acm.org> <53724CC9.6080509@dev.mellanox.co.il> <537315CC.1090001@acm.org> <537326BF.3010706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537326BF.3010706-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/14/14 10:18, Sagi Grimberg wrote:
> On 5/14/2014 10:05 AM, Bart Van Assche wrote:
>> On 05/13/14 18:48, Sagi Grimberg wrote:
>>> On 5/13/2014 5:44 PM, Bart Van Assche wrote:
>>>> +    memcpy(desc->frpl->page_list, state->pages,
>>>> +           sizeof(state->pages[0]) * state->npages);
>>> I would really like to avoid this memcpy. Any chance we can map directly
>>> to frpl->page_list instead ?
>> Avoiding this memcpy() would be relatively easy if all memory that is
>> holding data for a SCSI command would always be registered. However,
>> since if register_always == false the fast registration algorithm in
>> this patch only allocates an rkey if needed (npages > 1) and since how
>> many pages are present in a mapping descriptor is only known after
>> state->pages[] has been filled in, eliminating that memcpy would be
>> challenging.
> 
> Yes I see, But since the only constraint that forces us to do this
> memcpy is the current code logic,
> I would like to see a /* TODO */ here to remind us that we should
> re-think on how to avoid this.

Can you explain why you consider eliminating that memcpy() statement so
important ? If e.g. the page cache submits an sg-list with 255 pages
each 4 KB in size and in the case all these pages are scattered then 255
* 4096 = 1044480 data bytes have to be transferred from main memory to
HCA. In that case the above memcpy() statement copies an additional 255
* 8 = 2040 bytes. That's an overhead of about 0.2%.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
