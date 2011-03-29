From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_get_cm_event() vs ibv_async_event()
Date: Tue, 29 Mar 2011 12:14:31 +0200
Message-ID: <4D91B107.2040007@mellanox.com>
References: <1301052615.2192.15.camel@deela.quest-ce.net>	<1301059658.2192.23.camel@deela.quest-ce.net> <1301391461.2192.41.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301391461.2192.41.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yann Droneaud wrote:
> [...] I caught and handle is IBV_EVENT_COMM_EST because it
> happen sometimes under high load. In this case, rdma_notify() is used to
> send the event back to RDMA CM layer. But sometimes, rdma_notify()
> returns -1 and errno is set to EISCONN : Transport endpoint is already
> connected. (It happens mostly when I'm running my test program under strace).

EISCONN means that between the time you've got the comm established 
async event to the time you reported on it by calling rdma_notify,
the kernel CM managed to establish the connection. Note that the man 
page says that rdma_notify "handle the rare situation where the 
connection never forms on its own", so as for your questions, the errno
you see isn't a failure (see the patch I sent to Sean), and you should
listen on IB async event and report the comm established for the rare 
case the kernel can't establish the connection as of repeated CM packet loss

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
