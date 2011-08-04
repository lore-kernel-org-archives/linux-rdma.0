From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Thu, 4 Aug 2011 05:53:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373136F9AD2@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373136F962C@ORSMSX101.amr.corp.intel.com>
 <DE779D97-F54F-45E4-B3D4-DBEB10F9302D@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F967E@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA4622F4@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F97AC@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462300@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9A13@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462301@EXCHMB.ornl.gov>
 <20110803213642.GE28465@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373136F9A7E@ORSMSX101.amr.corp.intel.com>
 <20110804040503.GA13935@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110804040503.GA13935-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> ?? How do you register for an event? There is only
> ibv_get_async_event(3) - I thought it returned all events relevant to
> the associated verbs context.

The OFED APIs for managing XRC receive QPs are:

int (*create_xrc_rcv_qp)(struct ibv_qp_init_attr *init_attr,
                         uint32_t *xrc_qp_num);
int (*modify_xrc_rcv_qp)(struct ibv_xrc_domain *xrc_domain,
                         uint32_t xrc_qp_num,
                         struct ibv_qp_attr *attr,
                         int attr_mask);
int (*query_xrc_rcv_qp)(struct ibv_xrc_domain *xrc_domain,
                        uint32_t xrc_qp_num,
                        struct ibv_qp_attr *attr,
                        int attr_mask,
                        struct ibv_qp_init_attr *init_attr);
int (*reg_xrc_rcv_qp)(struct ibv_xrc_domain *xrc_domain,
                      uint32_t xrc_qp_num);
int (*unreg_xrc_rcv_qp)(struct ibv_xrc_domain *xrc_domain,
                        uint32_t xrc_qp_num);

The ibv_reg_xrc_rcv_qp() call bumped a reference count on the receive qp and registered for events.  The event structure was modified to include the xrc_qp_num, along with a flag added to the event to indicate that the event was for an xrc qp.

(To clarify my patches do not have these calls, so event registration isn't possible and would need to be communicated above verbs.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
