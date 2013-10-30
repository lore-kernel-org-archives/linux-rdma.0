From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: iwarp QP transtion in rdma_disconnect
Date: Wed, 30 Oct 2013 17:11:53 -0500
Message-ID: <52718429.2030804@opengridcomputing.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CF2E28@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF2E28-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SQD state is mapped to the iWARP CLOSING state.  In this state, the 
protocol tries to do an orderly connection shutdown.  In TCP terms, it 
will do the TCP FIN, FIN/ACK, ACK orderly shutdown.   If that fails, or 
for other reasons, the provider (or the application) might just move the 
QP to ERR which maps to the iWARP ERROR state which would cause an 
abrupt connection reset (one side or both sends a TCP RST).



On 10/30/2013 4:48 PM, Hefty, Sean wrote:
> Can one of the iwarp developers tell me why the QP transition for iwarp is SQD rather than ERR during rdma_disconnect?  I can't remember the reason, and I don't see that SQD is listed as a QP state in the iwarp spec.
>
> int rdma_disconnect(struct rdma_cm_id *id)
> {
> 	...
>
> 	switch (id->verbs->device->transport_type) {
> 	case IBV_TRANSPORT_IB:
> 		ret = ucma_modify_qp_err(id);
> 		break;
> 	case IBV_TRANSPORT_IWARP:
> 		ret = ucma_modify_qp_sqd(id);
> 		break;
>
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
