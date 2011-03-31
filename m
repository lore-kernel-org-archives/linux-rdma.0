From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: RDMA CM and IBV_WC_WR_FLUSH_ERR
Date: Thu, 31 Mar 2011 22:30:12 +0200
Message-ID: <1301603412.2766.4.camel@dworkin.quest-ce.net>
References: <1301592898.5661.10.camel@deela.quest-ce.net>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B505B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B505B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le jeudi 31 mars 2011 =C3=A0 12:34 -0700, Hefty, Sean a =C3=A9crit :
> > Is there a way to reset the QP or should the peers disconnect and
> > reconnect later.
>=20
> The QPs need to be re-configured, so reconnecting is the right approa=
ch with the rdma cm.=20

shame ...

If not using RDMA CM, would switching QP to RTR then RTS state, reset
the error status on the QP ?
If yes, does it require the same re-configuration on the other peer ?

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
