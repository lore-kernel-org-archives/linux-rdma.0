From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: WRITE_WITH_IMMEDIATE target semantic
Date: Mon, 20 Sep 2010 10:25:04 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78CAB5@orsmsx501.amr.corp.intel.com>
References: <OF2575B7D8.9367EBA3-ONC12577A4.0057C50D-C12577A4.005AD45D@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF2575B7D8.9367EBA3-ONC12577A4.0057C50D-C12577A4.005AD45D-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> (1) fetch the next receive queue / shared receive queue entry and
>     store the value of the immediate data (32 bits at the API)
>     along with that RQE.
> 
> (2) place data according to the inbound WRITE hdr but ignore the
>     SGL of the RQE.
> 
> (3) after completion processing the WRITE:
>     (1) create a work completion of type IBV_WC_RECV_RDMA_WITH_IMM,
>     (2) transfer the immediate data value into the 'imm_data' field,
>     (3) set the WC's 'byte_len' to the received WRITE payload,
>     (4) set IBV_WC_WITH_IMM at 'wc_flags', and
>     (5) append the WC to the associated CQ.
> 
> With that, the receiver would have to carefully inspect the operation
> type of the work completion, since a receive queue entry may turn into
> a IBV_WC_RECV or IBV_WC_RECV_RDMA_WITH_IMM. In the second case, the data
> are placed according to the senders opinion, which may not be the
> result a non-aware receiver would expect.
> 
> correct?

This looks correct to me, but I didn't trace through the spec.  The only other thing I can think of is to check the solicited bit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
