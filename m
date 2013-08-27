From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH librdmacm 0/3] no IBV_SEND_INLINE thus memory
 registration required on QLogic/Intel HCA
Date: Tue, 27 Aug 2013 18:36:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA890E@ORSMSX109.amr.corp.intel.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> While doing some tests, I've found that rdma_client failed
> on my QLogic/Intel QLE7340 / QLE7342 HCA:
> 
>     # rdma_client
>     rdma_client: start
>     rdma_post_send 22
>     rdma_client: end -1
> 
> I had a deeper look on the examples and found that max_inline_data was
> returned as 0,

The man page to ibv_create_qp() states:

   The function ibv_create_qp() will update the qp_init_attr->cap struct
   with the actual QP values of the QP that was created; the values will
   be greater than or equal to the values requested.

>From this, it sounds like there is a bug in the Intel provider.  The ibv_create_qp call should have failed.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
