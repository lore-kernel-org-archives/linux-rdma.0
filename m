From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Change a warning message to debug
Date: Mon, 13 Dec 2010 13:55:41 -0800
Message-ID: <adazks9gwwy.fsf@cisco.com>
References: <20101208080602.GA9649@mtldesk30> <adaipz4jddc.fsf@cisco.com>
	<20101210122759.GA28088@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101210122759.GA28088@mtldesk30> (Eli Cohen's message of "Fri,
	10 Dec 2010 14:27:59 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Not sure I agree ... surely the point of this message is for the user to
 > > see it and know to update firmware?  Otherwise why print anything at
 > > all, since I'm sure you guys have already fixed the firmware and have a
 > > regression test so this bug doesn't reappear?

 > Right :-)

So what do you think -- remove the message entirely or leave it?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
