From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 15:27:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373FB4C@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201105181754.33759.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201105181754.33759.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Great that you are taking this on!  I will review this next week.

Hopefully I'll have some early patches sometime next week.  See below for my current thoughts based on how the implementation is progressing.  My thoughts change hourly.

> > From an architecture viewpoint, XRC adds 4 new XRC specific objects:
> domains, INI QPs, TGT QPs, and SRQs.  For the purposes of the libibverbs
> API only, I'm suggesting the following mappings:
> >
> > XRC domains - Hidden under a PD, dynamically allocated when needed.  An
> extended ops call allows the xrcd to be shared between processes.  This
> minimizes changes to existing structures and APIs which only take a struct
> ibv_pd.
> >
> > INI QPs - Exposed through a new IBV_QPT_XRC_SQ qp type.  This is a send-
> only QP with minimal differences from an RC QP from a user's perspective.
> >
> > TGT QPs - Not exposed to user space.  XRC TGT QP creation and setup is
> handled by the kernel.
> >
> > XRC SRQs - Exposed through a new IBV_QPT_XRC_RQ qp type.  This is an SRQ
> that is tracked using a struct ibv_qp.  This minimizes API changes to both
> libibverbs and librdmacm.

The librdmacm wants IBV_QPT_XRC_RQ to be defined, which it uses for SRQN resolution.  XRC_SQ results in using the IB CM connection protocol.  XRC_RQ results in using CM SIDR.

The actual XRC SRQ is allocated through a new call like the existing patches.  XRC_RQ is not used by ibv_create_qp().

> > Need new uverbs commands to support alloc/dealloc xrcd and create xrc
> srq.  Create QP must handle XRC INI QPs.  XRC TGT QPs are not exposed;
> ***all XRC INI->TGT QP setup is done in band***.
> >
> > Somewhere, an xrc sub-module listens on a SID and accepts incoming XRC
> connection requests.  This requires associating the xrcd and SID, the
> details of which I'm not clear on.  The xrcd is most readily known to
> uverbs, but a SID is usually formed by the rdma_cm.  Even how the latter
> is done is unclear.

I'm not sure if xrcd needs to be explicitly exposed to user space.  I think user space will end up needing to be involved in some degree when INI->TGT QPs are established from the perspective of the rdma_cm.  For example, initiating the listen and telling the kernel whether to accept or reject a connection.  I still don't know that XRC TGT QPs need to be exposed through libibverbs similar to how they are being done.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
