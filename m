From: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Subject: RE: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 16:56:47 -0500
Message-ID: <OF9C37A96F.2010A304-ON8825791A.00784F38-8625791A.00788E65@sybase.com>
References: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0@sybase.com> <CAL1RGDVaN58y4u6TtwWuhGMsUuGxMQJkObqHPk2J=Gt0nPAxOQ@mail.gmail.com> <OFF9ECDEA0.0854A87D-ON8825791A.00743004-8625791A.007705D2@sybase.com> <1828884A29C6694DAF28B7E6B8A8237316E68956@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E68956-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doh!  When I did the channel semantics implementation earlier in the year 
I put this into my code:

        /*
        ** RESOLVE: avoiding the responser resources and initiator depth 
for
        ** now.
        */
        connp->responder_resources = 0;
        connp->initiator_depth = 0;

Working like a champ now :-)

Thanks for your help guys.

-Dave




From:
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To:
"David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org" <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>, Roland Dreier 
<roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc:
linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 
"linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date:
09/29/2011 04:45 PM
Subject:
RE: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ



> I'm using RDMA CM.  I am making the ibv_modify_qp() call immediately 
after
> rdma_create_qp().  Should I move this code after the rdma_connect() /
> rdma_accept()?
> 
> Sample code I am looking at is from the OFA coding course.

If you're using the rdma cm, the QP transitions are handled for you (no 
need to call ibv_modify_qp).  You only need to specify the correct 
responder_resources and initiator_depth in struct rdma_conn_param before 
calling rdma_connect() on the client side and rdma_accept() on the server 
side.  Note that you can use RDMA_MAX_RESP_RES and RDMA_MAX_INIT_DEPTH to 
indicate that the rdma cm should use the maximum value supported by the 
hardware.

- Sean




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
