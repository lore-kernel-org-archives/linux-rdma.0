From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Tue, 14 Nov 2017 10:51:43 +0200
Message-ID: <20171114085143.GS18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uY6A4WM8GrQcEArj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uY6A4WM8GrQcEArj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The commit 25f07300bfb7 ("vmw_pvrdma: Add SRQ support") causes to build
failures in Travis CI [1] and on my system too [2].

Please fix.

Thanks

[1] https://travis-ci.org/linux-rdma/rdma-core/builds/301651144
[2]

-- Missing Optional Items:
--  Valgrind memcheck.h NOT enabled
--  Valgrind drd.h NOT enabled
-- Configuring done
-- Generating done
-- Build files have been written to: /home/leonro/src/rdma-core/build
[1/81] Linking C shared module lib/libhfi1verbs-rdmav16.so
[2/81] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16=
=2Edir/pvrdma_main.c.o
FAILED: providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pvrdma_main.=
c.o
/usr/lib/ccache/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude -I/usr/includ=
e/libnl3 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-pr=
ototypes -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstr=
ict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC   -st=
d=3Dgnu11 -MD -MT providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pv=
rdma_main.c.o -MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pv=
rdma_main.c.o.d -o providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/p=
vrdma_main.c.o   -c ../providers/vmw_pvrdma/pvrdma_main.c
In file included from ../providers/vmw_pvrdma/pvrdma_main.c:46:0:
=2E./providers/vmw_pvrdma/pvrdma.h: In function =E2=80=98pvrdma_write_uar_s=
rq=E2=80=99:
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: error: =E2=80=98PVRDMA_UAR_SRQ_O=
FFSET=E2=80=99 undeclared (first use in this function); did you mean =E2=80=
=98PVRDMA_UAR_CQ_OFFSET=E2=80=99?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) =3D htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared identifier=
 is reported only once for each function it appears in
[3/81] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16=
=2Edir/qp.c.o
FAILED: providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/qp.c.o
/usr/lib/ccache/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude -I/usr/includ=
e/libnl3 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-pr=
ototypes -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstr=
ict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC   -st=
d=3Dgnu11 -MD -MT providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/qp=
=2Ec.o -MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/qp.c.o.d =
-o providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/qp.c.o   -c ../pr=
oviders/vmw_pvrdma/qp.c
In file included from ../providers/vmw_pvrdma/qp.c:48:0:
=2E./providers/vmw_pvrdma/pvrdma.h: In function =E2=80=98pvrdma_write_uar_s=
rq=E2=80=99:
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: error: =E2=80=98PVRDMA_UAR_SRQ_O=
FFSET=E2=80=99 undeclared (first use in this function); did you mean =E2=80=
=98PVRDMA_UAR_CQ_OFFSET=E2=80=99?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) =3D htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared identifier=
 is reported only once for each function it appears in
=2E./providers/vmw_pvrdma/qp.c: In function =E2=80=98pvrdma_create_srq=E2=
=80=99:
=2E./providers/vmw_pvrdma/qp.c:141:12: error: =E2=80=98struct pvrdma_create=
_srq=E2=80=99 has no member named =E2=80=98buf_size=E2=80=99; did you mean =
=E2=80=98buf_addr=E2=80=99?
  cmd.udata.buf_size =3D srq->buf.length;
            ^~~~~~~~
            buf_addr
=2E./providers/vmw_pvrdma/qp.c: In function =E2=80=98pvrdma_post_srq_recv=
=E2=80=99:
=2E./providers/vmw_pvrdma/qp.c:704:10: error: =E2=80=98PVRDMA_UAR_SRQ_RECV=
=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98PV=
RDMA_UAR_QP_RECV=E2=80=99?
          PVRDMA_UAR_SRQ_RECV | srq->srqn);
          ^~~~~~~~~~~~~~~~~~~
          PVRDMA_UAR_QP_RECV
