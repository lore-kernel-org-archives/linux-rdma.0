From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to
 verb routines
Date: Thu, 9 Jun 2011 18:59:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373019B0A@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com>
 <20110609165528.GA6257@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110609165528.GA6257-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> After looking at this a bit I'm a bit concerned that your first
> extension goes around and requires edits to the various structs
> anyhow, which sort of defeats the purpose of making extensions, IMHO..

My thinking is that extensions mainly provide:

- a way for a vendor or organization to provide add-on functionality to
  an application (so we don't break things like the xrc patches did)
- a mechanism for libibverbs to obtain additional functionality from a
  provider library (where existing ibv_context_ops are insufficient)

Once a feature has been added directly to libibverbs, I would treat it slightly differently.  For example, I've since modified libibverbs to export direct APIs for opening/closing xrcd's and creating extended srq's.  An app doesn't need to call ibv_get_ext_ops() directly for xrc qp's; however, it would make use of the define for IBV_XRC_OPS if it wanted to support older versions of libibverbs.

Changing ibv_send_wr, ibv_qp_init_attr, ibv_srq, ibv_qp, etc. seemed like a much better alternative for providing XRC support than introducing an entire new set of structures and APIs.

> Do you think such changes will be required so often that this is just
> extra complexity? For instance, could you implement the multicast self
> loop flag feature using an extension ?

Based on history, I'd anticipate a small number of extensions provided by OFA or a vendor: tag matching? off-loaded MPI collective operations?  who knows...

Certain ibverbs APIs more easily support extensions that others.  Adding XRC QP support to the existing APIs without breaking existing apps is fairly easy, since the qp_type indicates if extended attributes are available.  XRC SRQs required a new API.  Supporting the multicast self loop flag is definitely doable; it's really just a matter of how easy it would be for an application to use it. :)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
