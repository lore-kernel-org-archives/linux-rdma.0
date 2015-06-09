From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Get rid of redundant verb ib_destroy_mr
Date: Tue, 09 Jun 2015 11:46:29 +0300
Message-ID: <5576A7E5.4040207@dev.mellanox.co.il>
References: <1433769283-30541-1-git-send-email-sagig@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373A8FE5D77@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE5D77-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/9/2015 1:55 AM, Hefty, Sean wrote:
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -1174,6 +1174,18 @@ static int clean_mr(struct mlx5_ib_mr *mr)
>>   	int umred = mr->umred;
>>   	int err;
>>
>> +	if (mr->sig) {
>> +		if (mlx5_core_destroy_psv(dev->mdev,
>> +					  mr->sig->psv_memory.psv_idx))
>> +			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
>> +				     mr->sig->psv_memory.psv_idx);
>> +		if (mlx5_core_destroy_psv(dev->mdev,
>> +					  mr->sig->psv_wire.psv_idx))
>> +			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
>> +				     mr->sig->psv_wire.psv_idx);
>> +		kfree(mr->sig);
>> +	}
>> +
>>   	if (!umred) {
>>   		err = destroy_mkey(dev, mr);
>>   		if (err) {
>
> This patch doesn't introduce this problem, but the err check suggests that deregistration can fail for some reason.
> If so, should mr->sig be cleared above, so that a second call to dereg doesn't attempt to free the memory twice?
>

Hi Sean,

clean_mr() failure is not propagated back at the moment, but you are
correct, it's not a good idea to rely on that. I'll clear mr->sig in
v2.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
