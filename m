From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] rdma_cm: add rdma_reject_msg() helper function
Date: Thu, 20 Oct 2016 16:28:53 -0500
Message-ID: <019301d22b18$f5124370$df36ca50$@opengridcomputing.com>
References: <20161020211652.35902E0C53@smtp.ogc.us> <1828884A29C6694DAF28B7E6B8A82373AB0A1CF9@ORSMSX109.amr.corp.intel.com> <018e01d22b18$31a40d10$94ec2730$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373AB0A1D24@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A1D24-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > Hey Sean, I can do that.  I thought perhaps it was better to keep it
> > static in
> > cma.c, rather than having to extern them.   But I'll make that change.
> 
> You could make them static to the ib/iw cm and export reject_msg() helper
routines
> from there.

Yea ok.  So rdma_reject_msg() calls ib_reject_msg() or iw_reject_msg()...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
