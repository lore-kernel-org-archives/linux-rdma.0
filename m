From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 11:55:33 +0200
Message-ID: <564AF995.1000507@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564AE06C.9020504@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564AE06C.9020504-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 10:08, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>> @@ -847,7 +847,7 @@ static void iser_route_handler(struct rdma_cm_id
>> *cma_id)
>>       conn_param.rnr_retry_count     = 6;
>>       memset(&req_hdr, 0, sizeof(req_hdr));
>> -    req_hdr.flags = (ISER_ZBVA_NOT_SUP | ISER_SEND_W_INV_NOT_SUP);
>> +    req_hdr.flags = ISER_ZBVA_NOT_SUP;
>
> isn't there a property of the **local** device we need to check before
> advertizing that
> to the target? to be on the safe side, I would do  that only over
> devices that support
> IB_DEVICE_MEM_MGT_EXTENSIONS, as non-local invalidations are part of the
> BMME ext
> of IBTA, right?

This was dependent on using fastreg (which depends on
IB_DEVICE_MEM_MGT_EXTENSIONS) at some point but it must have got lost
at some point..

Will fix. Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
