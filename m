From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_poll_cq() and wc->byte_len
Date: Wed, 13 Jun 2012 14:19:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31355@ORSMSX101.amr.corp.intel.com>
References: <ede34732991cf26d52569692a20d7ae0.squirrel@webmail.ocsa-data.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ede34732991cf26d52569692a20d7ae0.squirrel-2RFepEojUI2lDZmfZ6uX/xeHL2rgt/dS@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In a parallel universe, struct ibv_wc would have a bitmap field indicating
> which others fields are valid. In this part of the multiverse, a more
> complete documentation would be welcome. If libmlx4/libmthca behavior is
> the compliant one, I can provide an updated man page.

The best documentation available regarding expected verbs behavior is the IB spec (chapter 11).  For this specific field, see section 11.4.2:

The number of bytes transferred.
The number of bytes transferred is returned in Work Completions
for Receive Work Requests for incoming Sends and
RDMA Writes with Immediate Data. This does not include the
length of any immediate data.
The number of bytes transferred is returned in Work Completions
for Send Work Requests for RDMA Read and Atomic Operations.
For the RQ of a UD QP that is not associated with an SRQ or
for an SRQ that is associated with a UD QP, the number of
bytes transferred is the payload of the message plus the 40
bytes reserved for the GRH. For the RQ of a UD QP that is not
associated with an SRQ or for an SRQ that is associated with
a UD QP, the 40 bytes is always included, whether or not the
GRH is present.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
