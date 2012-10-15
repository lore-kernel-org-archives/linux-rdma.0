From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: Is there a way to transfer a rdma connection between userspace
 processes?
Date: Mon, 15 Oct 2012 11:07:22 +0200
Message-ID: <1350292042.2750.11.camel@dworkin.quest-ce.net>
References: <507BC8EE.2020908@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507BC8EE.2020908-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le lundi 15 octobre 2012 =C3=A0 10:27 +0200, Stefan (metze) Metzmacher =
a
=C3=A9crit :
> Hi,
>=20
> I'm currently researching how to implement SMBDirect [MS-SMBD]
> together with the multi channel feature of SMB 3.0 in Samba.
>=20
> As Samba currently uses one process per tcp connection
> and maintains a lot of in memory state within the process
> (e.g. for the SMB_VFS modules) it would require a lot of work
> to change Samba to coordinate two (or more) processes for one logical
> multi channel connection.
>=20
> My current plan tries to pass the socket fd of new connections
> (which join an existing multi channel session) via fd-passing to
> the existing process.
>=20
> Now I'm wondering if this would also be possible with
> a rdma connection (struct rdma_cm_i ).
>=20

RDMA / verbs ressources are tied to a process (especially Memory
Registration), but it's ending up in the HCA, which is probably unaware
of processes.

Additionally, an RDMA_CM connection is not identified by a FD, so this
kind of Unix trick (FD passing through Unix socket: SCM_RIGHTS) is not
going to work.

=46orking might already be a challenge for a RDMA/verbs application, so=
 I
don't think that sharing/moving an RDMA_CM connection across different
processes is supported.

But other people on this list (especially Roland Dreier and Sean Hefty)
could find a solution.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
