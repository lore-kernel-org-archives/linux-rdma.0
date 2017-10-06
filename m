From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 09/47] RDMA/cxgb3: Annotate locking assumptions
Date: Fri, 6 Oct 2017 17:05:27 -0500
Message-ID: <01ae01d33eef$37b2ffe0$a718ffa0$@opengridcomputing.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com> <20171006213333.6721-10-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-10-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 09/47] RDMA/cxgb3: Annotate locking assumptions
> 
> Tell sparse what the locking assumptions are for __flush_qp() such
> that it does not complain about the locking operations inside that
> function.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Looks ok to me.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
