From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: infiniband limit of 32 cards per system?
Date: Mon, 25 Jan 2010 16:50:13 -0700
Message-ID: <20100125235013.GD2828@grease.ALLEYCAT>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm pretty unfamiliar with Infiniband, so apologies for the
stupid question.

Is there a limit on how many IB devices a system might support?

My colleague points out the following enum in uverbs_main.c:

	enum {
		IB_UVERBS_MAJOR       = 231,
		IB_UVERBS_BASE_MINOR  = 192,
		IB_UVERBS_MAX_DEVICES = 32
	};

Experimentally, we've determined that on a system where we
plugged in 40 IB cards, OFED only reports 32 cards are present.

If that enum is indeed the limiting factor, would someone mind
explaining (or pointing me at TFM ;) why it's limited to 32
devices?

Thanks,
/ac

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
