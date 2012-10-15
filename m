From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Is there a way to transfer a rdma connection between userspace processes?
Date: Mon, 15 Oct 2012 10:27:26 +0200
Message-ID: <507BC8EE.2020908@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigABE952DF581249BFCDA36413"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigABE952DF581249BFCDA36413
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm currently researching how to implement SMBDirect [MS-SMBD]
together with the multi channel feature of SMB 3.0 in Samba.

As Samba currently uses one process per tcp connection
and maintains a lot of in memory state within the process
(e.g. for the SMB_VFS modules) it would require a lot of work
to change Samba to coordinate two (or more) processes for one logical
multi channel connection.

My current plan tries to pass the socket fd of new connections
(which join an existing multi channel session) via fd-passing to
the existing process.

Now I'm wondering if this would also be possible with
a rdma connection (struct rdma_cm_i ).

=46rom reading the code of rdma_create_event_channel()/rdma_create_id()
and rdma_migrate_id(), it seems that the connection state is in
partly in userspace (structures) and partly in the kernel space
(hidden behind the channel fd)

ibv_create_comp_channel() and ibv_create_cq() seem to have a similar desi=
gn.

As the ibverbs interface typically has a userspace driver I'm wondering i=
f
it's always true that there's also some kernel state maintained via the
rdma/ibv_comp event channels?

As far as I can see there's currently no way to transfer the rdma/ibv
state to
another process (for me it's enough to transfer it, using it from both
processes
is not strictly needed).

Is anybody working on this already?

metze


--------------enigABE952DF581249BFCDA36413
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlB7yPQACgkQm70gjA5TCD/28QCfWGf6myR3WOJZ0KTJWfL06MTA
TB0AmwRYh+jrCEph19grxI91NT+vG4WC
=YWEw
-----END PGP SIGNATURE-----

--------------enigABE952DF581249BFCDA36413--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
