From: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: pr_err() strings should end with newlines
Date: Tue, 26 Sep 2017 13:01:33 +0530
Message-ID: <f074c8aa-abbd-096e-b22c-8c71c1efe029@gmail.com>
References: <28298577a7f6111b2d40780dddd3c87a32168ab7.1506408446.git.arvind.yadav.cs@gmail.com>
 <20170926071920.GD5825@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926071920.GD5825@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,


On Tuesday 26 September 2017 12:49 PM, Yuval Shaia wrote:
> On Tue, Sep 26, 2017 at 12:21:44PM +0530, Arvind Yadav wrote:
>> pr_err() messages should end with a new-line to avoid other messages
>> being concatenated.
>>
>> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> index 66056f9..e528d7a 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
>> @@ -658,7 +658,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
>>   		if (reset) {
>>   			status = ocrdma_mbx_rdma_stats(dev, true);
>>   			if (status) {
>> -				pr_err("Failed to reset stats = %d", status);
>> +				pr_err("Failed to reset stats = %d\n", status);
>>   				goto err;
>>   			}
>>   		}
> While there, can you also fix line 1096 in ocrdma_hw.c?
>
> (is it too naive to expect checkptahc to catch such errors?)
As per your suggestion, I have done  the changes.
>
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
~arvind
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
