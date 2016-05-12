From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 12 May 2016 13:40:06 -0600
Message-ID: <20160512194006.GA6364@obsidianresearch.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512171846.6198.31415.stgit@scvm10.sc.intel.com>
 <20160512174332.GB13553@obsidianresearch.com>
 <20160512192726.GB15146@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512192726.GB15146@phlsvsds.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 03:27:27PM -0400, Dennis Dalessandro wrote:
> >I thought we agreed to get rid of this as well? It certainly does not
> >belong here, and as a general rule, I don't think ioctls should be
> >doing capable tests..
> 
> Yeah. I left it in this patch set because this just "ports" our existing
> code to ioctl(). The eprom stuff is completely removed in another patch set
> that I posted shortly after this. It's at:

Adding code and then removing it in a later patch is not a best
practice.. Just don't add it or define ioctl numbers at all..

> >>+static inline int check_ioctl_access(unsigned int cmd, unsigned long arg)
> >>+{
> >>+	int read_cmd, write_cmd, read_ok, write_ok;
> >>+
> >>+	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
> >>+	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
> >>+	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
> >>+	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
> >>+
> >>+	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
> >>+		return -EFAULT;
> >
> >This seems kind of goofy, didn't Ira say this is performance senstive?

Well, calling access_ok twice when only once is typically needed is
certainly not performant. Typically this check is done at every access
via get_user/put_user/copy_to/from_user - why is it being hoisted like
this?

> >Driver shouldn't be open coding __get_user like that, IMHO.
> 
> Can you explain what you mean here? We should not use __get_user()?

Generally speaking, yes. Use get_user() that includes the correct
access_ok. Unless there is a good reason to avoid it, the standard API
should be used.

> _IOW means user is writing data to the device. So the device is reading data
> from the user. Or am I missing your point?

You are right, I spaced on this when reading the above - 'write_ok'
and 'write_cmd' seem like they should have been related, but really
aren't. It is doing the right tests, just odd. (eg use names like
write_cmd_ok, write_cmd for better clarity)

Jason
