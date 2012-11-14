From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: Sharing MR Between Multiple Connections
Date: Wed, 14 Nov 2012 09:27:58 +0100
Message-ID: <1352881678.3346.39.camel@test.quest-ce.net>
References: <CAPb9-SHQ=r1MYu=771z2cTi9bAq=ueWMjw2vFDoSHbNByK5awA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SHQ=r1MYu=771z2cTi9bAq=ueWMjw2vFDoSHbNByK5awA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 13 novembre 2012 =C3=A0 23:36 -0500, Christopher Mitchell a =C3=
=A9crit :
> Hi,
>=20
> I am working on building an Infiniband application with a server that
> can handle many simultaneous clients. The server exposes a chunk of
> memory that each of the clients can read via RDMA. I was previously
> creating a new MR on the server for each client (and of course in tha=
t
> connection's PD). However, under stress testing, I realized that
> ibv_reg_mr() started failing after I simultaneously MRed the same are=
a
> enough times to cover 20.0 GB. I presume that the problem is reaching
> some pinning limit, although ulimit reports "unlimited" for all
> relevant possibilities.

There's a limit of the number of registered memory region per HCA.

See ibv_query_device(), struct ibv_device_attr, field max_mr.

>  I tried creating a single global PD and a
> single MR to be shared among the multiple connections, but
> rdma_create_qp() fails with an invalid argument when I try to do that=
=2E
> I therefore deduce that the PD specified in rdma_create_qp() must
> correspond to an active connection, not simply be created by opening =
a
> device.
>=20
> Long question short: is there any way I can share the same MR among
> multiple clients, so that my shared memory region is limited to N
> bytes instead of N/C (clients) bytes?
>=20

If each rdma_cm_id descriptor is tied to the same ibv_context, you migh=
t
be able to share one memory pool registered with ibv_reg_mr().
This is quite usual since you are likely to have only one HCA in your
system. Get a first context after binding your listening rdma_cm_id.=20

Regards

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
