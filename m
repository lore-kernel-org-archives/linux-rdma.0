From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/srp: Fix a memory descriptor leak in an error path
Date: Wed, 11 May 2016 08:19:37 -0700
Message-ID: <57334D89.5050004@sandisk.com>
References: <573278D9.4050908@sandisk.com> <57327921.9030306@sandisk.com>
 <20160511073127.GC25215@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511073127.GC25215-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/2016 12:31 AM, Leon Romanovsky wrote:
> On Tue, May 10, 2016 at 05:13:21PM -0700, Bart Van Assche wrote:
>> If an error occurs after srp_fr_pool_get() succeeded and before the
>> descriptor is stored in srp_map_state (*state->fr.next++ = desc)
>> then srp_unmap_data() won't free the newly allocated memory
>> descriptor. Hence free the descriptor explicitly.
>>
>> Fixes: f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Sagi Grimberg <sai-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index e088a49..74e3ec8 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -1330,8 +1330,13 @@ static int srp_map_finish_fr(struct srp_map_state *state,
>>   	ib_update_fast_reg_key(desc->mr, rkey);
>>
>>   	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, 0, dev->mr_page_size);
>> -	if (unlikely(n < 0))
>> +	if (unlikely(n < 0)) {
>
> The ib_map_mr_sg can return 0 which is not error, but still pretty
> useless number of mapped SGE. I didn't look on the srp code close enough, but will
> the code handle this case correctly?

Hello Leon,

ib_map_mr_sg() can only return 0 after patch 4/6 of this series has been 
applied. xfstests triggers I/O requests that are large enough to make 
ib_map_mr_sg() return 0 when enabling register_always and when using 
fast registration with an mlx4 HCA. This is because for mlx4 the number 
of pages per fast registration request is limited to 511. 511 * 4096 = 
2044 KB. This is less than the value I used for max_sectors in my tests 
(4 MB).

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
