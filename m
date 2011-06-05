From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to
 verb routines
Date: Sun, 5 Jun 2011 13:47:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373012DF3@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com>
 <6E0AE576-9B92-46E4-A5F6-68ECD64C5B67@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6E0AE576-9B92-46E4-A5F6-68ECD64C5B67-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm not quite sure I understand the use for "enum ibv_extension_type".  Where/how is this used?

The intent is that this allows users to extend existing enums without conflicts.  For example,

> > /* Extend IBV_QP_TYPE for XRC */
> > #define OFA_QPT_XRC ((enum ibv_qp_type) \
> > 	(IBV_EXTENSION_OFA << IBV_EXTENSION_BASE_SHIFT) + 6)

This defines a new QP type for XRC.  This new QP type is only usable as part of an OFA specific extension.  When XRC QP types are added directly to libibverbs, it receives a new number because there's no guarantee that the upstream version of XRC support will match what OFA published.  (Obviously it's too late to handle XRC QPs in this way.)

The trade-off is that the upper X number of bits (8 in the patch) of most enums end up being reserved for extension use.  The benefit is that existing functions, like ibv_create_qp, can support extensions, versus duplicating functions and structures.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
