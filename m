From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 3/4] IB/core: Support new type of join-state
 for multicast
Date: Fri, 29 Apr 2016 15:50:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0475AC@ORSMSX109.amr.corp.intel.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
 <20160427064239.GO7974@leon.nu> <5722C839.2070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5722C839.2070704-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This doesn't seem to make any sense to me.  Without going back and
> re-reading this part of the spec, as I recall, there is:
>=20
> UnJoined
> SendOnly Join
> Full Join

The 1.2.1 version of the spec has:

JoinState - 4 bits

Join/Leave Status requested by the port. See discussion below.
bit 0: FullMember: Include/delete this endport from the multicast group=
 as a
member sender and receiver.
bit 1: NonMember: Include/delete this endport from the multicast group =
as
a non-member sender and receiver.
bit 2: SendOnlyNonMember: Include/delete this endport from the multicas=
t
group as a non-member sender only.
bit 3: Reserved

=95 FullMember: Group messages are routed both to and from the port.
The port is considered a member for purposes of group creation and
deletion, i.e.: if no member ports with FullMember=3D1 remain, the
group may be deleted; otherwise it may not.
=95 NonMember: Group messages are routed both to and from the port.
The port is not considered a member for purposes of group creation/dele=
tion.
=95 SendOnlyNonMember: Group messages are only routed from the
port; none are routed to the port. The port is not considered
a member for purposes of group creation/deletion.

Any combination of the MCMemberRecord:JoinState bits may be 1. When
multiple bits are 1, the qualities of the port's type of membership are=
 the
union of the qualities specified by the bits that are 1.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
