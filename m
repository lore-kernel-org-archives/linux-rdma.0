From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: Extending =?utf-8?b?cmRtYV9zZXJ2ZXI=?= example
Date: Mon, 18 Oct 2010 12:31:02 +0000 (UTC)
Message-ID: <loom.20101018T140608-776@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I took librdmacm/examples/rdma_server.c and converted it to be a persistent
server to serve successive requests. However, this does not work and I have 
the following problem:

fprintfs from my code (lower case) and librdmacm (caps) for a first successful
connection and a second one which causes a segfault

rdma_getaddrinfo
rdma_listen
rdma_getrequest              <----- wait for first request
RDMA CREATE QP
UCMA CREATE_CQS
CALLED UCMA CREATE CQS
CREATING RECV_CQ             <----- CQ created here OK for client connection
CREATING SEND_CQ             <----- this looks good
IBV CREATE QP
rdma_reg_msgs
rdma_post_recv
rdma_accept
rdma_get_recv_comp
rdma_post_send
rdma_get_send_comp
rdma_getrequest              <----- wait for second request
RDMA CREATE QP
UCMA CREATE_CQS
CALLED UCMA CREATE CQS       <----- !!! no recv/send CQ created here
IBV CREATE QP
rdma_reg_msgs
rdma_post_recv
rdma_accept
rdma_get_recv_comp           <----- dereference of id->recv_cq = NULL
Segmentation fault

So I'm wondering why the CQs do not get created second time round and it
looks like

1) rdma_get_request passes event_id and (listen_id)id_priv->qp_init_attr to
   rdma_create_qp()

2) rdma_create_qp passes qp_init_attr to ucma_create_cqs()

3) ucma_create_cqs stores a pointer to the created CQs in attr->recv_cq /
   send_cq, which is the attr of the listen_id

4) serving the second client, ucma_create_cqs checks attr->recv_cq and does 
   not create a pair of CQs

Feels a little odd to me that the listen_id takes a pointer to the CQs created
for the client_id in its qp_init_attr.

Can anyone enlighten me? Am I trying to do something (persistent server) that
rdma_get_request is not intended to do?

Cheers,
Jonathan Rosser
Senior R&D Engineer
BBC R&D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
