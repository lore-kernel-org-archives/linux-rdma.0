From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 15/20] IB/hfi1: Permanently enable P_Key checking in HFI
Date: Mon, 29 May 2017 19:16:00 -0400
Message-ID: <d2746da9-96f9-9724-0288-c5c2be4acd8c@intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171658.10579.67996.stgit@scvm10.sc.intel.com>
 <20170415145317.GM1343@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170415145317.GM1343-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/15/2017 10:53 AM, Leon Romanovsky wrote:
>>   	ppd->pkeys[default_pkey_idx] = DEFAULT_P_KEY;
>> +	ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
>> +	ppd->part_enforce |= HFI1_PART_ENFORCE_OUT;
>> +
> 
> Isn't better just remove these enforcement checks if it always should be performed?
> 
> ➜  linux-rdma git:(rdma-next) git grep part_enforce drivers/infiniband/
> drivers/infiniband/hw/hfi1/hfi.h:       u8 part_enforce; /* partition enforcement flags */
> drivers/infiniband/hw/hfi1/hfi.h:       if (!(ppd->part_enforce & HFI1_PART_ENFORCE_IN))
> drivers/infiniband/hw/hfi1/hfi.h:       if (!(ppd->part_enforce & HFI1_PART_ENFORCE_IN))
> drivers/infiniband/hw/hfi1/mad.c:       if (ppd->part_enforce & HFI1_PART_ENFORCE_IN)
> drivers/infiniband/hw/hfi1/mad.c:       if (ppd->part_enforce & HFI1_PART_ENFORCE_OUT)
> drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
> drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce &= ~HFI1_PART_ENFORCE_IN;
> drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce |= HFI1_PART_ENFORCE_OUT;
> drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce &= ~HFI1_PART_ENFORCE_OUT;
> drivers/infiniband/hw/hfi1/verbs.c:     if (!(ppd->part_enforce & HFI1_PART_ENFORCE_OUT))

I agree with you, but I have asked Neel to do a bit of due diligence and 
make sure this is indeed what we actually want to do. Thanks for 
pointing this out.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
