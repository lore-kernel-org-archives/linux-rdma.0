From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Is there is any code example to test the XRC?
Date: Wed, 15 Jun 2011 17:59:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302135F@ORSMSX101.amr.corp.intel.com>
References: <201106151054.12651.dotanb@sw.voltaire.com>
 <1828884A29C6694DAF28B7E6B8A82373021147@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373021147-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I have very simple example client/server programs that use the librdmacm.
> I was just getting too tired last night to post the patches.  I'll send
> out the patches today and push out git trees with the changes.

I've pushed out git trees that contain all of the patches that I have.  The trees are all on the openfabrics server with an xrc branch:

	git://git.openfabrics.org/~shefty/rdma-dev.git   xrc
	git://git.openfabrics.org/~shefty/libibverbs.git xrc
	git://git.openfabrics.org/~shefty/libmlx4.git    xrc
	git://git.openfabrics.org/~shefty/librdmacm.git  xrc

There's probably additional work needed in the kernel.  For instance, I didn't really do anything special with event processing or worry about a kernel user.  If there's an existing XRC test program available, I can port it for additional testing.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
