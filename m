From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Wed, 28 Aug 2013 20:24:23 +0200
Message-ID: <CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA96AD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/8/28 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> Can you explain your environment more?  The performance seems low.

Ubuntu 13.04 Server on both nodes.

node1:

$ cat /proc/cpuinfo | grep 'model name'
model name : Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz
model name : Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz
model name : Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz
model name : Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz

$ free -m
             total       used       free     shared    buffers     cached
Mem:         16022        966      15056          0         95        534
-/+ buffers/cache:        336      15686
Swap:        16353          0      16353


node2:

$ cat /proc/cpuinfo | grep 'model name'
model name : Intel(R) Xeon(R) CPU            3065  @ 2.33GHz
model name : Intel(R) Xeon(R) CPU            3065  @ 2.33GHz

$ free -m
             total       used       free     shared    buffers     cached
Mem:          2001        718       1282          0         53        516
-/+ buffers/cache:        148       1853
Swap:         2044          0       2044
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
