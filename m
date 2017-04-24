From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core v5 0/8]  Broadcom User Space RoCE Driver
Date: Mon, 24 Apr 2017 16:57:23 -0400
Message-ID: <1493067443.3041.63.camel@redhat.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493059995-636-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-24 at 14:53 -0400, Devesh Sharma wrote:
> This series introduces the user space RoCE driver for the Broadcom
> NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
> is dependent on the bnxt_re driver posted earlier to linux-rdma
> community and is under reveiw.
> 
> This patch series is based on the latest master of rdma-core
> repository hosted at https://github.com/linux-rdma/rdma-core.git
> 
> The GIT for this library is hosted at following URL on github
> https://github.com/dsharma283/bnxtre-rdma-core.git
> branch: bnxtre-v5
> 
> Please review and give your valuable feedback for the
> betterment.

In general, the driver looked to be in pretty good shape.  I've merged
it into rdma-core.  The only thing I noticed is something that other
drivers do as well, but which I have a personal issue with, and that's
over use of spin locks in user space IMHO.  There are aspects of
context that make spin locks OK in the kernel, but those aspects are
not true in user space (spin lock can be interrupted and process
scheduled away while holding the lock for instance, where as we protect
against that in the kernel, the scheduler doesn't know when user space
is holding a spin lock, scheduler gives precedent and even extra time
slices to processes that appear to be working and making forward
progress, and scheduler can't tell the difference between spinning on a
lock and making forward progress, so spinning can possibly result in
the scheduler keeping the spinning task on the run queue while the task
that needs to be brought back onto the run queue is kept waiting,
things like this).  Unless they've updated pthreads to do stuff that
I'm not aware of anyway, which is always possible, I prefer to see
mutexes instead of spin locks in user space because they are safer and
more likely to result in forward progress in the event of contention.
 But, as I said, that's just my personal bias.  It might be nice if we
could devise a test to quantify these issues and see if I'm worried
over nothing or if contention on user space spin locks can be as bad as
I imagine.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
