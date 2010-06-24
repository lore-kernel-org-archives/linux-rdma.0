From: "Moni Shoua" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Thu, 24 Jun 2010 22:44:13 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F868DF8F@exil.voltaire.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com><1276513450.30132.51.camel@alst60.voltaire.com><aday6eguhfn.fsf@roland-alpha.cisco.com> <4C18E557.5050804@Voltaire.COM> <ada4ogtvenr.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <ada4ogtvenr.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks. I accept this remark.
We will try to address all the bothering issues regarding the patch set
of RAW QP support and resubmit them linux-rdma.
Since it won't work with Mellanox the patches will be only for Intel
(nes) driver. When time comes and Mellanox cards  can be tested for RAQ
QO feature they will benefit from the common part.



---------------------------------------
  Moni Shoua|  +972-54-5567934  


-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, June 23, 2010 8:32 PM
To: Moni Shoua
Cc: Aleksey Senin; Eli Cohen; ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org;
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Tziporet Koren; Yiftah Shahar
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support

 > There is no qp type IBV_QPT_RAW_ETY in user space (at least not in
the definitions  > coming with libibverbs). In fact, libibverbs that
comes with OFED defines (in verbs.h)  > a qp type called IBV_QPT_RAW_ETT
which equals to 7.
 > The patch that is under discussion here adds a new qp type
IB_QPT_RAW_ETH and equals it to 7  > to match the definition in user
space. This indeed changes the value of IB_QPT_RAW_ETY to 8  > but I
don't see who can be affected since  > 1. No user space program that
uses IB_QPT_RAW_ETY exists  > 2. kernel is compiled as one piece of
code.

Why renumber the _ETY enum?  Maybe it doesn't break anything serious but
why risk it?
--
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go
to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
