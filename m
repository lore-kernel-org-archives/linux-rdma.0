From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and other performance
Date: Thu, 14 Jun 2012 16:02:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31673@ORSMSX101.amr.corp.intel.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDA0233.6090409-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Traditional sockets based applications wanting high throughput could use
> rsockets Since it is layered on top of uverbs we expected to see good
> throughput numbers.
> So, we started to run netperf and iperf. We observed that it tops off at
> about 20Gb/s with QDR adapters. A quick "perf top" revealed a lot of
> cycles spent in memcpy().
> We had hoped these numbers would be somewhat higher since we did not
> expect the memcpy() to have such a large overhead.

Someone more familiar with ipoib needs to respond regarding those changes.  For rsockets, please make sure that you've pulled the latest code.  You can improve the performance by adjusting the QP size and send/receive buffers, which can be done through config files.  I started an rsocket man page that describes the files that I just pushed out to my git tree.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
