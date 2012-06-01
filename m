From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: do not crash when peer address is 0.0.0.0
Date: Fri, 01 Jun 2012 13:50:28 -0500
Message-ID: <4FC90EF4.9050600@opengridcomputing.com>
References: <1337287913-7294-1-git-send-email-cascardo@linux.vnet.ibm.com> <4FC8E4E5.7060501@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC8E4E5.7060501-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/01/2012 10:51 AM, Steve Wise wrote:
> On 05/17/2012 03:51 PM, Thadeu Lima de Souza Cascardo wrote:
>> When using rping -c -a 0.0.0.0 with iw_cxgb4, the system crashes when
>> rdma_connect is called. ip_dev_find will return NULL, but pdev is
>> accessed anyway.
>>
>> Checking that pdev is NULL and returning -ENODEV prevents the system
>> from crashing.
>>
>> Signed-off-by: Thadeu Lima de Souza 
>> Cascardo<cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/cxgb4/cm.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c 
>> b/drivers/infiniband/hw/cxgb4/cm.c
>> index 92b4c2b..0e75e30 100644
>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>> @@ -1572,6 +1572,10 @@ static int import_ep(struct c4iw_ep *ep, 
>> __be32 peer_ip, struct dst_entry *dst,
>>           struct net_device *pdev;
>>
>>           pdev = ip_dev_find(&init_net, peer_ip);
>> +        if (!pdev) {
>> +            err = -ENODEV;
>> +            goto out;
>> +        }
>>           ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
>>                       n, pdev, 0);
>>           if (!ep->l2t)
>
> This patch seems good, but I'm curious why the cm passed this down to 
> the iwarp driver?  0.0.0.0 shouldn't have mapped to any device, eh?
>
>

Apparently 0.0.0.0 gets treated as a loopback address by the CMA.  The 
CMA picks the first available device in this case (see 
cma_bind_loopback()).  The T4 driver then lookups up in the neighbour 
table for this address and gets back the 'lo' interface, which is fine.  
Then the T4 driver calls ip_dev_find() on this address to attempt to 
find the correct T4 interface.  It assumed the dest ipaddr, though, is 
the t4 interface ip addr.  Not 0.0.0.0 (nor 127.0.0.1).  Of course 
ip_dev_find() finds no interface with the dest address of 0.0.0.0.

So either T4 fails this usage as you have done in your patch, or we 
change T4 to pick the an ip address of the T4 interface and use that for 
the connection.

Given I don't think anyone is doing rdma connections intentionally to 
0.0.0.0, I say:

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Roland, can you please merge this?

Steve


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
