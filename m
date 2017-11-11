From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 2/3] ibacm: Calculate correct tv_nsec value in
 event_wait()
Date: Sat, 11 Nov 2017 09:26:10 -0700
Message-ID: <20171111162610.GL17451@ziepe.ca>
References: <20171110222658.10387.16845.stgit@phlsvslse11.ph.intel.com>
 <20171110222853.10387.81730.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171110222853.10387.81730.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 10, 2017 at 05:29:02PM -0500, Michael J. Ruhl wrote:
>  	gettimeofday(&curtime, NULL);

Ugh, the use of gettimeofday for this kind of stuff is also a serious bug.

This needs to use clock_gettime(CLOCK_MONOTONIC) and
pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
