From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Is there a way to transfer a rdma connection between userspace
 processes?
Date: Tue, 16 Oct 2012 18:46:34 +0200
Message-ID: <507D8F6A.5090008@samba.org>
References: <507BC8EE.2020908@samba.org> <1350292042.2750.11.camel@dworkin.quest-ce.net> <507C2C6E.7010507@opengridcomputing.com> <507D6E3C.2050405@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig738AA4DCAF6AE0006A08D9F8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507D6E3C.2050405-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig738AA4DCAF6AE0006A08D9F8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 16.10.2012 16:25, schrieb Stefan (metze) Metzmacher:
> @Yann and Steve: thanks for the feedback!
>=20
>>>> I'm currently researching how to implement SMBDirect [MS-SMBD]
>>>> together with the multi channel feature of SMB 3.0 in Samba.
>>>>
>>>> As Samba currently uses one process per tcp connection
>>>> and maintains a lot of in memory state within the process
>>>> (e.g. for the SMB_VFS modules) it would require a lot of work
>>>> to change Samba to coordinate two (or more) processes for one logica=
l
>>>> multi channel connection.
>>>>
>>>> My current plan tries to pass the socket fd of new connections
>>>> (which join an existing multi channel session) via fd-passing to
>>>> the existing process.
>>>>
>>>> Now I'm wondering if this would also be possible with
>>>> a rdma connection (struct rdma_cm_i ).
>>>>
>>> RDMA / verbs ressources are tied to a process (especially Memory
>>> Registration), but it's ending up in the HCA, which is probably unawa=
re
>>> of processes.
>>>
>>> Additionally, an RDMA_CM connection is not identified by a FD, so thi=
s
>>> kind of Unix trick (FD passing through Unix socket: SCM_RIGHTS) is no=
t
>>> going to work.
>>>
>>> Forking might already be a challenge for a RDMA/verbs application, so=
 I
>>> don't think that sharing/moving an RDMA_CM connection across differen=
t
>>> processes is supported.
>>>
>>> But other people on this list (especially Roland Dreier and Sean Heft=
y)
>>> could find a solution.
>>>
>>> Regards.
>>>
>>
>> fork() support like you need is not there in Linux RDMA verbs. Another=

>> alternative is to fork() before you setup the RDMA connection.  IE if =
a
>> regular TCP socket is first used to negotiate RDMA mode, then maybe yo=
u
>> could fork() after negotiation but before setting up the RDMA connecti=
on
>> and other resources?
>=20
> For client connections that would work, but it can't work for a server
> that uses fork() after listen().
>=20
> Would it be possible to extend the librdmacm and libibverbs to:
> - handle fork() after getting RDMA_CM_EVENT_CONNECT_REQUEST
>   which means there have to be some functions to destroy contexts like
>   struct rdma_cm_id, but without affecting the real connection.
>   Similar to close() on an FD that is used shared between two processes=
=2E
> - export/import an interprocess token attached to the hierarchy of obje=
cts
>   similar to gss_export_sec_context/gss_import_sec_context.
>   Or a function which exports the contexts into a FD (of a pipe),
>   which could also transfer open FDs to the other end.
>   Maybe this could pass the information through a rdma/ibverb event cha=
nnel?

It would be ok if there's a limitation, which means that the transfer to
a different process is only possible if there're:
- no posted work requests
- no queue pairs
- completion queues
active on the connection.

metze


--------------enig738AA4DCAF6AE0006A08D9F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlB9j24ACgkQm70gjA5TCD8+VgCfTqp8SHRuVLX2a5qOvE/p7LMK
j8kAn3qoWq/blZjXDprJg1bDG5LNXZrH
=2+rx
-----END PGP SIGNATURE-----

--------------enig738AA4DCAF6AE0006A08D9F8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
