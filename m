From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Thu, 21 Oct 2010 21:15:59 -0700
Message-ID: <adavd4uyi9s.fsf@cisco.com>
References: <20100826141851.GI8795@mtldesk30> <adazku85dcf.fsf@cisco.com>
	<20101021072703.GA1912@mtldesk30> <adazku78gzz.fsf@cisco.com>
	<20101021225133.GA6367@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101021225133.GA6367@mtldesk30> (Eli Cohen's message of "Fri,
	22 Oct 2010 00:51:33 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > This was added in the past when I wanted to use the pointer to the net
 > device to resolve any IPv6 address. Since we only resolve link local
 > addresses, why don't we just remove the spinlocks and the check inside
 > it?

OK, easy enough.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
