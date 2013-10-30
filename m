From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: iwarp QP transtion in rdma_disconnect
Date: Wed, 30 Oct 2013 22:24:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF2E91@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CF2E28@ORSMSX109.amr.corp.intel.com>
 <52718429.2030804@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52718429.2030804-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The SQD state is mapped to the iWARP CLOSING state.  In this state, the
> protocol tries to do an orderly connection shutdown.  In TCP terms, it
> will do the TCP FIN, FIN/ACK, ACK orderly shutdown.   If that fails, or
> for other reasons, the provider (or the application) might just move the
> QP to ERR which maps to the iWARP ERROR state which would cause an
> abrupt connection reset (one side or both sends a TCP RST).

thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
