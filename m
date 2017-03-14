From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernull NULL pointer observed on initiator side after 'nvmetcli
 clear' on target side
Date: Tue, 14 Mar 2017 21:27:28 +0800
Message-ID: <7a955472-1975-1b73-c88c-367576a56884@redhat.com>
References: <1053522223.31446389.1488721184925.JavaMail.zimbra@redhat.com>
 <644fc4ab-df6b-a337-1431-bad881ef56ee@grimberg.me>
 <88ae146a-7510-9be0-c9b4-58e70f9d73b9@redhat.com>
 <6ffda302-02f9-12f0-a112-ea7cd20b9ffa@grimberg.me>
 <b0a84bcc-7dca-d342-b30e-b01eba8088cd@redhat.com>
 <6fe6d285-3cb4-c88c-9a7c-741fce54120c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6fe6d285-3cb4-c88c-9a7c-741fce54120c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 03/13/2017 04:09 PM, Sagi Grimberg wrote:
>
>>> Yep... looks like we don't take into account that we can't use all the
>>> queues now...
>>>
>>> Does this patch help:
>> Still can reproduce the reconnect in 10 seconds issues with the patch,
>> here is the log:
>>
>> [  193.574183] nvme nvme0: new ctrl: NQN "nvme-subsystem-name", addr
>> 172.31.2.3:1023
>> [  193.612039] __nvme_rdma_init_request: changing called
>> [  193.638723] __nvme_rdma_init_request: changing called
>> [  193.661767] __nvme_rdma_init_request: changing called
>> [  193.684579] __nvme_rdma_init_request: changing called
>> [  193.707327] __nvme_rdma_init_request: changing called
>> [  193.730071] __nvme_rdma_init_request: changing called
>> [  193.752896] __nvme_rdma_init_request: changing called
>> [  193.775699] __nvme_rdma_init_request: changing called
>> [  193.798813] __nvme_rdma_init_request: changing called
>> [  193.821257] __nvme_rdma_init_request: changing called
>> [  193.844090] __nvme_rdma_init_request: changing called
>> [  193.866472] __nvme_rdma_init_request: changing called
>> [  193.889375] __nvme_rdma_init_request: changing called
>> [  193.912094] __nvme_rdma_init_request: changing called
>> [  193.934942] __nvme_rdma_init_request: changing called
>> [  193.957688] __nvme_rdma_init_request: changing called
>> [  606.273376] Broke affinity for irq 16
>> [  606.291940] Broke affinity for irq 28
>> [  606.310201] Broke affinity for irq 90
>> [  606.328211] Broke affinity for irq 93
>> [  606.346263] Broke affinity for irq 97
>> [  606.364314] Broke affinity for irq 100
>> [  606.382105] Broke affinity for irq 104
>> [  606.400727] smpboot: CPU 1 is now offline
>> [  616.820505] nvme nvme0: reconnecting in 10 seconds
>> [  626.882747] blk_mq_reinit_tagset: tag is null, continue
>> [  626.914000] nvme nvme0: Connect rejected: status 8 (invalid 
>> service ID).
>> [  626.947965] nvme nvme0: rdma_resolve_addr wait failed (-104).
>> [  626.974673] nvme nvme0: Failed reconnect attempt, requeueing...
>
> This is strange...
>
> Is the target alive? I'm assuming it didn't crash here correct?
The target was deleted by 'nvmetcli clear' command.
Then on client side, seems it doesn't know the target side was deleted 
and will always reconnecting in 10 seconds.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
