From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: infiniband limit of 32 cards per system?
Date: Tue, 26 Jan 2010 15:52:52 -0800
Message-ID: <adatyu8o23v.fsf@roland-alpha.cisco.com>
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126035906.GA23347@ldl.fc.hp.com>
	<adaaaw1pl5d.fsf@roland-alpha.cisco.com>
	<20100126213803.GA12035@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100126213803.GA12035-e+Ta4ugHZmL3oGB3hsPCZA@public.gmane.org> (Alex Chiang's message of
	"Tue, 26 Jan 2010 14:38:03 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I take it this concern is what prevents us from simply increasing
 > IB_UVERBS_MAX_DEVICES to 64 or something?

Yes, I think then the device numbers will overlap.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
