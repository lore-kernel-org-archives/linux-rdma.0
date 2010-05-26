From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the final tree
Date: Wed, 26 May 2010 15:15:34 +1000
Message-ID: <20100526151534.504a74f7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

drivers/infiniband/hw/qib/qib_fs.c: In function 'portcntrs_2_read':
drivers/infiniband/hw/qib/qib_fs.c:203: warning: 'counters' is used uniniti=
alized in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'portcntrs_1_read':
drivers/infiniband/hw/qib/qib_fs.c:192: warning: 'counters' is used uniniti=
alized in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'portnames_read':
drivers/infiniband/hw/qib/qib_fs.c:181: warning: 'names' is used uninitiali=
zed in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'dev_names_read':
drivers/infiniband/hw/qib/qib_fs.c:160: warning: 'names' is used uninitiali=
zed in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'dev_counters_read':
drivers/infiniband/hw/qib/qib_fs.c:149: warning: 'counters' is used uniniti=
alized in this function

Introduced by commit f931551bafe1f10ded7f5282e2aa162c267a2e5d ("IB/qib:
Add new qib driver for QLogic PCIe InfiniBand adapters").

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8rnYACgkQjjKRsyhoI8xEdgCfeIwhGUzl5BV3TyaZfgOUD2yv
REAAn14Xe95eJdOImF5og0gXNw/Fg/wz
=jf2m
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
