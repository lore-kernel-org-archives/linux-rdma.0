From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: setting responder_resources and initiator_depth
Date: Mon, 11 Jan 2010 13:18:15 -0800
Message-ID: <E69F6C680DF146E594FCD1C70F1B01E1@amr.corp.intel.com>
References: <4B4B8DFB.1000601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4B8DFB.1000601-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Andy Grover' <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Currently, the RDS code sets both of these to 1 when calling
>rdma_accept(). Using an arbitrary greater value (e.g. 64) doesn't seem
>to work right.
>
>I can call ib_query_qp(). Am I to assume I can set initiator_depth up to
>ib_qp_attr.max_rd_atomic, and responder_resources to
>ib_qp_attr.max_dest_rd_atomic and this will work?

You need to coordinate the values with those supported by the remote end of the
connection.  See the rdma_connect and rdma_accept man pages for additional
details.  The librdmacm has checks in rdma_connect and rdma_accept to verify
that the values provided by the user at least make sense for the local HW.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
