From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: Fix indirect data buffer rkey endianness
Date: Wed, 2 Dec 2015 11:32:26 +0200
Message-ID: <565EBAAA.90405@dev.mellanox.co.il>
References: <565DE3EC.2070002@sandisk.com> <565DE487.2010803@sandisk.com>
 <565DE8F7.5060100@dev.mellanox.co.il> <565DEB13.6040508@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DEB13.6040508-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>>> b/drivers/infiniband/ulp/srp/ib_srp.c
>>> index 72fac20..fac1423 100644
>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>> @@ -1662,7 +1662,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd,
>>> struct srp_rdma_ch *ch,
>>>               return ret;
>>>           req->nmdesc++;
>>>       } else {
>>> -        idb_rkey = target->global_mr->rkey;
>>> +        idb_rkey = cpu_to_be32(target->global_mr->rkey);
>>>       }
>>
>> Wouldn't it make more sense to define idb_rkey to be u32 and change
>> endianness when assigning it to the indirect desc?
>
> Hello Sagi,
>
> That's possible, but that would cause the endianness of the indirect
> data buffer rkey to be changed three times - a first time in
> srp_map_desc(), a second time in srp_map_idb() and a third time in
> srp_map_data(). Hence the choice to fix the IDB rkey via the above patch.

Fine with me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
