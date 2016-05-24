From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 05/10] IB/core: Introduce Receive Work Queue
 indirection table
Date: Tue, 24 May 2016 10:39:49 +0300
Message-ID: <46a7de86-dffe-e44c-3768-10dfb70e8802@dev.mellanox.co.il>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-6-git-send-email-yishaih@mellanox.com>
 <01ba01d1b515$a18a6f80$e49f4e80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01ba01d1b515$a18a6f80$e49f4e80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/23/2016 8:07 PM, Steve Wise wrote:
>> Introduce Receive Work Queue (WQ) indirection table.
>> This object can be used to spread incoming traffic to different
>> receive Work Queues.
>>
>> A Receive WQ indirection table points to variable size of WQs.
>> This table is given to a QP in downstream patches.
>>
>> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/verbs.c | 62
>> +++++++++++++++++++++++++++++++++++++++++
>>  include/rdma/ib_verbs.h         | 23 +++++++++++++++
>>  2 files changed, 85 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index c096cad..6b548d7 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -1636,6 +1636,68 @@ int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr
>> *wq_attr,
>>  }
>>  EXPORT_SYMBOL(ib_modify_wq);
>>
>> +/*
>> + * ib_create_rwq_ind_table - Creates a RQ Indirection Table.
>> + * @device: The device on which to create the rwq indirection table.
>> + * @ib_rwq_ind_table_init_attr: A list of initial attributes required to
>> + * create the Indirection Table.
>> + *
>> + * Note: The life time of ib_rwq_ind_table_init_attr->ind_tbl is not less
>> + *	than the created ib_rwq_ind_table object and the caller is responsible
>> + *	for its memory allocation/free.
>> + */
>> +struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
>> +						 struct
> ib_rwq_ind_table_init_attr
>> *init_attr)
>> +{
>> +	struct ib_rwq_ind_table *rwq_ind_table;
>> +	int i;
>> +	u32 table_size;
>> +
>> +	if (!device->create_rwq_ind_table)
>> +		return ERR_PTR(-ENOSYS);
>> +
>> +	table_size = (1 << init_attr->log_ind_tbl_size);
>> +	rwq_ind_table = device->create_rwq_ind_table(device,
>> +				init_attr, NULL);
>> +	if (IS_ERR(rwq_ind_table))
>> +		return rwq_ind_table;
>> +
>> +	rwq_ind_table->ind_tbl = init_attr->ind_tbl;
>> +	rwq_ind_table->log_ind_tbl_size = init_attr->log_ind_tbl_size;
>> +	rwq_ind_table->device = device;
>> +	rwq_ind_table->uobject = NULL;
>> +	atomic_set(&rwq_ind_table->usecnt, 0);
>> +
>> +	for (i = 0; i < table_size; i++)
>> +		atomic_inc(&rwq_ind_table->ind_tbl[i]->usecnt);
>
> Hey Yishai,
>
> Why do you need usecnt on the individual tables allocated by the device?  I see
> them inc'd here and dec'd in destroy.  But I don't see them used anywhere else?
>
> Steve.

Look at ib_destroy_wq for this reference count usage.

WQ and indirection table are IB objects that are managed by the IB layer 
for both update/cleanup. Specifically, a WQ can't be cleaned up if there 
is an indirection table that points to. From application point of view 
when it has an handle to an indirection table it assumes that all its 
underlying WQ(s) are valid so the IB layer should prevent any 
destruction of any WQ before releasing the indirection table, this is 
done by the ref count mechanism as done for other related IB objects.
You can look also at ib_uverbs_cleanup_ucontext where upon process 
termination the order of cleanup is first destroying the indirection 
table(s) then going over all WQ(s) and destroy them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
