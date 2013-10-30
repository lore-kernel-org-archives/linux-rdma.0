From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: iwarp QP transtion in rdma_disconnect
Date: Wed, 30 Oct 2013 21:48:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF2E28@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Can one of the iwarp developers tell me why the QP transition for iwarp is SQD rather than ERR during rdma_disconnect?  I can't remember the reason, and I don't see that SQD is listed as a QP state in the iwarp spec.

int rdma_disconnect(struct rdma_cm_id *id)
{
	...

	switch (id->verbs->device->transport_type) {
	case IBV_TRANSPORT_IB:
		ret = ucma_modify_qp_err(id);
		break;
	case IBV_TRANSPORT_IWARP:
		ret = ucma_modify_qp_sqd(id);
		break;


- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
