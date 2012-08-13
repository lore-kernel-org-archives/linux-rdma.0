From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: rsockets and fork
Date: Mon, 13 Aug 2012 16:12:37 -0700
Message-ID: <1344899557.2101.29.camel@oc1677441337.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean,

I could not get fork enabled netperf to work with rsockets in the latest
librdmacm git repository.
After some debugging, i found that the child netserver process is blocked at 
sem_wait() call in fork_passive().
It is not clear to me how this call is supposed to unblock as sem_post()
is done later in the same function.

If i comment out sem_wait() and sem_post() in this routine, i got a single
instance of netperf working with a forked netserver.

However, if i start another netperf instance while the other session is
still going on, it seems to hang and return with a very low throughput.
It looks as if the first session is starving all the other sessions.
The right behavior would be to have the available bw split across the 
parallel instances.

Thanks
Sridhar


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
