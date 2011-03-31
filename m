From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RDMA CM and IBV_WC_WR_FLUSH_ERR
Date: Thu, 31 Mar 2011 19:34:58 +0200
Message-ID: <1301592898.5661.10.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

While testing message flooding between two peers (IBV_SEND),
at one point, I'm getting error IBV_WC_RNR_RETRY_EXC_ERR : life is hard
even with a rx queue with 2048 WR and a tx queue with only 64 WR: but it
seems to be also the sign that underlying hardware is running faster
than the software, which is a good point.

But all queued send requests are returned with error
IBV_WC_WR_FLUSH_ERR. And there's no way to enqueue others work request
that will be sent.

Is there a way to reset the QP or should the peers disconnect and
reconnect later.

I know it is possible to set QP attribute rnr_retry_count to 7 to enable
infinite retry, but it seems to be only a workaround. Some kind of flow
control at the application level would be better.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
