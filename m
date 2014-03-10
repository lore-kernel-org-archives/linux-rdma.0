From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/core: Suppress a sparse warning
Date: Mon, 10 Mar 2014 09:08:03 -0700
Message-ID: <20140310160803.GC21124@linux.vnet.ibm.com>
References: <531DAEA1.7060703@acm.org>
 <1394458406.3257.53.camel@localhost.localdomain>
 <531DCB7D.9020104@acm.org>
 <1394463733.3257.62.camel@localhost.localdomain>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1394463733.3257.62.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 10, 2014 at 04:02:13PM +0100, Yann Droneaud wrote:
> Hi,
>=20
> Le lundi 10 mars 2014 =E0 15:26 +0100, Bart Van Assche a =E9crit :
> > On 03/10/14 14:33, Yann Droneaud wrote:
> > > Le lundi 10 mars 2014 =E0 13:22 +0100, Bart Van Assche a =E9crit =
:
> > >> Suppress the following sparse warning:
> > >> include/rdma/ib_addr.h:187:24: warning: cast removes address spa=
ce of expression
> > >=20
> > > You should explain why there's a warning here, and why is it safe=
 to
> > > cast. (I believe it's related to RCU domain ?)
> >=20
> > Hello Yann,
> >=20
> > Now that I've had a closer look at the code in include/rdma/ib_addr=
=2Eh,
> > that code probably isn't safe. How about the (untested) patch below=
 ?
> >=20
>=20
> Thanks for investigating.
>=20
> I'm not an expert in RCU, but I believe it then miss the RCU annotati=
ons
> around the RCU reader section (ensure correct ordering if I recall
> correctly).
>=20
> Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

If the rcu_read_lock() isn't supplied by all callers to this function,
then yes, it needs to be supplied as Yann shows below.

The CONFIG_PROVE_RCU=3Dy Kconfig option can help determine that they ar=
e
needed, but of course cannot prove that they are not needed, at least
not unless you have a workload that exercises all possible calls to
this function.

							Thanx, Paul

> > diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> > index ce55906..5a416ac 100644
> > --- a/include/rdma/ib_addr.h
> > +++ b/include/rdma/ib_addr.h
> > @@ -184,7 +184,7 @@ static inline void iboe_addr_get_sgid(struct rd=
ma_dev_addr *dev_addr,
> > =20
> >  	dev =3D dev_get_by_index(&init_net, dev_addr->bound_dev_if);
> >  	if (dev) {
>=20
> +		rcu_read_lock();
>=20
> > -		ip4 =3D (struct in_device *)dev->ip_ptr;
> > +		ip4 =3D __in_dev_get_rcu(dev);
>=20
> >  		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
> >  			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
> >  					       (struct in6_addr *)gid);
>=20
> +		rcu_read_unlock();
>=20
>=20
> Regards.
>=20
> --=20
> Yann Droneaud
> OPTEYA
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
