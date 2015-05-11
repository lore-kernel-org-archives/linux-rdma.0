From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] IB/core, cma: Nice log-friendly string helpers
Date: Mon, 11 May 2015 17:21:04 +0200
Message-ID: <1431357664.25060.40.camel@opteya.com>
References: <1431353456-3862-1-git-send-email-sagig@mellanox.com>
		 <1431353456-3862-2-git-send-email-sagig@mellanox.com>
	 <1431355084.25060.36.camel@opteya.com>
	 <5550C1A1.4060503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5550C1A1.4060503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 11 mai 2015 =C3=A0 17:50 +0300, Sagi Grimberg a =C3=A9crit :
> On 5/11/2015 5:38 PM, Yann Droneaud wrote:
> > Le lundi 11 mai 2015 =C3=A0 17:10 +0300, Sagi Grimberg a =C3=A9crit=
 :
> >> Some of us keep revisiting the code to decode enumerations that
> >> appear in out logs. Let's borrow the nice logging helpers that
> >> exists in xprtrdma and rds for CMA events, IB events and WC status=
es.
> >>
> >> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>   drivers/infiniband/core/cma.c   |   26 ++++++++++++++++
> >>   drivers/infiniband/core/verbs.c |   61 +++++++++++++++++++++++++=
++++++++++++++
> >>   include/rdma/ib_verbs.h         |    4 ++
> >>   include/rdma/rdma_cm.h          |    2 +
> >>   4 files changed, 93 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/co=
re/cma.c
> >> index d570030..fb5a815 100644
> >> --- a/drivers/infiniband/core/cma.c
> >> +++ b/drivers/infiniband/core/cma.c
> >> @@ -65,6 +65,32 @@ MODULE_LICENSE("Dual BSD/GPL");
> >>   #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
> >>   #define CMA_IBOE_PACKET_LIFETIME 18
> >>
> >> +static const char *cma_events[] =3D {
> >
> > Go for .rodata:
> >
> > static const char * const cma_events[] =3D {
> >

What about const here ?

> >> +	[RDMA_CM_EVENT_ADDR_RESOLVED]	=3D "ADDR_RESOLVED",
> >> +	[RDMA_CM_EVENT_ADDR_ERROR]	=3D "ADDR_ERROR",
> >> +	[RDMA_CM_EVENT_ROUTE_RESOLVED]	=3D "ROUTE_RESOLVED",
> >> +	[RDMA_CM_EVENT_ROUTE_ERROR]	=3D "ROUTE_ERROR",
> >> +	[RDMA_CM_EVENT_CONNECT_REQUEST]	=3D "CONNECT_REQUEST",
> >> +	[RDMA_CM_EVENT_CONNECT_RESPONSE]=3D "CONNECT_RESPONSE",
> >> +	[RDMA_CM_EVENT_CONNECT_ERROR]	=3D "CONNECT_ERROR",
> >> +	[RDMA_CM_EVENT_UNREACHABLE]	=3D "UNREACHABLE",
> >> +	[RDMA_CM_EVENT_REJECTED]	=3D "REJECTED",
> >> +	[RDMA_CM_EVENT_ESTABLISHED]	=3D "ESTABLISHED",
> >> +	[RDMA_CM_EVENT_DISCONNECTED]	=3D "DISCONNECTED",
> >> +	[RDMA_CM_EVENT_DEVICE_REMOVAL]	=3D "DEVICE_REMOVAL",
> >> +	[RDMA_CM_EVENT_MULTICAST_JOIN]	=3D "MULTICAST_JOIN",
> >> +	[RDMA_CM_EVENT_MULTICAST_ERROR]	=3D "MULTICAST_ERROR",
> >> +	[RDMA_CM_EVENT_ADDR_CHANGE]	=3D "ADDR_CHANGE",
> >> +	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	=3D "TIMEWAIT_EXIT",
> >> +};
> >> +
> >> +__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event=
_type event)
> >
> > __attribute_const__ is useless here.
>=20
> Yeh.. either that or const, I'll remove it...
>=20

I can see you have removed the attribute from the prototype too,
it's a pity:

http://marc.info/?i=3D1431356425-13582-2-git-send-email-sagig@mellanox.=
com
http://mid.gmane.org/1431356425-13582-2-git-send-email-sagig@mellanox.c=
om

I'm sorry if it wasn't clear:

When I said "here", it's here in the .c file.
The prototype in the .h file is fine with __attribute_const__.


> >
> >> +{
> >> +	return (unsigned)event < ARRAY_SIZE(cma_events) ?
> >> +			cma_events[(unsigned)event] : "UNRECOGNIZED_EVENT";
> >
> > You could be a bit more paranoid here:
> >
> >            size_t index =3D event;
> >
> >            return (index < ARRAY_SIZE(cmd_events) && cma_events[ind=
ex]) ?
> > 			cma_events[index] : "UNRECOGNIZED_EVENT";
> >
>=20
> I'm fine with that too...

So you're fine with the function to return NULL ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
