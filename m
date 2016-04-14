From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 12:05:40 -0600
Message-ID: <20160414180540.GA12554@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160414174830.GA11641-no5AT4YuGWKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 01:48:31PM -0400, Ira Weiny wrote:
> On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> > On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > > This patch series removes the write() interface for user access in favor of an
> > > ioctl() based approach. This is in response to the complaint that we had
> > > different handlers for write() and writev() doing different things and expecting
> > > different types of data. See:
> > 
> > I think we should wait on applying these patches until we globally sort out
> > what to do with the rdma uapi.
> > 
> > It just doesn't make alot of sense for drivers to have their own personal
> > char devices. :(
> 
> I'm afraid I have to disagree at this time.  Someday we may have "1 char device
> to rule them all" but right now we don't have any line of sight to that
> solution.  It may be _years_ before we can agree to the semantics which will
> work for all high speed, kernel bypass, rdma, low latency, network devices.

There are some pretty obvious paths to make this saner that could only
be a few weeks away, we haven't even had the first conversations
yet. I think you are completely wrong there is no 'line of sight'

It certainly can't be years.

There is some rational for a very driver specific thing, but EEPROM
and snoop? Seriously?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
