From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Mon, 22 Aug 2011 15:46:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E4709A@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201108031337.24527.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237316E3E55C@FMSMSX151.amr.corp.intel.com>
 <201108211742.18803.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108211742.18803.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I am a bit concerned here.  In the current usage model, target QPs are destroyed when their reference
> count goes to zero
> (ib_reg_xrc_recv_qp and ibv_xrc_create_qp increment the reference count, while ib_unreg_xrc_recv_qp
> decrements it).
> In this model, the TGT QP user/consumer does not need to know if it is the last user of the QP (and
> therefore should
> destroy it).  The QP simply gets destroyed when no one is left using it.
> 
> In your proposed model, it looks like the last TGT QP user needs to know that it is the last user and
> must therefore destroy
> the TGT QP (rather than the QP being destroyed automatically as the result of the ref count going to
> zero).
> 
> Am I correct?
> 
> (Or does every user -- both the creator and the caller of ib_open_qp do an ib_destroy_qp() -- and the
> destroy actually
> occurs when no users who did open/create remain?).

The latter is correct.  The caller of ib_create_qp() and ib_open_qp() all call ib_destroy_qp() if they wish to destroy the QP once the reference count hits zero.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
