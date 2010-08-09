From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Mon, 9 Aug 2010 13:53:32 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5331DC.9080109-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This allow rdma ucm to establish an XRC connection between two nodes. Most
> of the changes are related to modify_qp since the API is different
> whether the QP is on the send or receive side.
> To create an XRC receive QP, the cap.max_send_wr must be set to 0.
> Conversely, to create the send XRC QP, that attribute must be non-zero.

I need to give XRC support to the librdmacm more thought, but here are at least the initial concerns:

- XRC support upstream (kernel and user space) is still pending.
  (I can start a librdmacm branch for XRC support.)
- Changes are needed to the kernel rdma_cm.
  We could start submitting patches against Roland's xrc branch for these.
- Please update to the latest librdmacm tree.
  More specifically, rdma_getaddrinfo should support XRC as well.

In general, I'd like to find a way to add XRC support to the librdmacm that makes things as simple for the user as possible.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
