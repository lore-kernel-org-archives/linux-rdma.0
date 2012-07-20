From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: fork support, was RE: rsockets and standard socket based TCP
 benchmarks
Date: Fri, 20 Jul 2012 17:51:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6BC37@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Have you had a chance to look more into the above for fork() support?

Well, the good news is that fork support is possible under some limitations.  I have a modified version of librspreload that hooks fork and transitions the last accepted connection from a normal socket to an rsocket.  (This was just an easy test to see what problems would pop up.)  I added a fork option to rstream to test, and it does work.  (And there was much rejoicing.)

There are some issues.  One is that if any IB resources are allocated before fork is called, there doesn't seem to be any way for the child process to remove them without affecting the parent process.  I had to change how the librdmacm allocated and freed protection domains to work around this, which worked for rstream, but may not work for all apps.  What's needed is a way for a child process to close IB resources that it won't use (in order to free up memory), but doesn't result in destroying the kernel resources.  I believe such a feature may also help applications that want to use checkpoint/restart.

Another issue is handling errors and falling back to the normal socket when the rsocket connection attempt fails.  Fork ends up needing to exchange messages on the normal socket for synchronization purposes, which changes the user's protocol.  But I think we can come up with a way to support fallback under most circumstances.

The bad news is that what I have was too limited to work with the next app that I tested (netperf)...  Changes needed to handle it appear possible, just more involved.  (And there was much gnashing of teeth.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
