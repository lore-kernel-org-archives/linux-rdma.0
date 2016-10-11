From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: build failure on linus' latest master branch
Date: Tue, 11 Oct 2016 09:30:35 -0500
Message-ID: <004701d223cc$0772cbb0$16586310$@opengridcomputing.com>
References: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com> <20161011120219.GM9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161011120219.GM9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Is there a fix for this?
> 
> We investigated a lot this failure and it appears on specific and very
> old GCC 4.4.
> http://www.spinics.net/lists/linux-rdma/msg39135.html
> http://marc.info/?t=147614305200001&r=1&w=2
> 
> And the fix is http://marc.info/?l=linux-netdev&m=147615976207362&w=2
> 

Thanks.  So was it ever merged?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
