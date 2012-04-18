From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: rsockets direct data placement
Date: Wed, 18 Apr 2012 15:05:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451B8219@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've committed the rsocket implementation in my librdmacm git tree, but I'll be fairly open about wire protocol changes until an actual release.

I'd like to start a discussion on the best way to support direct placement of data into an application's buffer with rsockets.  I spoke with many people at the OFA conference and through emails (mostly private conversations) on this topic.

The feedback I've received regarding requirements could be listed as:

* Support existing socket apps without changes, use verbs for direct RDMA
* Add a couple of new calls only

The most common feedback on possible solutions are:

* Look at ES-API
* Look at AIO

My personal objective is to enable existing applications to use direct data placement with minimal changes.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
