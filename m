From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 09:59:50 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C618334.7010106-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > - XRC support upstream (kernel and user space) is still pending.
> >   (I can start a librdmacm branch for XRC support.)
> > - Changes are needed to the kernel rdma_cm.
> >   We could start submitting patches against Roland's xrc branch for
> these.
> > - Please update to the latest librdmacm tree.
> >   More specifically, rdma_getaddrinfo should support XRC as well.
> 
> The general parameters would be the same as for RC. Should we create a new
> ai_flag ? or a new port space ?

There's a ai_qp_type field available.  I think the RDMA TCP port space would work.

> Is it really necessary to support rdma_getaddrinfo, rdma_create_ep and the
> new APIs ?

I think so, yes.  At least XRC needs to be handled, even if some of the calls just fail as unsupported.

> > In general, I'd like to find a way to add XRC support to the librdmacm
> that makes things as simple for the user as possible.
> 
> Besides the need to correctly set cap.max_send_wr, the user API is
> unchanged.

I'm also concerned that the kernel must format the IB CM messages correctly when XRC is in use.  The kernel currently formats the messages assuming that the QP is RC.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
