From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/srp: allocate ib_qp_attr on the stack
Date: Wed, 28 Dec 2016 13:33:42 +0200
Message-ID: <e10beb7f-a2eb-8a20-c764-c14720ff19da@mellanox.com>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
 <1482922813-8392-2-git-send-email-maxg@mellanox.com>
 <20161228111450.GB4735@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228111450.GB4735@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>
> Since kzmalloc was not used this patch do the job it intend to do.
> Do you think, while-we-are-there that it will be safer to use memset before
> using the object?
>

You're safe because of the flags you pass to ib_modify_qp, but we can 
add it.
Bart, what do you think ?

>> +	attr.qp_access_flags = (IB_ACCESS_REMOTE_READ |
>>  				    IB_ACCESS_REMOTE_WRITE);
>> -	attr->port_num        = target->srp_host->port;
>> +	attr.port_num        = target->srp_host->port;
>>
>> -	ret = ib_modify_qp(qp, attr,
>> +	ret = ib_modify_qp(qp, &attr,
>>  			   IB_QP_STATE		|
>>  			   IB_QP_PKEY_INDEX	|
>>  			   IB_QP_ACCESS_FLAGS	|
>>  			   IB_QP_PORT);
>>
>>  out:
>> -	kfree(attr);
>>  	return ret;
>>  }
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
