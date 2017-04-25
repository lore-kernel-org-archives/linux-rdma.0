From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/fmr_pool: Convert the cleanup thread into kthread
 worker API
Date: Tue, 25 Apr 2017 14:29:48 -0400
Message-ID: <1493144988.3041.86.camel@redhat.com>
References: <1476718772-9760-1-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476718772-9760-1-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-10-17 at 17:39 +0200, Petr Mladek wrote:
> Kthreads are currently implemented as an infinite loop. Each
> has its own variant of checks for terminating, freezing,
> awakening. In many cases it is unclear to say in which state
> it is and sometimes it is done a wrong way.
> 
> The plan is to convert kthreads into kthread_worker or workqueues
> API. It allows to split the functionality into separate operations.
> It helps to make a better structure. Also it defines a clean state
> where no locks are taken, IRQs blocked, the kthread might sleep
> or even be safely migrated.
> 
> The kthread worker API is useful when we want to have a dedicated
> single thread for the work. It helps to make sure that it is
> available when needed. Also it allows a better control, e.g.
> define a scheduling priority.
> 
> This patch converts the frm_pool kthread into the kthread worker
> API because I am not sure how busy the thread is. It is well
> possible that it does not need a dedicated kthread and workqueues
> would be perfectly fine. Well, the conversion between kthread
> worker API and workqueues is pretty trivial.
> 
> The patch moves one iteration from the kthread into the work
> function.
> It is queued only when there is a pending work. Therefore we do not
> need to compare flush_ser and req_ser at the beginning. On the
> contrary,
> the same work could be queued only once at a time. Therefore it has
> to
> re-queue itself if some requests are pending.
> 
> Otherwise, wake_up_process() is replaced by queuing the work.
> 
> Important: The change is only compile tested. I did not find an easy
> way how to check it in a real life.
> 
> Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
> TO: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Petr,

This patch has sat around for a long time.  I've decided to take it in
this release, even though it isn't really tested, on the basis that we
will perform some testing internally using the mthca driver (if you
combine the mthca driver with certain upper level protocols, you can
create a situation where FMR memory will be the preferred memory in use
IIRC) and revert if it doesn't work properly.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
