From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 12:34:02 +0300
Message-ID: <20110519093402.GB2659@mtldesk30>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
 <1303467645.2243.47.camel@deela.quest-ce.net>
 <20110519060704.GA2659@mtldesk30>
 <1305796637.2359.6.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1305796637.2359.6.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2011 at 11:17:16AM +0200, Yann Droneaud wrote:
> 
> Have you some test code for me to test ?
> 

I used ibv_rc_pingpong which is part of libiberbs. the '-r' option
allows you to define the queue depth. Please try it and let me know.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
