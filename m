From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/2] infiniband-diags/rdma-ndd: Fix install/start up script
Date: Mon, 16 Mar 2015 18:05:51 -0400
Message-ID: <1426543551-12524-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

=46ix the following issues reported by Dan:

1. I found an issue  with the /etc/init.d/rdma-ndd script. The =E2=80=9C=
stop=E2=80=9D option
   (e.g. /etc/init.d/rdma-ndd stop) doesn=E2=80=99t kill the rdma-ndd. =
 The problem is
   that the rdma-ndd doesn=E2=80=99t creates pidfile.  Just like opensm=
 the rdma-ndd
   should create/remove pidfile in /var/run/rdma-ndd.pid The pidfile is=
 being
   used by =E2=80=9Ckillproc=E2=80=9D that is being called from stop() =
function in .
   /etc/init.d/rdma-ndd script.  So, I think that just like opensm the =
rdma-ndd
   should have an option for =E2=80=9C--pidfile=E2=80=9D

2.  Regardless, the /etc/init.d/rdma-ndd script is missing the followin=
g lines
    (please see this git diff):

diff --git a/etc/rdma-ndd.init.in b/etc/rdma-ndd.init.in
index 41747f2..3605f5a 100644
--- a/etc/rdma-ndd.init.in
+++ b/etc/rdma-ndd.init.in
@@ -40,7 +40,8 @@
# Redistributions in binary form must reproduce both the
# above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.
-
+prefix=3D@prefix@
+exec_prefix=3D@exec_prefix@
pidfile=3D/var/run/rdma-ndd.pid



This fix will direct the path for sbindir to be /usr/sbin/ (as sbindir =
 by
default will be (from configure  --help) =E2=80=9C--sbindir=3DDIR      =
     system admin
executables [EPREFIX/sbin]=E2=80=9D) and the rdma-ndd to be taken from
/usr/sbin/rdma-ndd.  When I checked it in Debian OS  the /etc/init.d/rd=
ma-ndd
script tried to find the rdma-ndd in /sbin/rdma-ndd and gave me an erro=
r. So
this fix this problem.

Dan Ben Yosef

Ira Weiny (2):
  infiniband-diags/rdma-ndd: Fix issues with install
  infiniband-diags/rdma-ndd: add --pidfile option

 Makefile.am               |  3 +++
 doc/man/rdma-ndd.8.in     |  3 +++
 doc/rst/rdma-ndd.8.in.rst |  3 +++
 etc/rdma-ndd.init.in      |  6 ++++--
 src/rdma-ndd.c            | 35 +++++++++++++++++++++++++++++++++--
 5 files changed, 46 insertions(+), 4 deletions(-)

--=20
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
