From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/7] Fix an infinite loop in the SRP initiator
Date: Wed, 28 Oct 2015 08:32:46 -0700
Message-ID: <5630EA9E.30304@sandisk.com>
References: <562FF404.7000504@sandisk.com> <5630A454.40604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5630A454.40604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/28/2015 03:32 AM, Sagi Grimberg wrote:
>> Submitting a SCSI request through the SG_IO mechanism with a scatterlist
>> that is longer than what is supported by the SRP initiator triggers an
>> infinite loop. This patch series fixes that behavior.
>>
>> The individual patches in this series are as follows:
>>
>> 0001-IB-srp-Fix-a-spelling-error.patch
>> 0002-IB-srp-Document-srp_map_data-return-value.patch
>> 0003-IB-srp-Rename-work-request-ID-labels.patch
>> 0004-IB-srp-Fix-a-potential-queue-overflow-in-an-error-pa.patch
>> 0005-IB-srp-Fix-srp_map_data-error-paths.patch
>> 0006-IB-srp-Introduce-target-mr_pool_size.patch
>> 0007-IB-srp-Avoid-that-mapping-failure-triggers-an-infini.patch
>
> I didn't look at the patches yet but are these patches on top of
> the registration changes I posted for 4.4? I am hoping Doug will merge
> them so if they aren't it might be a good idea to respin the series on
> top of that.

Hello Sagi,

These patches have been prepared on top of v4.3-rc7. Doug, did I see 
correctly that you have not yet queued Sagi's registration API changes 
for the v4.4 merge window ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
