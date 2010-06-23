From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 23 Jun 2010 10:31:52 -0700
Message-ID: <ada4ogtvenr.fsf@roland-alpha.cisco.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>
	<1276513450.30132.51.camel@alst60.voltaire.com>
	<aday6eguhfn.fsf@roland-alpha.cisco.com>
	<4C18E557.5050804@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C18E557.5050804-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org> (Moni Shoua's message of "Wed, 16
	Jun 2010 17:53:11 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg@openfabrics.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > There is no qp type IBV_QPT_RAW_ETY in user space (at least not in the definitions
 > coming with libibverbs). In fact, libibverbs that comes with OFED defines (in verbs.h)
 > a qp type called IBV_QPT_RAW_ETT which equals to 7.
 > The patch that is under discussion here adds a new qp type IB_QPT_RAW_ETH and equals it to 7
 > to match the definition in user space. This indeed changes the value of IB_QPT_RAW_ETY to 8
 > but I don't see who can be affected since
 > 1. No user space program that uses IB_QPT_RAW_ETY exists
 > 2. kernel is compiled as one piece of code.

Why renumber the _ETY enum?  Maybe it doesn't break anything serious but
why risk it?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
