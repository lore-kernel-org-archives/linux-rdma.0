From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 4/6] RDMA/hns: Filter for zero length of sge in
 hip08 kernel mode
Date: Mon, 25 Dec 2017 18:08:08 +0800
Message-ID: <42e22cc6-f385-b6f4-bd14-1450ae19519a@huawei.com>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-5-git-send-email-oulijun@huawei.com>
 <20171225090028.GY2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225090028.GY2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/12/25 17:00, Leon Romanovsky 写道:
> On Sat, Dec 23, 2017 at 04:22:20PM +0800, Lijun Ou wrote:
>> When the length of sge is zero, the driver need to filter it
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 29 ++++++++++++++++++++---------
>>  1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index 869e36f..a1d8ca0 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -230,26 +230,37 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>>  				     V2_RC_SEND_WQE_BYTE_4_INLINE_S, 1);
>>  		} else {
>>  			if (wr->num_sge <= 2) {
>> -				for (i = 0; i < wr->num_sge; i++)
>> -					set_data_seg_v2(dseg + i,
>> -							wr->sg_list + i);
>> +				for (i = 0; i < wr->num_sge; i++) {
>> +					if (likely(wr->sg_list[i].length)) {
>> +						set_data_seg_v2(dseg,
>> +							       wr->sg_list + i);
>> +						dseg++;
> 
> Actually, you don't need to advance desg and keep your "desg + i" code as before.
> 
> I have a more general question, is this scenario (having length == 0) real?
> 
> Thanks
> 
Yes, The origin plan for processing the length of sge is zero is that the hardware recognizes
and filter it. but the final plan is that the software filter it and have an improved performance.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
