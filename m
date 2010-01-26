From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: infiniband limit of 32 cards per system?
Date: Mon, 25 Jan 2010 19:48:28 -0800
Message-ID: <adaiqapplv7.fsf@roland-alpha.cisco.com>
References: <20100125235013.GD2828@grease.ALLEYCAT>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100125235013.GD2828-TYHnb5JFxdjwUeR5qC7q4g@public.gmane.org> (Alex Chiang's message of
	"Mon, 25 Jan 2010 16:50:13 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > My colleague points out the following enum in uverbs_main.c:
 > 
 > 	enum {
 > 		IB_UVERBS_MAJOR       = 231,
 > 		IB_UVERBS_BASE_MINOR  = 192,
 > 		IB_UVERBS_MAX_DEVICES = 32
 > 	};
 > 
 > Experimentally, we've determined that on a system where we
 > plugged in 40 IB cards, OFED only reports 32 cards are present.

wow, 40 HCAs in one system !

 > If that enum is indeed the limiting factor, would someone mind
 > explaining (or pointing me at TFM ;) why it's limited to 32
 > devices?

That dates back to when device #s had 8 bits for major and 8 bits for
minor.  We got one major assigned for IB, and had to split up the 256
minors that gave us among userspace verbs, management access, etc.  And
32 seemed like a pretty reasonable limit for most uses.

Nowadays I guess we should look into expanding that to dynamic device
numbers on overflow, assuming you do have a realistic situation where
someone would want to use that many adapters per system.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
