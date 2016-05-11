From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
Date: Wed, 11 May 2016 08:22:29 -0700
Message-ID: <57334E35.3010403@sandisk.com>
References: <573278D9.4050908@sandisk.com> <57327981.4080404@sandisk.com>
 <20160511075359.GE25215@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511075359.GE25215-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/2016 12:54 AM, Leon Romanovsky wrote:
> On Tue, May 10, 2016 at 05:14:57PM -0700, Bart Van Assche wrote:
>> The SRP initiator allows to set max_sectors to a value that exceeds
>> the largest amount of data that can be mapped at once with an mlx4
>> HCA using fast registration and a page size of 4 KB. Hence modify
>> ib_map_mr_sg() such that it can map partial sg-elements. If an
>> sg-element has been mapped partially, let the caller know
>> which fraction has been mapped by adjusting *sg_offset.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -1752,10 +1752,11 @@ static int
>>   mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>>   		   struct scatterlist *sgl,
>>   		   unsigned short sg_nents,
>> -		   unsigned int sg_offset)
>> +		   unsigned int *sg_offset_p)
>>   {
>
> I wonder on which tree are you basing?
> In Linus (4.6-rc7) the function signature is different [1], the same
> goes for my tree and Doug's for-4.7 branch [2].

Hello Leon,

Sorry that I hadn't mentioned this explicitly in the cover letter of 
this patch series but this patch series is based on Christoph's generic 
RDMA READ/WRITE API work.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
