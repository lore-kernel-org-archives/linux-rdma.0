From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB: new module params. cm_response_timeout,
 max_cm_retries
Date: Tue, 11 Sep 2012 10:07:31 +0200
Message-ID: <1347350851.1853.25.camel@test.quest-ce.net>
References: <1346861254-8614-1-git-send-email-dongsu.park@profitbricks.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8CC0A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8CC0A-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 10 septembre 2012 =C3=A0 19:11 +0000, Hefty, Sean a =C3=A9crit=
 :
> > Create two kernel parameters, in order to make variables configurab=
le.
> > i.e. cma_cm_response_timeout for CM response timeout,
> >      and cma_max_cm_retries for the number of retries.
> >=20
> > They can now be configured via command line for the kernel modules.
> > For example:
> >     # modprobe ib_srp cma_cm_response_timeout=3D30 cma_max_cm_retri=
es=3D60
>=20
> Rather than using a module parameter, I'd rather see this these value=
s be
> controlled through /proc/sys/net/rdma_cm, similar to how the rdma_ucm
> handles max_backlog.

Having them is better so that one can try different values without
unloading the module.

It would also be great to have default parameters to be applied to all
CM loaded.: eg. rdma_cm / ib_srp default parameters should be made
available from ib_cm ?

> For the rdma_cm, I also prefer something more generic.
> CM retries is fine, but exposing wonky IB timeout (4.096 x 2^X us) to=
=20
> the user is less than ideal.

Sure, but which kind of approximation the kernel module is going to
do ?=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
