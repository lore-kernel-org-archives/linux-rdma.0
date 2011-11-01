From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 15:19:12 -0700
Message-ID: <20111101151912.d3e67c59.weiny2@llnl.gov>
References: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
	<CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
	<20111101162218.GA10710@obsidianresearch.com>
	<CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
	<20111101173625.GH26974@obsidianresearch.com>
	<CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
	<20111101183730.GI26974@obsidianresearch.com>
	<CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com>
	<20111101215200.GN26974@obsidianresearch.com>
	<20111101150358.17d232ee.weiny2@llnl.gov>
	<20111101221135.GP26974@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101221135.GP26974-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 1 Nov 2011 15:11:35 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Nov 01, 2011 at 03:03:58PM -0700, Ira Weiny wrote:
> 
> > > And again, this is a useless interface in IB. 
> > 
> > Why do you mean by this?
> 
> A counter that is randomly reset by an external IB performance manager 
> is not useful for collecting local statistical information.
> 
> A counter that saturates and cannot be reset locally is not useful for
> any automatic process.
> 
> Why have a sysfs counter at all when you can just ask the PMA and get
> exactly the same data?

I agree, but...  sys admins like sysfs files...  :-(

> 
> I can't make a SNMP MIB from this counter. I can't make graphs from
> this counter. I can't do anything with it except show it to the user
> and hope they understand when it was last reset, or understand what
> to do when it is saturated.

Ok, just making sure we are on the same page.

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
