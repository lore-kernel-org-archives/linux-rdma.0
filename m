From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Sat, 9 Jun 2012 01:27:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A2FA25@ORSMSX101.amr.corp.intel.com>
References: <4FBD6981.2070502@us.ibm.com>
  <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com>
 <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1206081745150.3988-Nzfcc2Us4m+Xfo/+vza+31aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> But to map standard networking applications to rsockets we will run i=
nto the
> above problem i.e. fork() will not work. =A0It would be very useful t=
o
> allow for the standard networking paradigm of: bind()->listen()->acce=
pt()-
> ->fork(), and then the server goes back to accept(). That would allow=
 us to
> use rsockets transparently with existing applications.

I'm aware that fork() support does not work.  The problems lie within t=
he RDMA stack, and maybe there's some way around this, but I'm not sure=
 what it would be at this point.  I can't say that I fully grasp all th=
e low level issues involved in 'fixing' it.

> Is it possible to support fork() for this standard model where the pa=
rent
> closes its copy of the newly created socket and goes back to waiting =
on the
> original socket in accept, and the child continues with the newly cre=
ated
> socket?

IMO, it seems that if we can limit the usage model to what you're descr=
ibing, then we may at least have a chance at supporting fork().

> Have you considered some other options to make this happen?
>=20
> Could we  skip creating the endpoint in raccept(), but actually creat=
e the
> new endpoint during the frist receive or send? This would then allow =
the
> fork() to occur without the complications with the pinned data.

That's an interesting possibility.  I need to give something like this =
more thought, but establishing a connection over a normal socket, then =
using that to migrate communication to a QP on the first data exchange =
may allow for fork support.  That would have an effect on trying to han=
dle fallback support (i.e. using standard sockets when RDMA fails), plu=
s may have other issues, but there may some be ideas here worth conside=
ring.

- Sean=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
