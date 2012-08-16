From: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: rdma_connect() timeout question
Date: Thu, 16 Aug 2012 14:01:56 -0500
Message-ID: <502D43A4.1090708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Is there a way to tune rdma_connect() timeout to a lower value ?
With CMA_CM_RESPONSE_TIMEOUT as 20 and CMA_MAX_CM_RETRIES 15,
it takes about a minute to timeout. We would like to tune it in our case 
to a much lower value.

The scenario is RDS trying to reconnect when a bonding interface 
notifies us of a link fail over.
In our setup the gratuitous arp doesn't arrive sometimes to update the 
arp entry with the new GID.
The address resolution returns the old GID. Route resolution also 
happens to return the old path in this failure case.
(Other times when route solution fails it is not a problem. The 
reconnect attempts eventually go through in those cases.)
And the rdma_connect() gets stuck. A timeout in 1 minute and a 
subsequent retry of address/route-resolution/rdma_connect then succeeds.
Because by that time the arp entry is updated.

Can cma_response_timeout and CMA_MAX_CM_RETRIES be made tunables ?
Even better would have been if the caller (RDS in this case) could have 
passed them as connection setup parameters. ;-)
That way we don't have to disturb the setting for non-RDS traffic.

Venkat


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
