From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB core: Fix locking on device numbers allocation
Date: Wed, 31 Mar 2010 14:50:22 -0700
Message-ID: <ada8w98i2jl.fsf@roland-alpha.cisco.com>
References: <20100323191317.GA14496@mtldesk030.lab.mtl.com>
	<adaiq8l1uwp.fsf@roland-alpha.cisco.com>
	<20100325073635.GF12224@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100325073635.GF12224-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Thu, 25 Mar 2010 09:36:35 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I missed the fact the clear_bit is not atomic. So to make this
 > complete I will send a new patch with protection on the clear bit.
 > Would you like me to send a patch for user_mad too or would you push
 > that?

Hmm, actually maybe clear_bit is atomic enough for us.
<asm-generic/atmoic.h> says:

 * clear_bit() is atomic and may not be reordered.  However, it does
 * not contain a memory barrier, so if it is used for locking purposes,
 * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
 * in order to ensure changes are visible on other processors.

and I don't think we have an issue with visibility of the updates -- the
worst case I guess is a tiny window where we fail to register a new
device just as we are unregistering another device on a different CPU.

I guess I knew that already once long ago, and so that's why there isn't
locking around the clear_bit parts of things.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
