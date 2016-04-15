From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 12:17:55 -0400
Message-ID: <20160415161754.GA21549@rhel>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415040126.GB10689@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@leon.nu>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 15, 2016 at 07:01:26AM +0300, Leon Romanovsky wrote:
> On Thu, Apr 14, 2016 at 01:48:31PM -0400, Ira Weiny wrote:
> > On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > > > This patch series removes the write() interface for user access in favor of an
> > > > ioctl() based approach. This is in response to the complaint that we had
> > > > different handlers for write() and writev() doing different things and expecting
> > > > different types of data. See:
> > > 
> > > I think we should wait on applying these patches until we globally sort out
> > > what to do with the rdma uapi.
> > > 
> > > It just doesn't make alot of sense for drivers to have their own personal
> > > char devices. :(
> > 
> > I'm afraid I have to disagree at this time.  Someday we may have "1 char device
> > to rule them all" but right now we don't have any line of sight to that
> > solution.  It may be _years_ before we can agree to the semantics which will
> > work for all high speed, kernel bypass, rdma, low latency, network devices.
> 
> You didn't ever try to come and work on the solution. We talked about
> finite time frame (_months_) which is doable based on knowledge that user
> space parts are developed by the same companies and all our future changes
> will be in one subsystem.

How can you say that I am not working on a solution?

We spent most of last week discussing possible solutions and I am in support of
a more common core.  But ask yourself this.


If hfi1 did not support verbs at all would this even be an issue?


> 
> You were supposed to prepare "wish list" from this new API as an initial
> phase. If you do it, you will find that it is very short and in the
> initial meeting you will see that it similar to other participants in
> linux-rdma community.

The list of operations may be short.  But the way in which you do those in a
performant way for each hardware device is _very_ different.  This is a problem
which has been debated for years and no one has come up with an elegant
solution.  Every solution ends up being, to quote a presenter at last weeks
conference, "shoving a square peg into a round hole".

Until we all admit 2 things.

	1) That there are devices which don't operate on QPs
	2) That the High Speed interconnect core should present something more
	   abstract than a QP interface

we are not really creating a common layer.

I do admit Jasons idea has some merit but I'm just not sure it provides so much
benefit that it is worth the effort at this time.

Ira
