From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] infiniband:cxgb4:Fix incorrect return statement in the function c4iw_reject_cr
Date: Thu, 27 Aug 2015 09:14:47 -0500
Message-ID: <000801d0e0d2$bb99b0b0$32cd1210$@opengridcomputing.com>
References: <1440634906-16103-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440634906-16103-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nicholas Krause' <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, August 26, 2015 7:22 PM
> To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] infiniband:cxgb4:Fix incorrect return statement in the function c4iw_reject_cr
> 
> This fixes the incorrect return statement in the function
> c4iw_reject_cr that returns the value zero directly to instead
> return the variable err as this function can fail when called
> and if so we will incorrectly return success rather then the
> correct status of a failed call to the caller of this particular
> function.
> 
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

NAK.  

The return code for these cpl handlers indicates if process_work() or other callers needs to free the skb.   They are supposed to
return 0.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
