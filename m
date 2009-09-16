From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] 'ibcheckportwidth' : Exit if LWS is 1X
Date: Wed, 16 Sep 2009 09:12:14 +0530
Message-ID: <829ded920909152042y227a709u6e74ee05d6ff05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46ix: Modify ibcheckportwidth to exit if LWS is 1X instead of processi=
ng
next lines.
Trivial: ibcheckportwidth man page cosmetic change

Signed-off-by: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
infiniband-diags/man/ibcheckportwidth.8 =A0 =A0 =A0| =A0 =A02 +-
infiniband-diags/scripts/ibcheckportwidth.in | =A0 =A02 +-

diff --git a/infiniband-diags/man/ibcheckportwidth.8
b/infiniband-diags/man/ibcheckportwidth.8
index 85c06fc..c368467 100644
--- a/infiniband-diags/man/ibcheckportwidth.8
+++ b/infiniband-diags/man/ibcheckportwidth.8
@@ -4,7 +4,7 @@
=A0ibcheckportwidth \- validate IB port for 1x link width

=A0.SH SYNOPSIS
-.B ibcheckport
+.B ibcheckportwidth
=A0[\-h] [\-v] [\-N | \-nocolor] [\-G] [\-C ca_name] [\-P ca_port]
=A0[\-t(imeout) timeout_ms] =A0<lid|guid> <port>

diff --git a/infiniband-diags/scripts/ibcheckportwidth.in
b/infiniband-diags/scripts/ibcheckportwidth.in
index 32c5c5e..60a0892 100644
--- a/infiniband-diags/scripts/ibcheckportwidth.in
+++ b/infiniband-diags/scripts/ibcheckportwidth.in
@@ -103,7 +103,7 @@ function blue(s)
=A0}

=A0# Only check LinkWidthActive if LinkWidthSupported is not 1X
-/^LinkWidthSupported/{ if ($2 !=3D "1X") { next } }
+/^LinkWidthSupported/{ if ($2 =3D=3D "1X") { exit } }
--
1.6.4.2

--
Keshetti Mahesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
