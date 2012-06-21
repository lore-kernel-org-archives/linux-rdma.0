From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA_CM_EVENT_REJECTED and ressources release
Date: Thu, 21 Jun 2012 08:11:47 +0200
Message-ID: <1340259107.2288.7.camel@dworkin.quest-ce.net>
References: <1340201995.2468.24.camel@test.quest-ce.net>
	 <CAFRond5aFKD1orfM=3wdDkkHq47b8BkY2RiidMLJDTy014gdLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFRond5aFKD1orfM=3wdDkkHq47b8BkY2RiidMLJDTy014gdLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Veerendra Allada <allada.v-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le mercredi 20 juin 2012 =C3=A0 21:27 -0400, Veerendra Allada a =C3=A9c=
rit :
> Is it possible to delay the memory registrations (ibv_reg_mr) and  th=
e
> ibv_post_recv()'s until the connection is established ? Based on what
> i understood, i am suggesting the following sequence of calls on
> Client and Server. See if it helps.
>=20
> Client
> rdma_create_event_channel()
> rdma_create_id()
> rdma_resolve_addr()
> ibv_alloc_pd()
> ibv_create_comp_channel()
> ibv_create_cq()
> rdma_create_qp()
> rdma_resolve_route()
> rdma_connect()
>=20
> If the connection is not successful, call the corresponding destroy
> calls in the the reverse order.
> If the connection is successful, register memory and post the receive
> calls.
>=20
> Server
> rdma_create_event_channel()
> rdma_create_id()
> rdma_bind_addr()
> rdma_listen()
>=20
> Up on a new incoming connection request, do the following sequence.
>=20
> ibv_alloc_pd()
> ibv_create_comp_channel()
> ibv_create_cq()
> rdma_create_qp()
> rdma_accept()
>=20
> After the connection is successful, register memory and then post
> receive requests.
> At this point you should be able to post ibv_post_send requests and
> poll your completion queue's, etc.
>=20

Thanks for your answer, but it's not applicable on my case:

I have to post receive works before doing rdma_accept()/rdma_connect()
so that both side are ready to receive messages sent by other peer.

Not doing so will lead to races, RNR errors will be triggered on the
sending side if it's faster than the receiving side.

If the protocol implemented above the RDMA connection is
request/response based and initiated by the client, the client could
follow your proposed scheme, but on the server side, it will have to
post receive works before calling rdma_accept().

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
