From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 17/20] IB/hfi1: Add transmit fault injection feature
Date: Wed, 5 Apr 2017 14:49:20 -0400
Message-ID: <5103c47a-42e0-23fa-a3dc-beeed305e368@intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002619.28538.31428.stgit@scvm10.sc.intel.com>
 <1491417255.2923.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491417255.2923.5.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/05/2017 02:34 PM, Doug Ledford wrote:
> On Mon, 2017-03-20 at 17:26 -0700, Dennis Dalessandro wrote:
>>
>>  #ifdef CONFIG_FAULT_INJECTION
>> +	debugfs_create_bool("fault_suppress_err", 0600,
>> +			    ibd->hfi1_ibdev_dbg,
>> +			    &ibd->fault_suppress_err);
>>  	fault_init_debugfs(ibd);
>>  #endif
>
> ...
>
>> +static u64 hfi1_fault_tx(struct rvt_qp *qp, u8 opcode, u64 pbc)
>> +{
>> +#ifdef CONFIG_HFI1_FAULT_INJECTION
>                  ^Looks like you failed to fix this spot up

Doh! Will fix that up and re-send.

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
