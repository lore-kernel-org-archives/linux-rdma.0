From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: rdma_get_cm_event() vs ibv_async_event()
Date: Tue, 29 Mar 2011 11:37:41 +0200
Message-ID: <1301391461.2192.41.camel@deela.quest-ce.net>
References: <1301052615.2192.15.camel@deela.quest-ce.net>
	 <1301059658.2192.23.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301059658.2192.23.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[This question was already asked on ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org]

Hi,

I'm using RDMA CM to manage connections above Infiniband.

On the server side, RDMA CM event are monitored using an event channel 
created by rdma_create_event_channel(), polled using file descriptor
rdma_event_channel->fd  and later processed by rdma_get_cm_event() on
event.

After a connection is established, IB async events are polled using the
file descriptor found in the associated connection id returned by RDMA
CM layer: ibv_context->async_fd and proceed using ibv_get_async_event().

But the only event I caught and handle is IBV_EVENT_COMM_EST because it
happen sometimes under high load. In this case, rdma_notify() is used to
send the event back to RDMA CM layer. But sometimes, rdma_notify()
returns -1 and errno is set to EISCONN : Transport endpoint is already
connected. (It happens mostly when I'm running my test program under
strace).

I'm suspecting there's some kind of race between RDMA event channel and
IB async event processing.

So here's my question: should I monitor async events using
ibv_get_async_event() or is it fully managed by the RDMA CM layer ?

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
