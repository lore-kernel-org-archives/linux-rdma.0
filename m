From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Fri, 13 May 2016 16:54:01 -0400
Message-ID: <20160513205400.GA25995@phlsvsds.ph.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com> <20160512171846.6198.31415.stgit@scvm10.sc.intel.com> <20160512174332.GB13553@obsidianresearch.com> <20160512192726.GB15146@phlsvsds.ph.intel.com> <20160512194006.GA6364@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512194006.GA6364-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 01:40:06PM -0600, Jason Gunthorpe wrote:
> On Thu, May 12, 2016 at 03:27:27PM -0400, Dennis Dalessandro wrote:
> 
> > >>+static inline int check_ioctl_access(unsigned int cmd, unsigned long arg)
> > >>+{
> > >>+	int read_cmd, write_cmd, read_ok, write_ok;
> > >>+
> > >>+	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
> > >>+	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
> > >>+	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
> > >>+	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
> > >>+
> > >>+	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
> > >>+		return -EFAULT;
> > >
> > >This seems kind of goofy, didn't Ira say this is performance senstive?
> 
> Well, calling access_ok twice when only once is typically needed is
> certainly not performant. Typically this check is done at every access
> via get_user/put_user/copy_to/from_user - why is it being hoisted like
> this?
>
> 
> > >Driver shouldn't be open coding __get_user like that, IMHO.
> > 
> > Can you explain what you mean here? We should not use __get_user()?
> 
> Generally speaking, yes. Use get_user() that includes the correct
> access_ok. Unless there is a good reason to avoid it, the standard API
> should be used.

I know this code was refactored while we were still submitting patches to Greg
KH back in Nov/Dec.  Part of this was cleaning up branch on error rather than
success.  Hence the check for access at the top of the function and early
return.

At that time I _thought_ there were multiple __get_users in some of the
operations so a single common access_ok would speed those up.  However, I don't
see that happening any longer, so either I don't remember correctly, or we have
made this cleaner.

As it stands now I think you are correct we could use get_user and
copy_to/from_user.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
