From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] IB/srp: Remove create_workqueue
Date: Tue, 7 Jun 2016 11:32:42 -0700
Message-ID: <f3d26daf-1805-7046-f45b-b8965156d83f@sandisk.com>
References: <20160607181617.GA6556@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160607181617.GA6556@Karyakshetra>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/07/2016 11:16 AM, Bhaktipriya Shridhar wrote:
> alloc_workqueue replaces deprecated create_workqueue().
>
> A dedicated workqueue has been used since the workqueue srp_remove_wq with
> workitem &target->remove_work, is a work queue for the SRP target removal.
> WQ_MEM_RECLAIM has been set to ensure forward progress under memory
> pressure.
> Since there are only a fixed number of work items, explicit
> concurrency limit is unnecessary here.
>
> Is the workqueue being used on a memory reclaim path?
> Does it require WQ_MEM_RECLAIM?

Hello Bhaktipriya,

srp_remove_wq is used for SRP target port removal work only. This work 
is neither queued from inside a shrinker nor by the page writeback code 
so I think it is safe to drop WQ_MEM_RECLAIM.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
