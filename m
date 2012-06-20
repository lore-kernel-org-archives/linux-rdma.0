From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RDMA_CM_EVENT_REJECTED and ressources release
Date: Wed, 20 Jun 2012 16:19:55 +0200
Message-ID: <1340201995.2468.24.camel@test.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm trying to make my InfiniBand verbs/RDMA application more reliable
regarding RDMA CM error events.

In particular, I'm trying to handle verbs ressources release.

Here's a scenarii from the client point of view:

rdma_resolve_addr()
    => event RDMA_CM_EVENT_ADDR_RESOLVED
rdma_resolv_route()
    => event RDMA_CM_EVENT_ROUTE_RESOLVED
ibv_reg_mr()
ibv_create_cq()
rdma_create_qp()
rdma_connect()
    => event RDMA_CM_EVENT_REJECTED !

In the handler of RDMA_CM_EVENT_REJECTED, I could handle this in two
different ways:

- call rdma_disconnect(): even if the connection is not established, 
  rdma_disconnect() can be called.

  In this case, all receive WR posted came back in error.

  But there's no event RDMA_CM_EVENT_TIMEWAIT_EXIT to handle
  where the program could call rdma_destroy_qp(), ibv_destroy_cq(), 
  ibv_dereg_mr(), and rdma_destroy_id().

  Note there's no event RDMA_CM_EVENT_DISCONNECTED either (indeed).

- call rdma_destroy_qp(), ibv_destroy_cq(), ibv_dereg_mr(), and 
  rdma_destroy_id(). 
  
  Before calling ibv_destroy_cq(), the program call ibv_poll_cq() to 
  flush the CQ (but the function return -2 when called on the CQ used 
  to hold receive WC, but without problem on the one used to hold send 
  WC)

  The completion channel which was registered against the CQ is 
  notified of an event. ibv_get_cq_event() will return a pointer 
  to the destroyed CQ and ibv_poll_cq() return 0 (no WC).
  (and currently my code is calling ibv_ack_cq_events() then 
   ibv_req_notify_cq() on the CQ returned by ibv_get_cq_event).


Neither solution seems really suitable to me.

Do you have any tip/hint to handle this situation.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
