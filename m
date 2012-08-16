From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_connect() timeout question
Date: Thu, 16 Aug 2012 19:40:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A899E6@ORSMSX101.amr.corp.intel.com>
References: <502D43A4.1090708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502D43A4.1090708-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is there a way to tune rdma_connect() timeout to a lower value ?

I don't believe so.

You could abort the connection by destroying the id after a specified amount of time had expired.

> Can cma_response_timeout and CMA_MAX_CM_RETRIES be made tunables ?
> Even better would have been if the caller (RDS in this case) could have
> passed them as connection setup parameters. ;-)
> That way we don't have to disturb the setting for non-RDS traffic.

A per rdma_cm_id option for this makes sense to me. 

iWarp developers, would timeout/retry values be usable for iwarp?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
