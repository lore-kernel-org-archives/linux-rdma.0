From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Wed, 17 Nov 2010 09:38:47 -0800
Message-ID: <adasjyzkfyw.fsf@cisco.com>
References: <20101115140829.GA20355@mtldesk30> <ada62vxl046.fsf@cisco.com>
	<20101116180732.GB29132@mtldesk30> <ada1v6klwil.fsf@cisco.com>
	<20101117090134.GA20369@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101117090134.GA20369@mtldesk30> (Eli Cohen's message of "Wed,
	17 Nov 2010 11:01:34 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > Where is the change in handling in the members_count field?  In the firmware?
 > > 
 > The firmware now distinguishes between differnet multicast addresses
 > according to a protocol field located in the high MS byte which
 > previously was reserved. The patches that Alekseys will will probably
 > send later make use of this.

OK, so what you seem to be saying is that this patch is not fixing
anything until we add Alekseys patches?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
