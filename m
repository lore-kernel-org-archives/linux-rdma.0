From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/core: Suppress a sparse warning
Date: Mon, 10 Mar 2014 15:26:05 +0100
Message-ID: <531DCB7D.9020104@acm.org>
References: <531DAEA1.7060703@acm.org> <1394458406.3257.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394458406.3257.53.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/10/14 14:33, Yann Droneaud wrote:
> Le lundi 10 mars 2014 =C3=A0 13:22 +0100, Bart Van Assche a =C3=A9cri=
t :
>> Suppress the following sparse warning:
>> include/rdma/ib_addr.h:187:24: warning: cast removes address space o=
f expression
>=20
> You should explain why there's a warning here, and why is it safe to
> cast. (I believe it's related to RCU domain ?)

Hello Yann,

Now that I've had a closer look at the code in include/rdma/ib_addr.h,
that code probably isn't safe. How about the (untested) patch below ?

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ce55906..5a416ac 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -184,7 +184,7 @@ static inline void iboe_addr_get_sgid(struct rdma_d=
ev_addr *dev_addr,
=20
 	dev =3D dev_get_by_index(&init_net, dev_addr->bound_dev_if);
 	if (dev) {
-		ip4 =3D (struct in_device *)dev->ip_ptr;
+		ip4 =3D __in_dev_get_rcu(dev);
 		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
 			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
 					       (struct in6_addr *)gid);
--=20
1.8.4.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
