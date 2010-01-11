From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: setting responder_resources and initiator_depth
Date: Mon, 11 Jan 2010 12:45:47 -0800
Message-ID: <4B4B8DFB.1000601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Currently, the RDS code sets both of these to 1 when calling
rdma_accept(). Using an arbitrary greater value (e.g. 64) doesn't seem
to work right.

I can call ib_query_qp(). Am I to assume I can set initiator_depth up to
ib_qp_attr.max_rd_atomic, and responder_resources to
ib_qp_attr.max_dest_rd_atomic and this will work?

Thanks -- Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
