From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix RDMA port validation for iWarp
Date: Thu, 7 Jan 2016 11:21:10 +0200
Message-ID: <CAAKD3BAwveK3gRMZTwSs90D4bh05P01BD+9Ot3MkPsUOs21iCQ@mail.gmail.com>
References: <1452085579-7421-1-git-send-email-matanb@mellanox.com>
	<568D45C4.8030600@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568D45C4.8030600-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 6, 2016 at 6:50 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 1/6/2016 7:06 AM, Matan Barak wrote:
>>
>> cma_validate_port wrongly assumed that Ethernet devices are RoCE
>> devices and thus their ndev should be matched in the GID table.
>> This broke the iWrap support. Fixing that matching the ndev only if
>
>
> Typo "iWrap"
>

Thanks, I fixed the spelling mistake.

> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
>
>> we work on a RoCE port.
>>
>> Fixes: abae1b71dd37 ('IB/cma: cma_validate_port should verify the port
>>                      and netdevice')
>> Reported-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Tested-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>
>> Hi Doug,
>>
>> This patch fixes an iWarp issue that was introduced in the RoCE
>> refactoring series.
>>
>> Regards,
>> Matan
>>
>>   drivers/infiniband/core/cma.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index 2d762a2..17a15c5 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -453,7 +453,7 @@ static inline int cma_validate_port(struct ib_device
>> *device, u8 port,
>>         if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device,
>> port))
>>                 return ret;
>>   -     if (dev_type == ARPHRD_ETHER)
>> +       if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
>>                 ndev = dev_get_by_index(&init_net, bound_if_index);
>>         ret = ib_find_cached_gid_by_port(device, gid, port, ndev, NULL);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
