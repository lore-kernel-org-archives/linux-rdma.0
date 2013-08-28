From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Wed, 28 Aug 2013 20:05:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>
 <CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gandalf Corvotempesta' <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Ubuntu 13.04 Server on both nodes.
> 
> node1:
> 
> $ cat /proc/cpuinfo | grep 'model name'
> model name : Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz

If you can provide your PCIe information and the results from running the perftest tools (rdma_bw), that could help as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
