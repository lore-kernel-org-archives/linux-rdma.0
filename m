From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucma: check workqueue allocation before usage
Date: Thu, 17 Sep 2015 16:14:31 -0400
Message-ID: <55FB1F27.8000604@oracle.com>
References: <1442520259-2248-1-git-send-email-sasha.levin@oracle.com> <1828884A29C6694DAF28B7E6B8A82373A903C056@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A903C056-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/17/2015 04:10 PM, Hefty, Sean wrote:
> What kernel is this patch against?

Patch is against linux-next.


Thanks,
Sasha

>> Allocating a workqueue might fail, which wasn't checked so far and would
>> lead to NULL ptr derefs when an attempt to use it was made.
>>
>> Signed-off-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/ucma.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/ucma.c
>> b/drivers/infiniband/core/ucma.c
>> index a53fc9b..30467d1 100644
>> --- a/drivers/infiniband/core/ucma.c
>> +++ b/drivers/infiniband/core/ucma.c
>> @@ -1624,11 +1624,16 @@ static int ucma_open(struct inode *inode, struct
>> file *filp)
>>  	if (!file)
>>  		return -ENOMEM;
>>
>> +	file->close_wq = create_singlethread_workqueue("ucma_close_id");
>> +	if (!file->close_wq) {
>> +		kfree(file);
>> +		return -ENOMEM;
>> +	}
>> +
>>  	INIT_LIST_HEAD(&file->event_list);
>>  	INIT_LIST_HEAD(&file->ctx_list);
>>  	init_waitqueue_head(&file->poll_wait);
>>  	mutex_init(&file->mut);
>> -	file->close_wq = create_singlethread_workqueue("ucma_close_id");
>>
>>  	filp->private_data = file;
>>  	file->filp = filp;
>> --
>> 1.7.10.4
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
