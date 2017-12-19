From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Tue, 19 Dec 2017 20:20:50 +0800
Message-ID: <20171219122050.GA19682@dhcp-13-42.nay.redhat.com>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
 <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
 <20171215172800.GA12434@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171215172800.GA12434-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 15, 2017 at 10:28:00AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 15, 2017 at 09:36:28AM +0800, Honggang LI wrote:
> > On Thu, Dec 14, 2017 at 02:59:34PM +0000, Bart Van Assche wrote:
> > > On Thu, 2017-12-14 at 19:02 +0800, Honggang LI wrote:
> > > > fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
> > > > default signal handler will be used when it receives signal SIGINT.
> > > > ibsrpdm will exit with non-zero exit code as default signal handler
> > > > killed it.
> > > 
> > > Can you explain why you think that ibsrpdm needs a signal handler?
> > 
> > main
> >   ibsrpdm
> >     alloc_res
> >       pthread_create(&res->res.async_ev_thread [1]
> >     ....
> >     free_res
> >       if (res->async_ev_thread) { pthread_kill(res->async_ev_thread, SIGINT); [2]
> > 
> > 
> > The ibsrpdm program create a thread in [1], and send a SIGINT in [2].
> > The default behavior of SIGINT is to terminate the process.
> 
> Yuk, no, using signals like this is horrifyingly buggy.

OK, I agree with you. The "signal_handler", which calls "wake_up_main_loop",
is not the right solution, because wakeup_pipe never used by ibsrpdm.

<snip>
void wake_up_main_loop(char ch)
{
        int res;

	assert(wakeup_pipe[1] >= 0); // this 'assert' will be failed
<snip>	


> Here is a sketch on how to fix it properly. All the users of
> pthread_kill should be eliminated.
> 
> Though overall, there is really no reason to even cleanup the threads,
> just call exit?

No, if one pthread just calls 'exit', the entire process will be
terminated immediately. So, we need to cleanup the threads.

I think the source of current issue is the async_ev_thread pthread.
We should *NOT* create such pthread for ibsrpdm.

I checked the old srptools git repo.

git://git.openfabrics.org/~bvanassche/srptools.git

Commit ab57a5b92eb3b8c9221f77235a028814a462d2cb merges "ibsrpdm" into
"srp_daemon". The old ibsrpdm program is a single thread program.
srp_daemon is multi-thread program.

As ibsrpdm always only run once, because "config->once" has been
assigned to 1. I would suggest to apply this patch.

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2..4012a7db 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1945,12 +1945,12 @@ static struct resources *alloc_res(void)
 				     run_thread_get_trap_notices, &res->res);
 		if (ret)
 			goto err;
-	}
 
-	ret = pthread_create(&res->res.async_ev_thread, NULL,
-			     run_thread_listen_to_events, &res->res);
-	if (ret)
-		goto err;
+		ret = pthread_create(&res->res.async_ev_thread, NULL,
+				     run_thread_listen_to_events, &res->res);
+		if (ret)
+			goto err;
+	}
 
 	if (config->retry_timeout && !config->once) {
 		ret = pthread_create(&res->res.reconnect_thread, NULL,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
