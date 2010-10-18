From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Extending rdma_server example
Date: Mon, 18 Oct 2010 09:25:21 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7EFD72E@orsmsx501.amr.corp.intel.com>
References: <loom.20101018T140608-776@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20101018T140608-776-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1) rdma_get_request passes event_id and (listen_id)id_priv->qp_init_attr to
>    rdma_create_qp()
> 
> 2) rdma_create_qp passes qp_init_attr to ucma_create_cqs()
> 
> 3) ucma_create_cqs stores a pointer to the created CQs in attr->recv_cq /
>    send_cq, which is the attr of the listen_id
> 
> 4) serving the second client, ucma_create_cqs checks attr->recv_cq and does
>    not create a pair of CQs
> 
> Feels a little odd to me that the listen_id takes a pointer to the CQs
> created
> for the client_id in its qp_init_attr.

This is a bug in rdma_create_qp, rdma_get_request, or both.

rdma_create_qp will modify the qp_init_attr parameter, but I need to think whether it should modify the cq pointers.  The underlying ibv_create_qp call does not, but does modify other values, so I think this call may be okay.

Because rdma_create_qp modifies the qp_init_attr parameters, rdma_get_request ends up modifying the attributes stored with the listen request.  This is definitely an error, and I'll need to come up with a fix for this.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
