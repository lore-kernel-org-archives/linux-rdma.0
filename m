From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma_get_cm_event() vs ibv_async_event()
Date: Tue, 29 Mar 2011 12:33:35 +0200
Message-ID: <1301394815.2193.2.camel@deela.quest-ce.net>
References: <1301052615.2192.15.camel@deela.quest-ce.net>
	 <1301059658.2192.23.camel@deela.quest-ce.net>
	 <1301391461.2192.41.camel@deela.quest-ce.net>
	 <4D91B107.2040007@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D91B107.2040007-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 29 mars 2011 =C3=A0 12:14 +0200, Or Gerlitz a =C3=A9crit :
> Yann Droneaud wrote:
> > [...] I caught and handle is IBV_EVENT_COMM_EST because it
> > happen sometimes under high load. In this case, rdma_notify() is us=
ed to
> > send the event back to RDMA CM layer. But sometimes, rdma_notify()
> > returns -1 and errno is set to EISCONN : Transport endpoint is alre=
ady
> > connected. (It happens mostly when I'm running my test program unde=
r strace).
>=20
> EISCONN means that between the time you've got the comm established=20
> async event to the time you reported on it by calling rdma_notify,
> the kernel CM managed to establish the connection. Note that the man=20
> page says that rdma_notify "handle the rare situation where the=20
> connection never forms on its own", so as for your questions, the err=
no
> you see isn't a failure (see the patch I sent to Sean), and you shoul=
d
> listen on IB async event and report the comm established for the rare=
=20
> case the kernel can't establish the connection as of repeated CM pack=
et loss
>=20

Thanks for the information.

So ignoring IBV_EVENT_COMM_EST async event seems the best option when
using RDMA CM to establish connection ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
