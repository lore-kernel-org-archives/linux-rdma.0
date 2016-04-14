From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 13:48:31 -0400
Message-ID: <20160414174830.GA11641@rhel.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414164550.GC6247@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > This patch series removes the write() interface for user access in favor of an
> > ioctl() based approach. This is in response to the complaint that we had
> > different handlers for write() and writev() doing different things and expecting
> > different types of data. See:
> 
> I think we should wait on applying these patches until we globally sort out
> what to do with the rdma uapi.
> 
> It just doesn't make alot of sense for drivers to have their own personal
> char devices. :(

I'm afraid I have to disagree at this time.  Someday we may have "1 char device
to rule them all" but right now we don't have any line of sight to that
solution.  It may be _years_ before we can agree to the semantics which will
work for all high speed, kernel bypass, rdma, low latency, network devices.

We need to fix the write/writev problem now.[1]

Ira

[1] https://www.spinics.net/lists/linux-rdma/msg34451.html
