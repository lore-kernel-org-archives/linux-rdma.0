From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] IB/rdamvt: Fix rdmavt s_ack_queue sizing
Date: Wed, 25 May 2016 15:05:37 -0400
Message-ID: <20160525190536.GC24021@phlsvsds.ph.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com> <20160524195039.19706.66866.stgit@scvm10.sc.intel.com> <20160525182928.GP25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160525182928.GP25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 09:29:28PM +0300, Leon Romanovsky wrote:
>On Tue, May 24, 2016 at 12:50:40PM -0700, Dennis Dalessandro wrote:
>> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> rdmavt allows the driver to specify the size of the ack queue, but
>> only uses it for the modify QP limit testing for setting the atomic
>> limit value.
>> 
>> The driver dependent size is now used to size the s_ack_queue ring
>> dynamicially.
>> 
>> Since the driver knows its size, the driver will use its define
>> for any ring size dependent code.
>> 
>> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rdmavt/qp.c |   22 ++++++++++++++++++++--
>>  include/rdma/rdma_vt.h            |    9 +++++++++
>>  include/rdma/rdmavt_qp.h          |    5 +----
>>  3 files changed, 30 insertions(+), 6 deletions(-)
>> 
>
>...
>
>>  /*
>> + * Return the max atomic suitable for determining
>> + * the size of the ack ring buffer in a QP.
>> + */
>> +static inline unsigned int rvt_max_atomic(struct rvt_dev_info *rdi)
>> +{
>
>In previous patch, you changed max_rdma_atomic to be u8 instead of int,
>so why are you returning unsigned int and not u8?
>
>> +	return rdi->dparms.max_rdma_atomic + 1;
>> +}
>> +

Because of the "+1", so we don't have a wrapping issue. 255 is a valid 
value.  Now we could bump it up to a u16 vs int if it matters that much.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
