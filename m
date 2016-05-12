From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 12 May 2016 18:12:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04B473@ORSMSX109.amr.corp.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512171846.6198.31415.stgit@scvm10.sc.intel.com>
 <20160512174332.GB13553@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512174332.GB13553-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, May 12, 2016 at 10:18:47AM -0700, Dennis Dalessandro wrote:
> > +	case HFI1_IOCTL_EP_INFO:
> > +	case HFI1_IOCTL_EP_ERASE_CHIP:
> > +	case HFI1_IOCTL_EP_ERASE_RANGE:
> > +	case HFI1_IOCTL_EP_READ_RANGE:
> > +	case HFI1_IOCTL_EP_WRITE_RANGE:
> > +		if (!capable(CAP_SYS_ADMIN))
> > +			return -EPERM;
> > +		if (copy_from_user(&ucmd,
> > +				   (struct hfi11_cmd __user *)arg,
> > +				   sizeof(ucmd)))
> > +			return -EFAULT;
> > +		return handle_eprom_command(fp, &ucmd);
> 
> I thought we agreed to get rid of this as well? It certainly does not
> belong here, and as a general rule, I don't think ioctls should be
> doing capable tests..

At least the drm ioctl code has similar capable test

http://lxr.free-electrons.com/source/drivers/gpu/drm/drm_ioctl.c#L519


> > +static inline int check_ioctl_access(unsigned int cmd, unsigned long
> arg)
> > +{
> > +	int read_cmd, write_cmd, read_ok, write_ok;
> > +
> > +	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
> > +	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
> > +	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg,
> _IOC_SIZE(cmd));
> > +	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
> > +
> > +	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
> > +		return -EFAULT;
> 
> This seems kind of goofy, didn't Ira say this is performance senstive?
> 
> Driver shouldn't be open coding __get_user like that, IMHO.

FWIW, drm keeps an ioctl 'descriptor', which maintains a kernel copy of the ioctl cmd.  It uses the kernel's version of the cmd for processing, instead of the cmd value passed in from user space.

It doesn't open code get_user or do checks similar to what's here.  But if there's concern that the cmd value cannot be trusted, a similar descriptor mechanism could be used here.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
