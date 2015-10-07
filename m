From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Wed, 7 Oct 2015 08:46:09 -0700
Message-ID: <56153E41.10607@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <560AE099.2080004@sandisk.com> <560AFB71.3010003@dev.mellanox.co.il>
 <560C30F4.50900@sandisk.com> <560C42CE.6090000@sandisk.com>
 <560CDDBC.8000400@dev.mellanox.co.il> <560D730C.9000302@sandisk.com>
 <560D9E69.70604@sandisk.com>
 <35618B90-4D6E-4036-A69B-4405F020D440@dev.mellanox.co.il>
 <560EA4A1.3080709@sandisk.com> <56138854.4040209@dev.mellanox.co.il>
 <561417B9.2080505@sandisk.com> <5614BECF.9030907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5614BECF.9030907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/06/2015 11:42 PM, Sagi Grimberg wrote:
> On 10/6/2015 9:49 PM, Bart Van Assche wrote:
>> On 10/06/2015 01:37 AM, Sagi Grimberg wrote:
>>> I see now the error you are referring to.
>>>
>>> The issue is that the device requires the MR page array to have
>>> an alignment (0x40 for mlx4 and 0x400 for mlx5). When I modified the
>>> page array allocation to be non-coherent I didn't take care of
>>> alignment.
>>>
>>> Taking care of this alignment may result in a higher order allocation
>>> as we'd need to add (alignment - 1) to the allocation size.
>>>
>>> e.g. a 512 pages on mlx4 will become:
>>> 512 * 8 + 0x40 - 1 = 4159
>>>
>>> I'm leaning towards this approach. Any preference?
>>>
>>> I think this patch should take care of mlx4:
>>> [ ... ]
>>
>> Hello Sagi,
>>
>> Thanks for the patch. But since the patch included in the previous
>> e-mail mapped a memory range that could be outside the bounds of the
>> allocated memory I have been testing the patch below:
>
> Thanks! I correct the patches.
>
> Can I take it as your Tested-by on srp?

Sure :-) But please keep in mind that I currently only have access to 
ConnectX-3 HCA's for testing RDMA software and not to any other RDMA HCA 
model.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
