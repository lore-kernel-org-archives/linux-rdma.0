From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Sat, 21 May 2016 12:23:02 -0400
Message-ID: <20160521162301.GA16770@phlsvsds.ph.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com> <20160519122622.22041.41686.stgit@scvm10.sc.intel.com> <20160521123404.GB25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160521123404.GB25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 21, 2016 at 03:34:04PM +0300, Leon Romanovsky wrote:
>On Thu, May 19, 2016 at 05:26:24AM -0700, Dennis Dalessandro wrote:
>> IOCTL is more suited to what user space commands need to do than the
>> write() interface. Add IOCTL definitions for all existing write commands
>> and the handling for those. The write() interface will be removed in a
>> follow on patch.
>> 
>> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/staging/rdma/hfi1/common.h   |    5 +
>>  drivers/staging/rdma/hfi1/file_ops.c |  204 ++++++++++++++++++++++++++++++++++
>>  include/uapi/rdma/hfi/hfi1_user.h    |   40 +++++++
>>  3 files changed, 248 insertions(+), 1 deletions(-)
>> 
>
><...>
>
>> +#define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt */
>> +
>> +struct hfi1_cmd;
>> +#define HFI1_IOCTL_ASSIGN_CTXT \
>> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_ASSIGN_CTXT, struct hfi1_user_info)
>> +#define HFI1_IOCTL_CTXT_INFO \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_INFO, struct hfi1_ctxt_info)
>> +#define HFI1_IOCTL_USER_INFO \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_USER_INFO, struct hfi1_base_info)
>> +#define HFI1_IOCTL_TID_UPDATE \
>> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_UPDATE, struct hfi1_tid_info)
>> +#define HFI1_IOCTL_TID_FREE \
>> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_FREE, struct hfi1_tid_info)
>> +#define HFI1_IOCTL_CREDIT_UPD \
>> +	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CREDIT_UPD)
>> +#define HFI1_IOCTL_RECV_CTRL \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_RECV_CTRL, int)
>> +#define HFI1_IOCTL_POLL_TYPE \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_POLL_TYPE, int)
>> +#define HFI1_IOCTL_ACK_EVENT \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_ACK_EVENT, unsigned long)
>> +#define HFI1_IOCTL_SET_PKEY \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_SET_PKEY, __u16)
>> +#define HFI1_IOCTL_CTXT_RESET \
>> +	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_RESET)
>> +#define HFI1_IOCTL_TID_INVAL_READ \
>> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
>> +#define HFI1_IOCTL_GET_VERS \
>> +	_IOR(IB_IOCTL_MAGIC, HFI1_CMD_GET_VERS, int)
>>  
>
>I think the overall consensus over participants in OFVWG call was to use
>one IOCTL to enter into device specific handler which will do all
>necessary parsing and not spamming common IOCTL interface.

That was for the verbs working group and the verbs 2.0 uAPI. This is for 
psm. We have some commands which are write or read only, and some which are  
read and write. It seems natural to classify their ioctl as such.

In the interim, while the OFVWG is solidifying its one API to rule them all, 
this solves our current and very specific problem of treating 
write()/writev() differently.  

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
