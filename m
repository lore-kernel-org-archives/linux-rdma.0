From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/15] IB/hfi1: Fix an assign/ordering issue with shared
 context IDs
Date: Wed, 3 May 2017 07:19:54 -0400
Message-ID: <498eaa50-697e-4d4f-764f-adf0318271d1@intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
 <20170503004223.6965.13575.stgit@scvm10.sc.intel.com>
 <20170503073632.GD22833@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503073632.GD22833-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/03/2017 03:36 AM, Leon Romanovsky wrote:
>> +=======
>> +
>> +		/* Find an unused context */
>> +		subctxt = find_first_zero_bit(uctxt->in_use_ctxts,
>> +					      HFI1_MAX_SHARED_CTXTS);
>> +		if (subctxt >= uctxt->subctxt_cnt)
>> +			return -EINVAL;
>> +
>> +>>>>>>> d409d3d... IB/hfi1: Fix an assign/ordering issue with shared context IDs
>>  		fd->uctxt = uctxt;
>
> Again, rebase conflict.
>

I see what happened. Will get it fixed up and resend just this and the 
following patch.

Thanks for catching this Leon.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
