From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Sat, 06 Feb 2010 10:45:22 -0600
Message-ID: <4B6D9CA2.3000304@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6D9948.6040007-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'Jeff Squyres (jsquyres)'" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Note, even though this patch resolved the openmpi failure on my iwarp 
nodes, ucmatose -b 127.0.0.1 doesn't fail.  I haven't looked at the src, 
but something funny must be happening.

So we still have a regression issue with ofed-1.5.1/upstream kernels and 
openmpi over IB with rdmacm.

Steve.


Steve Wise wrote:
>
>> rdma/cm: disallow loopback address for iwarp devices
>>
>> From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> The current RDMA iWarp devices cannot be used to establish
>> connections using the loopback address.  Prevent rdma_bind_addr
>> from associating the loopback address with an iWarp device.
>>
>> This fixes an issue with openmpi, where it tries to identify which
>> IP addresses map to RDMA devices by calling rdma_bind_addr on
>> each address and seeing if the bind succeeds.  Prior to patch
>> 6f8372b6 "RDMA/cm: fix loopback address support", this process
>> worked.  But the rdma_cm now allows rdma_bind_addr to bind to an
>> RDMA device using the loopback address, and attaches the rdma_cm_id
>> to the RDMA device as part of the bind.
>>
>> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>
>>  drivers/infiniband/core/cma.c |   14 ++++++++++----
>>  1 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c 
>> b/drivers/infiniband/core/cma.c
>> index cc9b594..5850411 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -1739,6 +1739,9 @@ err:
>>  }
>>  EXPORT_SYMBOL(rdma_resolve_route);
>>  
>> +/*
>> + * Only IB devices support loopback connections.
>> + */
>>  static int cma_bind_loopback(struct rdma_id_private *id_priv)
>>  {
>>      struct cma_device *cma_dev;
>> @@ -1753,11 +1756,16 @@ static int cma_bind_loopback(struct 
>> rdma_id_private *id_priv)
>>          ret = -ENODEV;
>>          goto out;
>>      }
>> -    list_for_each_entry(cma_dev, &dev_list, list)
>> +    list_for_each_entry(cma_dev, &dev_list, list) {
>> +        if (rdma_node_get_transport(cma_dev->device->node_type) !=
>> +            RDMA_TRANSPORT_IB)
>> +            continue;
>> +
>>          for (p = 1; p <= cma_dev->device->phys_port_cnt; ++p)
>>              if (!ib_query_port(cma_dev->device, p, &port_attr) &&
>>                  port_attr.state == IB_PORT_ACTIVE)
>>                  goto port_found;
>> +    }
>>   
>
> Here you need to:
>                    ret = -ENODEV;
>                    goto out;
>
> instead of:
>>  
>>      p = 1;
>>      cma_dev = list_entry(dev_list.next, struct cma_device, list);
>>   
>
> Otherwise it will still bind to the first device even if its iwarp...
>
> With this mod, it works.
>
>> @@ -1771,9 +1779,7 @@ port_found:
>>      if (ret)
>>          goto out;
>>  
>> -    id_priv->id.route.addr.dev_addr.dev_type =
>> -        (rdma_node_get_transport(cma_dev->device->node_type) == 
>> RDMA_TRANSPORT_IB) ?
>> -        ARPHRD_INFINIBAND : ARPHRD_ETHER;
>> +    id_priv->id.route.addr.dev_addr.dev_type = ARPHRD_INFINIBAND;
>>  
>>      rdma_addr_set_sgid(&id_priv->id.route.addr.dev_addr, &gid);
>>      ib_addr_set_pkey(&id_priv->id.route.addr.dev_addr, pkey);
>>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
