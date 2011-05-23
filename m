From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fail-over through Bonding with SDP over IB
Date: Mon, 23 May 2011 15:25:20 +0530
Message-ID: <BANLkTi=P1LBs_oHD+F+mV7WogrHonvd3eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I have found a work-around to achieve fail-over through IB bonding. I
am using OFED_1.5.2.

In the SDP module, sdp_cma_handler gets the
RDMA_CM_EVENT_ADDR_CHANGE(14) event at the time of link failure. At
present no handling is defined for this event so it goes to the
default switch case:

default:
               printk(KERN_ERR "SDP: Unexpected CMA event: %d\n",
                      event->event);
               rc = -ECONNABORTED;
               break;

If I just comment out the "rc = -ECONNABORTED;" line and then load
this module, fail-over is functioning properly. But then I think that
if it is so easy then why is it not implemented yet?

Please provide your inputs on this.

Thanks,
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
