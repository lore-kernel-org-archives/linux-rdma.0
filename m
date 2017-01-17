From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv1 1/1] IB/iser: Fix sg_tablesize calculation
Date: Tue, 17 Jan 2017 11:57:04 +0200
Message-ID: <c6fb227f-b8fe-8c43-493f-4b06c58b5c43@mellanox.com>
References: <1484588681-12987-1-git-send-email-maxg@mellanox.com>
 <1484588681-12987-2-git-send-email-maxg@mellanox.com>
 <cd6691fd-11b4-dbf3-3ec4-12ff97bc515a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd6691fd-11b4-dbf3-3ec4-12ff97bc515a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 1/16/2017 11:03 PM, Sagi Grimberg wrote:
>
>> For devices that can register page list that is bigger than
>> USHRT_MAX, we actually take the wrong value for sg_tablesize.
>> E.g: for CX4 max_fast_reg_page_list_len is 65536 (bigger than USHRT_MAX)
>> so we set sg_tablesize to 0 by mistake. Therefore, each IO that is
>> bigger than 4k splitted to "< 4k" chunks that cause performance
>> degredation.
>>
>> Fixes: 7854550ae6d8 ("RDMA/iser: Limit sgs to the device fastreg depth")
>> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/ulp/iser/iscsi_iser.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
>> b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> index 9104e6b..ff37f19 100644
>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> @@ -656,7 +656,8 @@ static void iscsi_iser_cleanup_task(struct
>> iscsi_task *task)
>>           * max fastreg page list length.
>>           */
>
> Hi Max,
>
>>          shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
>> -
>> ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
>> +                      min_t(unsigned int, USHRT_MAX,
>> +
>> ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len));
>
> Hmm, This looks broken since I fixed up mlx5 capability at:
> 911f4331bc87 ("IB/mlx5: Expose correct max_fast_reg_page_list_len")
>
> However, I suspect this assignment should be removed altogether because
> we already take that into account in the address resolution handler,
> there the min statement is for unsigned and casted back to ushrt.

Hi Sagi,
I can send v2 with assignment removal (there is some work to do in 
iser_calc_scsi_params too) but I think that your commit 911f4331bc87 
broke it accidently and not logically. Think of other providers that 
also may support max_fast_reg_page_list_len > USHRT_MAX (there was no 
such providers till that point in time).

Altought it's not optimal but it's the best solution in competability 
means since there are 4 commits involved in that area (from first to last):
1. 7854550ae6 ("RDMA/iser: Limit sgs to the device fastreg depth")
2. df749cdc45 ("IB/iser: Support up to 8MB data transfer in a single 
command")
3. 911f4331bc ("IB/mlx5: Expose correct max_fast_reg_page_list_len")
4. 9c674815d3 ("IB/iser: Fix max_sectors calculation")

and the last one fixes all the loop.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
