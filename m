From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] ibacm: Calculate correct tv_nsec value in
 event_wait()
Date: Mon, 13 Nov 2017 13:30:20 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E86639F0C01A1@FMSMSX108.amr.corp.intel.com>
References: <20171110222658.10387.16845.stgit@phlsvslse11.ph.intel.com>
 <20171110222853.10387.81730.stgit@phlsvslse11.ph.intel.com>
 <20171111162610.GL17451@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171111162610.GL17451-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Saturday, November 11, 2017 11:26 AM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 2/3] ibacm: Calculate correct tv_nsec value in
> event_wait()
> 
> On Fri, Nov 10, 2017 at 05:29:02PM -0500, Michael J. Ruhl wrote:
> >  	gettimeofday(&curtime, NULL);
> 
> Ugh, the use of gettimeofday for this kind of stuff is also a serious bug.
> 
> This needs to use clock_gettime(CLOCK_MONOTONIC) and
> pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);

Yeah, that one is a lot cleaner.  I will get a new patch out shortly.

Thanks,

Mike
 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
