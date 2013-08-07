From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH ibacm 4/8] acm.c: Fix endian of transaction ID
Date: Wed, 07 Aug 2013 14:22:59 -0400
Message-ID: <52029083.7020906@dev.mellanox.co.il>
References: <5200E1D8.1090005@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237388CA48A7@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA48A7-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/7/2013 1:29 PM, Hefty, Sean wrote:
>> It should be in network rather than host endian.
> 
> The TID is basically an abstract 64-bit handle.  I don't see that it matters what value is used, 
> provided that the sender use it consistently.

With little endian machines, the current code puts the TID in the high
bits only to be overwritten by the agent ID so the TID is effectively 0.
That being said, it works either way since currently there is only 1
outstanding query. It's a matter of better TID usage/correctness and
debug when looking at OpenSM logs as to TIDs.

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
