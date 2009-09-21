From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Do not turn on carrier  to a non active port
Date: Mon, 21 Sep 2009 08:45:35 -0700
Message-ID: <adaskeg8fog.fsf@cisco.com>
References: <4AB20C6C.9090005@Voltaire.COM> <adamy4td0zp.fsf@cisco.com>
	<4AB7488E.6090700@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB7488E.6090700-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org> (Moni Shoua's message of "Mon, 21
	Sep 2009 12:34:06 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I may miss this but I don't  see how ipoib_ib_dev_down() is called with rtnl held.

It's called from ipoib_stop(), and .ndo_stop is called with rtnl held.

 > Anyway, the new patch doesn't use delayed work.

great
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
