From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 12 May 2016 15:27:27 -0400
Message-ID: <20160512192726.GB15146@phlsvsds.ph.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com> <20160512171846.6198.31415.stgit@scvm10.sc.intel.com> <20160512174332.GB13553@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512174332.GB13553-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 11:43:32AM -0600, Jason Gunthorpe wrote:
>On Thu, May 12, 2016 at 10:18:47AM -0700, Dennis Dalessandro wrote:
>> +	case HFI1_IOCTL_EP_INFO:
>> +	case HFI1_IOCTL_EP_ERASE_CHIP:
>> +	case HFI1_IOCTL_EP_ERASE_RANGE:
>> +	case HFI1_IOCTL_EP_READ_RANGE:
>> +	case HFI1_IOCTL_EP_WRITE_RANGE:
>> +		if (!capable(CAP_SYS_ADMIN))
>> +			return -EPERM;
>> +		if (copy_from_user(&ucmd,
>> +				   (struct hfi11_cmd __user *)arg,
>> +				   sizeof(ucmd)))
>> +			return -EFAULT;
>> +		return handle_eprom_command(fp, &ucmd);
>
>I thought we agreed to get rid of this as well? It certainly does not
>belong here, and as a general rule, I don't think ioctls should be
>doing capable tests..

Yeah. I left it in this patch set because this just "ports" our existing 
code to ioctl(). The eprom stuff is completely removed in another patch set 
that I posted shortly after this. It's at:

http://marc.info/?l=linux-rdma&m=146307409301822&w=2

>> +static inline int check_ioctl_access(unsigned int cmd, unsigned long arg)
>> +{
>> +	int read_cmd, write_cmd, read_ok, write_ok;
>> +
>> +	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
>> +	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
>> +	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
>> +	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
>> +
>> +	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
>> +		return -EFAULT;
>
>This seems kind of goofy, didn't Ira say this is performance senstive?

I'll let Ira comment here on the performance aspect. I agree it looks goofy.  
Suggestion on how to make it look better? Or are you saying this is 
incorrect?

>Driver shouldn't be open coding __get_user like that, IMHO.

Can you explain what you mean here? We should not use __get_user()?

>
>> +#define HFI1_IOCTL_RECV_CTRL \
>> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_RECV_CTRL, int)
>
>Have you audited this? Confused why this is marked IOW when I see
>this:
>
>+       case HFI1_IOCTL_RECV_CTRL:
>+               ret = __get_user(uval, (int __user *)arg);
>
>Seeing many other examples.
>
>I stopped looking again

_IOW means user is writing data to the device. So the device is reading data 
from the user. Or am I missing your point?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
