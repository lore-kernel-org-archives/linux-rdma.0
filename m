From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
 roce_gid_cache
Date: Thu, 19 Feb 2015 17:37:03 +0200
Message-ID: <54E6031F.6090804@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
 <54E5FEDD.2080001@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E5FEDD.2080001-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/19/2015 5:18 PM, Haggai Eran wrote:
> On 20/02/2015 00:02, Somnath Kotur wrote:
>> --- a/drivers/infiniband/core/addr.c
>> +++ b/drivers/infiniband/core/addr.c
>> @@ -458,7 +458,7 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
>>   }
>>
>>   int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
>> -			       u16 *vlan_id)
>> +			       u16 *vlan_id, int if_index)
>>   {
>>   	int ret = 0;
>>   	struct rdma_dev_addr dev_addr;
>> @@ -481,6 +481,7 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
>>   		return ret;
>>
>>   	memset(&dev_addr, 0, sizeof(dev_addr));
>> +	dev_addr.bound_dev_if = if_index;
>
> There's a call to rdma_resolve_ip later in this function. I think it
> overrides the if_index you store here.
>
> I would expect this function to somehow limit the address resolution
> done by rdma_resolve_ip so that the result has to use if_index as a
> source interface.
>

I'm not sure that's correct:
static int addr4_resolve(struct sockaddr_in *src_in,
                          struct sockaddr_in *dst_in,
                          struct rdma_dev_addr *addr)
{
         __be32 src_ip = src_in->sin_addr.s_addr;
         __be32 dst_ip = dst_in->sin_addr.s_addr;
         struct rtable *rt;
         struct flowi4 fl4;
         int ret;

         memset(&fl4, 0, sizeof(fl4));
         fl4.daddr = dst_ip;
         fl4.saddr = src_ip;
         fl4.flowi4_oif = addr->bound_dev_if;

static int addr6_resolve(struct sockaddr_in6 *src_in,
                          struct sockaddr_in6 *dst_in,
                          struct rdma_dev_addr *addr)
{
         struct flowi6 fl6;
         struct dst_entry *dst;
         struct rt6_info *rt;
         int ret;

         memset(&fl6, 0, sizeof fl6);
         fl6.daddr = dst_in->sin6_addr;
         fl6.saddr = src_in->sin6_addr;
         fl6.flowi6_oif = addr->bound_dev_if;


bound_dev_if is the if_index we would like to use.


>>
>>   	ctx.addr = &dev_addr;
>>   	init_completion(&ctx.comp);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