[4/81] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16=
=2Edir/verbs.c.o
FAILED: providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/verbs.c.o
/usr/lib/ccache/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude -I/usr/includ=
e/libnl3 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-pr=
ototypes -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstr=
ict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC   -st=
d=3Dgnu11 -MD -MT providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/ve=
rbs.c.o -MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/verbs.c.=
o.d -o providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/verbs.c.o   -=
c ../providers/vmw_pvrdma/verbs.c
In file included from ../providers/vmw_pvrdma/verbs.c:47:0:
=2E./providers/vmw_pvrdma/pvrdma.h: In function =E2=80=98pvrdma_write_uar_s=
rq=E2=80=99:
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: error: =E2=80=98PVRDMA_UAR_SRQ_O=
FFSET=E2=80=99 undeclared (first use in this function); did you mean =E2=80=
=98PVRDMA_UAR_CQ_OFFSET=E2=80=99?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) =3D htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared identifier=
 is reported only once for each function it appears in
[5/81] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16=
=2Edir/cq.c.o
FAILED: providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o
/usr/lib/ccache/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude -I/usr/includ=
e/libnl3 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-pr=
ototypes -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstr=
ict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC   -st=
d=3Dgnu11 -MD -MT providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq=
=2Ec.o -MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o.d =
-o providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o   -c ../pr=
oviders/vmw_pvrdma/cq.c
In file included from ../providers/vmw_pvrdma/cq.c:48:0:
=2E./providers/vmw_pvrdma/pvrdma.h: In function =E2=80=98pvrdma_write_uar_s=
rq=E2=80=99:
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: error: =E2=80=98PVRDMA_UAR_SRQ_O=
FFSET=E2=80=99 undeclared (first use in this function); did you mean =E2=80=
=98PVRDMA_UAR_CQ_OFFSET=E2=80=99?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) =3D htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
=2E./providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared identifier=
 is reported only once for each function it appears in
[6/81] Building C object providers/ipathverbs/CMakeFiles/ipathverbs-rdmav16=
=2Edir/ipathverbs.c.o
[7/81] Building C object providers/ipathverbs/CMakeFiles/ipathverbs-rdmav16=
=2Edir/verbs.c.o
ninja: build stopped: subcommand failed.
Thanks

--uY6A4WM8GrQcEArj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKrp8ACgkQ5GN7iDZy
WKd0tw/8CM3hrkbxeNMD7VnkBU0CHpWp1XqCilPSXPl+f/Y2+VE20sOLTJ8zPE9V
iZ9Zh8qSoMB4ZUsbZymkzTxxf7KCQXiDEO7WVWLzALNxxOkqvGqS3dOkeen3d98z
Gsgl5DtjuaYRDkE+Vi82xhscotHA6tIxy5bmDecURnOd0pwXjojq9Sy8TmqnuGSy
yGNZz+z4nDPLeroPe0thjaXja+5m+pjegBb/DKF40AnAaFYdyzTQ+1peAwtk814S
A0ZZ9GqclvDaNafeVk/g0SocL3gSZEl8jmarKj8ZrBv2w083B7doK0LUiM32CYlf
0lSfMlXZBSatDTlQnJaONmPj6yLsrozEfIMhFwyGemkliRjj63HD+xcYFibmcWL+
fwFHL16ENiq6f7LHruYDAPcQCI3PZ01q4OXFMtAZJJca9ifGFF/uyfKc6/C6uihR
/+SWN5p17dAvRx6c65ocvDHbxj6PVaadCzuDDhOeYucyMe8iPngC+oEVeeXCEGPi
vgrozoAucPzVtjhX4+yWLvogE/+/HTjM5rnqW6F754PiUrzENTDTwhNXfL7HEMXs
a3jeXWD50TxZb9zxEdDxECkJnp8W71DKWtARLhAE4BfZHvYglRFtRgNp3xKSzOn2
X135nBiOHU0xJO807EevAHNU7e9ipQ8laOP0QhXJbPKLw0T/5po=
=MMLQ
-----END PGP SIGNATURE-----

--uY6A4WM8GrQcEArj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
