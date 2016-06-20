From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] IB/srp: Remove create_workqueue
Date: Mon, 20 Jun 2016 14:59:22 -0400
Message-ID: <20160620185922.GQ3262@mtj.duckdns.org>
References: <20160607181617.GA6556@Karyakshetra>
 <f3d26daf-1805-7046-f45b-b8965156d83f@sandisk.com>
 <20160607192106.GY31708@htj.duckdns.org>
 <bdf2c634-a765-eb97-5ca1-583d833b07c7@sandisk.com>
 <dcee0161-3210-0cfb-c0e6-bba7259ad639@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dcee0161-3210-0cfb-c0e6-bba7259ad639-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, Bart.

On Tue, Jun 07, 2016 at 01:00:13PM -0700, Bart Van Assche wrote:
> > > > srp_remove_wq is used for SRP target port removal work only. This work is
> > > > neither queued from inside a shrinker nor by the page writeback code so I
> > > > think it is safe to drop WQ_MEM_RECLAIM.
> > > 
> > > It should be able to use system_wq then.
> > 
> > No. I have tried that but that resulted in a deadlock.
> 
> See also commit bcc059103591 for the details.

So, create_workqueue() limits concurrency to 1 per cpu and if you have
a dependency between two work items and they get scheduled on the same
cpu they can deadlock.  system_wq doesn't have that restriction and
should be fine, AFAICS.

Thanks!

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
