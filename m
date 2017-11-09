From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not block QP attr_masks used by older
 kernels
Date: Thu, 9 Nov 2017 15:24:58 +0200
Message-ID: <6c9163c0-a7b2-e75c-f106-8252d11863a2@dev.mellanox.co.il>
References: <20171102215031.GY18874@ziepe.ca>
 <BN3PR07MB2578908EF39AF93B472208ADF8510@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578908EF39AF93B472208ADF8510-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/7/2017 8:21 AM, Amrani, Ram wrote:
>> At least the RDMA CM in 4.3 will give user space structs with these bits
>> set. Those kernels require user space to pass those set bits back to the
>> kernel. Blocking them causes RDMA CM to be unusable on older kernels.
>>
>> Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
>> Reported-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
>> ---
> 
> Thank you, Jason.
> 
> Ram
> 

Thanks, merged.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
