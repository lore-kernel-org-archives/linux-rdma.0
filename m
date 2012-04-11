From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 0/4] librdmacm: Rsockets API and implementation
Date: Wed, 11 Apr 2012 18:29:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451ACEEF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set contains an initial implementation of rsockets as
presented at the 2012 OpenFabrics Workshop.  A copy of that presentation
is available at:

	https://www.openfabrics.org/downloads/rdmacm/rsockets-ofa12.pptx

and a video of the presentation can be found here:

	http://www.youtube.com/watch?v=2IRrXdIsJuU

For those of you who don't like clicking on links in an email, rsockets
is a socket-like API layered over verbs.  It is conceptually similar to a
user space implementation of SDP, except that it uses custom algorithms and
protocols.

The source code has been pushed into an rsocket branch in my git tree at:

	git://git.openfabrics.org/~shefty/librdmacm.git rsocket

All comments are welcome, but mostly verbal praise.  Although comments
on the wire protocol before an official release would be the most useful.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
