From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] libibumad: adding support for Debian packaging.
Date: Thu, 21 Feb 2013 09:51:09 +0200
Message-ID: <1361433069-8496-1-git-send-email-ilyan@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                     |   10 +-
 debian/changelog                | 1144 +++++++++++++++++++++++++++++++++++++++
 debian/compat                   |    1 +
 debian/control                  |   28 +
 debian/dirs                     |    2 +
 debian/libibumad-devel.dirs     |    2 +
 debian/libibumad-devel.install  |    2 +
 debian/libibumad-static.dirs    |    1 +
 debian/libibumad-static.install |    1 +
 debian/libibumad.copyright      |  376 +++++++++++++
 debian/libibumad.dirs           |    2 +
 debian/libibumad.docs           |    3 +
 debian/libibumad.install        |    2 +
 debian/rules                    |   13 +
 debian/source/format            |    1 +
 gen_chlog.sh                    |   52 ++-
 16 files changed, 1633 insertions(+), 7 deletions(-)
 create mode 100644 debian/changelog
 create mode 100644 debian/compat
 create mode 100644 debian/control
 create mode 100644 debian/dirs
 create mode 100644 debian/libibumad-devel.dirs
 create mode 100644 debian/libibumad-devel.install
 create mode 100644 debian/libibumad-static.dirs
 create mode 100644 debian/libibumad-static.install
 create mode 100644 debian/libibumad.copyright
 create mode 100644 debian/libibumad.dirs
 create mode 100644 debian/libibumad.docs
 create mode 100644 debian/libibumad.install
 create mode 100755 debian/rules
 create mode 100644 debian/source/format

diff --git a/Makefile.am b/Makefile.am
index 604f57a..12c9928 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -39,11 +39,19 @@ libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h
 EXTRA_DIST = $(srcdir)/include/infiniband/umad.h \
 	libibumad.spec.in libibumad.spec \
 	$(srcdir)/src/libibumad.map libibumad.ver \
-	$(man_MANS) autogen.sh
+	$(man_MANS) autogen.sh \
+	debian/changelog debian/libibumad.copyright \
+        debian/rules debian/compat \
+	debian/control debian/dirs \
+	debian/libibumad.docs debian/source/format \
+	debian/libibumad.dirs debian/libibumad.install \
+	debian/libibumad-devel.dirs debian/libibumad-devel.install \
+	debian/libibumad-static.dirs debian/libibumad-static.install
 
 dist-hook:
 	if [ -x $(top_srcdir)/gen_chlog.sh ] ; then \
 		$(top_srcdir)/gen_chlog.sh > $(distdir)/ChangeLog ; \
+		$(top_srcdir)/gen_chlog.sh --debian > $(distdir)/debian/changeLog ; \
 	fi
 
 install-data-hook:
diff --git a/debian/changelog b/debian/changelog
new file mode 100644
index 0000000..d61cb7e
--- /dev/null
+++ b/debian/changelog
@@ -0,0 +1,1144 @@
+libibumad (1.3.8.MLNX20130220.2e3f10f) unstable; urgency=low
+
+  * libibumad: adding support for Debian packaging.
+
+ --  Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  Wed, 20 Feb 2013 16:35:05 +0200
+
+libibumad (1.3.8.MLNX20121203.1e70ca0) unstable; urgency=low
+
+  * libibumad: fix umad_register man page
+
+ --  Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>  Mon, 3 Dec 2012 16:05:45 -0800
+libibumad (1.3.7.MLNX20120802.aeac802) unstable; urgency=low
+
+  * management: packages versions update
+
+ --  Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  Thu, 2 Aug 2012 10:19:37 +0300
+
+libibumad (1.3.7.MLNX20120802.982f211) unstable; urgency=low
+
+  * libibumad: update shared library versions
+
+ --  Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  Thu, 2 Aug 2012 10:16:59 +0300
+
+libibumad (1.3.7.MLNX20120707.73639fa) unstable; urgency=low
+
+  * libibumad: update umad_recv man page.
+
+ --  Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>  Sat, 7 Jul 2012 14:42:25 -0700
+
+libibumad (1.3.7.MLNX20110706.b6a4397) unstable; urgency=low
+
+  * libibumad: Remove OpenSM reference from COPYING file
+
+ --  Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>  Wed, 6 Jul 2011 14:39:18 -0700
+libibumad (1.3.6.MLNX20110214.4463772) unstable; urgency=low
+
+  * libibumad: package version update
+
+ --  Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 14 Feb 2011 12:26:37 +0200
+
+libibumad (1.3.6.MLNX20110214.49ca7c7) unstable; urgency=low
+
+  * libibumad: update shared library versions
+
+ --  Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 14 Feb 2011 12:26:13 +0200
+
+libibumad (1.3.6.MLNX20110211.fe09a96) unstable; urgency=low
+
+  * FW: [PATCH] umad_send.3 (man page)
+
+ --  Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>  Fri, 11 Feb 2011 15:19:47 -0600
+
+libibumad (1.3.6.MLNX20110203.b6742fb) unstable; urgency=low
+
+  * Makefile: ChangeLog generation script path fix
+
+ --  Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 3 Feb 2011 17:22:44 +0200
+
+libibumad (1.3.6.MLNX20101004.f889bba) unstable; urgency=low
+
+  * umad.{c,h}: moving stdlib.h include from C to H file
+
+ --  Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Mon, 4 Oct 2010 12:37:11 +0200
+
+libibumad (1.3.6.MLNX20101007.24afddb) unstable; urgency=low
+
+  * Fix autotools to include the necessary M4 files
+
+ --  Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Thu, 7 Oct 2010 16:33:01 -0600
+libibumad (1.3.5.MLNX20100904.88dc948) unstable; urgency=low
+
+  * management: packages versions update
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 4 Sep 2010 14:15:33 +0300
+
+libibumad (1.3.5.MLNX20100904.3a0028b) unstable; urgency=low
+
+  * management: update shared library versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 4 Sep 2010 14:13:06 +0300
+
+libibumad (1.3.5.MLNX20100810.ecd4991) unstable; urgency=low
+
+  * libibumad: Increase the limit of UMAD_MAX_DEVICES
+
+ --  Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>  Tue, 10 Aug 2010 16:30:30 -0700
+libibumad (1.3.4.MLNX20100522.9816b2d) unstable; urgency=low
+
+  * management: packages versions update
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 22 May 2010 18:00:16 +0300
+
+libibumad (1.3.4.MLNX20100522.4163c21) unstable; urgency=low
+
+  * management: update shared library versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 22 May 2010 17:52:50 +0300
+
+libibumad (1.3.4.MLNX20100309.278e4d1) unstable; urgency=low
+
+  * libibumad: added link_layer for RoCEE support and updated umad version
+
+ --  Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Tue, 9 Mar 2010 12:39:40 +0200
+libibumad (1.3.3.MLNX20091213.f958f06) unstable; urgency=low
+
+  * management: package versions bump
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 13 Dec 2009 19:39:11 +0200
+
+libibumad (1.3.3.MLNX20091213.0f628f4) unstable; urgency=low
+
+  * management: update library versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 13 Dec 2009 19:36:19 +0200
+
+libibumad (1.3.3.MLNX20091117.de43062) unstable; urgency=low
+
+  * libibmad: libibumad: Print warnings and errors to stderr not stdout
+
+ --  Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>  Tue, 17 Nov 2009 14:39:37 -0800
+libibumad (1.3.2.MLNX20091101.1c35b6b) unstable; urgency=low
+
+  * management: bump package versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 1 Nov 2009 21:55:47 +0200
+
+libibumad (1.3.2.MLNX20091101.2350f9c) unstable; urgency=low
+
+  * management: update libraries version information
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 1 Nov 2009 21:42:56 +0200
+
+libibumad (1.3.2.MLNX20091102.34b55d8) unstable; urgency=low
+
+  * management: update/add Voltaire copyright
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 2 Nov 2009 02:09:14 +0200
+
+libibumad (1.3.2.MLNX20090826.0b2caf8) unstable; urgency=low
+
+  * Duplicated file man/umad_get_mad.3 in libibumad/Makefile.am
+
+ --  Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>  Wed, 26 Aug 2009 14:03:04 +0200
+
+libibumad (1.3.2.MLNX20090815.3f18c3d) unstable; urgency=low
+
+  * libibumad: indentation fixes
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 15 Aug 2009 21:11:36 +0300
+
+libibumad (1.3.2.MLNX20090501.1147490) unstable; urgency=low
+
+  * libibumad: keep port capmask as 32-bit variable
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 1 May 2009 22:30:38 +0300
+
+libibumad (1.3.2.MLNX20090427.264c2cd) unstable; urgency=low
+
+  * management: Fixed custom_release in SPEC files
+
+ --  Nicolas Morey-Chaisemartin <nicolas.morey-chaisemartin-Z51IpKcfGtLk1uMJSBkQmQ@public.gmane.org>  Mon, 27 Apr 2009 12:59:05 +0200
+libibumad (1.3.1.MLNX20090426.310beca) unstable; urgency=low
+
+  * management: bump package versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 26 Apr 2009 17:05:13 +0300
+
+libibumad (1.3.1.MLNX20090302.b6c197c) unstable; urgency=low
+
+  * libibumad/umad.c: Cosmetic changes
+
+ --  Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>  Mon, 2 Mar 2009 16:00:29 -0500
+libibumad (1.3.0.MLNX20090228.a290800) unstable; urgency=low
+
+  * management: bump all package versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 28 Feb 2009 18:50:54 +0200
+
+libibumad (1.3.0.MLNX20090205.1721e22) unstable; urgency=low
+
+  * libibumad/umad.c: Change lid print format to unsigned
+
+ --  Hal Rosenstock <halr-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Thu, 5 Feb 2009 16:43:34 -0700
+
+libibumad (1.3.0.MLNX20090202.8886e06) unstable; urgency=low
+
+  * libibumad: get_ca() can call release_ca() with uninitialized data
+
+ --  Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>  Mon, 2 Feb 2009 11:53:01 -0800
+
+libibumad (1.3.0.MLNX20081222.a617ec5) unstable; urgency=low
+
+  * management: move sysfs()_* function to libibumad
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 22 Dec 2008 00:24:30 +0200
+libibumad (1.2.3.MLNX20081213.bedc467) unstable; urgency=low
+
+  * management: bump all package versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 13 Dec 2008 19:46:15 +0200
+libibumad (1.2.2.MLNX20081118.688cfb8) unstable; urgency=low
+
+  * management: update versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 18 Nov 2008 06:20:46 +0200
+
+libibumad (1.2.2.MLNX20081116.efebda8) unstable; urgency=low
+
+  * libibumad: Add UMAD_MAX_DEVICES define
+
+ --  Hal Rosenstock <halr-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Sun, 16 Nov 2008 11:37:28 -0700
+libibumad (1.2.1.MLNX20081019.dd9e992) unstable; urgency=low
+
+  * management/*/configure.in: bump all versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 19 Oct 2008 20:53:23 +0200
+
+libibumad (1.2.1.MLNX20080723.4474288) unstable; urgency=low
+
+  * libibumad: check that node type has IB type
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 23 Jul 2008 04:32:41 +0300
+
+libibumad (1.2.1.MLNX20081008.162f6b9) unstable; urgency=low
+
+  * management: update Voltaire copyright
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 8 Oct 2008 12:28:44 +0200
+
+libibumad (1.2.1.MLNX20081008.083019f) unstable; urgency=low
+
+  * management/*/COPYING: update Voltaire copyright years
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 8 Oct 2008 12:27:12 +0200
+
+libibumad (1.2.1.MLNX20080725.709b551) unstable; urgency=low
+
+  * libibumad/umad.c: Cosmetic change
+
+ --  Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  Fri, 25 Jul 2008 09:27:58 -0400
+libibumad (1.2.0.MLNX20080708.a967acd) unstable; urgency=low
+
+  * management: bump management versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 8 Jul 2008 07:22:02 +0300
+
+libibumad (1.2.0.MLNX20080706.f33ec00) unstable; urgency=low
+
+  * management: revert configure.in update configure.in on 'make dist'
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 6 Jul 2008 23:07:38 +0300
+
+libibumad (1.2.0.MLNX20080629.26e8369) unstable; urgency=low
+
+  * libibumad: fix snprintf() usage
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 29 Jun 2008 05:07:02 +0300
+
+libibumad (1.2.0.MLNX20080629.992f23d) unstable; urgency=low
+
+  * libibumad: improve snprintf() usage.
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 29 Jun 2008 05:05:48 +0300
+libibumad (1.2.0.MLNX20080403.39d8296) unstable; urgency=low
+
+  * management: bump all versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 3 Apr 2008 20:07:55 +0300
+
+libibumad (1.2.0.MLNX20080330.0f30839) unstable; urgency=low
+
+  * libibumad: eliminate compile warning
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 30 Mar 2008 17:57:29 +0300
+
+libibumad (1.2.0.MLNX20080211.1755f65) unstable; urgency=low
+
+  * management: bump versions in master branch
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 11 Feb 2008 20:17:54 +0200
+
+libibumad (1.2.0.MLNX20080127.6a7eb4c) unstable; urgency=low
+
+  * management: Update License: field in management spec files
+
+ --  Hal Rosenstock <hrosenstock-zzs+wwrJSf4AvxtiuMwx3w@public.gmane.org>  Sun, 27 Jan 2008 08:01:40 -0800
+
+libibumad (1.2.0.MLNX20080126.2b805e7) unstable; urgency=low
+
+  * management/libib*: remove trailing whitespaces
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 26 Jan 2008 22:37:43 +0200
+
+libibumad (1.2.0.MLNX20080115.adb65f3) unstable; urgency=low
+
+  * libibumad/man: umad_get_pkey man page
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 15 Jan 2008 19:01:53 +0000
+
+libibumad (1.2.0.MLNX20080115.ae345ba) unstable; urgency=low
+
+  * libibumad: increase the version of the library
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 15 Jan 2008 18:26:18 +0000
+
+libibumad (1.2.0.MLNX20080113.0c82a63) unstable; urgency=low
+
+  * libibumad: umad_get_pkey() function
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 13 Jan 2008 19:22:29 +0000
+
+libibumad (1.2.0.MLNX20080107.cdbdd2f) unstable; urgency=low
+
+  * management/*/Makefile.am: update configure.in version on 'make dist'
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 7 Jan 2008 01:40:19 +0200
+
+libibumad (1.2.0.MLNX20080106.d6c34b1) unstable; urgency=low
+
+  * management/*/Makefile.am: fix ChangeLog generation rule
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 6 Jan 2008 21:33:44 +0200
+
+libibumad (1.2.0.MLNX20080103.47666f6) unstable; urgency=low
+
+  * management: bump versions
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 3 Jan 2008 09:44:46 +0200
+
+libibumad (1.2.0.MLNX20071201.ab6dedc) unstable; urgency=low
+
+  * libibumad: fix memory leak
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 1 Dec 2007 16:38:12 +0200
+
+libibumad (1.2.0.MLNX20071120.e598af0) unstable; urgency=low
+
+  * libibumad: version 1.1.5
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 20 Nov 2007 00:00:22 +0200
+
+libibumad (1.2.0.MLNX20071115.c7c1484) unstable; urgency=low
+
+  * libibumad: fix NULL pointer referencing
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 15 Nov 2007 10:22:00 +0200
+
+libibumad (1.2.0.MLNX20071106.8483034) unstable; urgency=low
+
+  * libibumad: version 1.1.4
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 6 Nov 2007 19:07:28 +0200
+
+libibumad (1.2.0.MLNX20071106.18c7c2a) unstable; urgency=low
+
+  * libibumad: bump library version
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 6 Nov 2007 19:02:15 +0200
+
+libibumad (1.2.0.MLNX20071101.fd2b309) unstable; urgency=low
+
+  * libibumad: store pkeys in umad_port structure
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 1 Nov 2007 10:40:23 +0200
+
+libibumad (1.2.0.MLNX20071015.828a144) unstable; urgency=low
+
+  * management: changed method_mask type in user_mad interface
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 15 Oct 2007 20:41:33 +0200
+
+libibumad (1.2.0.MLNX20071101.6eafb84) unstable; urgency=low
+
+  * libibumad: don't check errno when pkey enabling API ioctl() fails
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 1 Nov 2007 13:52:06 +0200
+
+libibumad (1.2.0.MLNX20071025.1d2440e) unstable; urgency=low
+
+  * libibumad: support for new pkey enabled user_mad API
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 25 Oct 2007 19:58:40 +0200
+
+libibumad (1.2.0.MLNX20071023.872c7f4) unstable; urgency=low
+
+  * libibumad/umad_poll.3: Fix man page return value description
+
+ --  Hal Rosenstock <hrosenstock-zzs+wwrJSf4AvxtiuMwx3w@public.gmane.org>  Tue, 23 Oct 2007 20:39:59 -0700
+
+libibumad (1.2.0.MLNX20071018.0f53805) unstable; urgency=low
+
+  * libibumad/man: umad_get_issm_path() man page
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 18 Oct 2007 17:12:44 +0200
+
+libibumad (1.2.0.MLNX20071018.b1384c6) unstable; urgency=low
+
+  * libibumad: umad_get_issm_path() addition
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 18 Oct 2007 16:01:52 +0200
+
+libibumad (1.2.0.MLNX20071015.0dac00b) unstable; urgency=low
+
+  * libibumad: remove opened umad devices internal tracking.
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 15 Oct 2007 17:00:36 +0200
+
+libibumad (1.2.0.MLNX20071015.824cae8) unstable; urgency=low
+
+  * libibumad/man: fix umad_open_port man page
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 15 Oct 2007 16:35:11 +0200
+
+libibumad (1.2.0.MLNX20071001.ae9c14c) unstable; urgency=low
+
+  * management/Makefile: remove obsolete .orig Makefile stuff
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 1 Oct 2007 22:01:37 +0200
+
+libibumad (1.2.0.MLNX20070920.9d134ad) unstable; urgency=low
+
+  * libibumad: update version
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 20 Sep 2007 19:38:40 +0200
+
+libibumad (1.2.0.MLNX20070920.27dd6de) unstable; urgency=low
+
+  * management/*/*.spec.in: change Source field to OFA paths
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 20 Sep 2007 18:04:12 +0200
+
+libibumad (1.2.0.MLNX20070919.330ee69) unstable; urgency=low
+
+  * management/*/configure: RELEASE and TARBALL for spec files
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 03:37:03 +0200
+
+libibumad (1.2.0.MLNX20070919.52d70de) unstable; urgency=low
+
+  * management/*/Makefile.am: generate ChangeLog files when distributed
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 03:42:52 +0200
+
+libibumad (1.2.0.MLNX20070919.b8c228f) unstable; urgency=low
+
+  * management/*/Makefile.am: clean dist-hook target
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 03:28:43 +0200
+
+libibumad (1.2.0.MLNX20070919.de22b30) unstable; urgency=low
+
+  * management/*/*.spec.in: don't run autogen.sh
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 02:00:08 +0200
+
+libibumad (1.2.0.MLNX20070919.e3723bd) unstable; urgency=low
+
+  * management/*/Makefile.am: fix include paths
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 12:39:44 +0200
+
+libibumad (1.2.0.MLNX20070919.9c5cd57) unstable; urgency=low
+
+  * management/*/Makefile.am: add autogen.sh script to 'make dist'
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 19 Sep 2007 02:05:57 +0200
+
+libibumad (1.2.0.MLNX20070917.38afcaa) unstable; urgency=low
+
+  * opensm and all: fix Source field in spec.in files.
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 17 Sep 2007 20:53:30 +0200
+
+libibumad (1.2.0.MLNX20070915.24398a8) unstable; urgency=low
+
+  * libibcommon|umad: remove AC_PROG_CXX config check
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 15 Sep 2007 16:09:07 +0300
+
+libibumad (1.2.0.MLNX20070907.0f2e6b3) unstable; urgency=low
+
+  * Fix umad_get_cas_names() usage in libibumad.
+
+ --  Arne Redlich <arne.redlich-w70geQzcnrhBDgjK7y7TUQ@public.gmane.org>  Fri, 7 Sep 2007 15:36:14 +0200
+
+libibumad (1.2.0.MLNX20070907.16c9292) unstable; urgency=low
+
+  * Fix potential buffer overflow in umad_get_cas_names()
+
+ --  Arne Redlich <arne.redlich-w70geQzcnrhBDgjK7y7TUQ@public.gmane.org>  Fri, 7 Sep 2007 15:36:12 +0200
+
+libibumad (1.2.0.MLNX20070906.5797229) unstable; urgency=low
+
+  * libibumad: Fix several issues that were reported by valgrind
+
+ --  Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Thu, 6 Sep 2007 15:05:03 +0300
+
+libibumad (1.2.0.MLNX20070904.82afdb9) unstable; urgency=low
+
+  * libibumad 2/2: add valgrind support to the umad code
+
+ --  Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Tue, 4 Sep 2007 10:35:42 +0300
+
+libibumad (1.2.0.MLNX20070904.f5e248e) unstable; urgency=low
+
+  * libibumad 1/2: add valgrind support to auto-tools configuration file
+
+ --  Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Tue, 4 Sep 2007 10:34:22 +0300
+
+libibumad (1.2.0.MLNX20070710.16670d3) unstable; urgency=low
+
+  * libibumad: Updated to version 1.1.2
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 10 Jul 2007 17:08:52 -0400
+
+libibumad (1.2.0.MLNX20070710.8c2f8b5) unstable; urgency=low
+
+  * libibumad/(man/umad_set_pkey.3 Makefile.am): Clarify that umad_set_pkey takes pkey_index rather than pkey itself and add man page into libibumad installation
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 10 Jul 2007 09:25:52 -0400
+
+libibumad (1.2.0.MLNX20070710.82b4c96) unstable; urgency=low
+
+  * libibumad/ChangeLog: Add log entry for Sean's previous umad.h change to indicate umad_set_pkey takes pkey index rather than pkey
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 10 Jul 2007 09:21:13 -0400
+
+libibumad (1.2.0.MLNX20070710.d1502ae) unstable; urgency=low
+
+  * libibumad/include/infiniband/umad.h: Clarify that umad_set_pkey() takes a pkey index, and not the pkey itself.
+
+ --  Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>  Tue, 10 Jul 2007 09:19:28 -0400
+
+libibumad (1.2.0.MLNX20070626.2b27c9a) unstable; urgency=low
+
+  * libibumad/src/umad.c: Change uint to unsigned for strict ANSI
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 26 Jun 2007 16:56:06 -0400
+
+libibumad (1.2.0.MLNX20070626.5ef8726) unstable; urgency=low
+
+  * libibumad/include/infiniband/umad.h: Back out some changes (having to do with new user_mad ABI) which were unintentionally committed previously
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 26 Jun 2007 16:30:20 -0400
+
+libibumad (1.2.0.MLNX20070626.d10f07c) unstable; urgency=low
+
+  * management libraries/ChangeLog: Add log entry for MST change for replacing uint with unsigned for strict ANSI
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 26 Jun 2007 16:12:13 -0400
+
+libibumad (1.2.0.MLNX20070626.2e8f709) unstable; urgency=low
+
+  * management libs: uint -> unsigned replacement
+
+ --  Michael S. Tsirkin <mst-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Tue, 26 Jun 2007 16:06:46 -0400
+
+libibumad (1.2.0.MLNX20070531.f777e72) unstable; urgency=low
+
+  * management/*.spec: Remove *.spec files from management git repo as committed files. They are generated files.
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 31 May 2007 12:33:39 -0400
+
+libibumad (1.2.0.MLNX20070531.2755c17) unstable; urgency=low
+
+  * management/*.spec: Latest daily versions of .spec files (prior to removing these due to build changes)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 31 May 2007 11:41:16 -0400
+
+libibumad (1.2.0.MLNX20070524.1888a7f) unstable; urgency=low
+
+  * libibumad/man/umad_set_grh[_net].3: Some more changes based on comments from Dotan Barak
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 24 May 2007 09:41:12 -0400
+
+libibumad (1.2.0.MLNX20070524.0b39445) unstable; urgency=low
+
+  * libibumad/ChangeLog: Added log entries for recent changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 24 May 2007 09:20:12 -0400
+
+libibumad (1.2.0.MLNX20070523.4470f4a) unstable; urgency=low
+
+  * libibumad/libibumad.spec.in: Add man pages
+
+ --  Ira K. Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>  Wed, 23 May 2007 06:39:48 -0400
+
+libibumad (1.2.0.MLNX20070521.683268f) unstable; urgency=low
+
+  * libibumad/man: Add "SEE ALSO" section to umad_set_grh[_net] and umad_set_addr[_net]
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 21 May 2007 14:35:18 -0400
+
+libibumad (1.2.0.MLNX20070521.c990243) unstable; urgency=low
+
+  * libibumad/man: More changes based on additional comments from Dotan Barak
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 21 May 2007 11:02:35 -0400
+
+libibumad (1.2.0.MLNX20070517.a7864b4) unstable; urgency=low
+
+  * libibumad: Man page updates based on comments from Dotan Barak
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 17 May 2007 10:42:23 -0400
+
+libibumad (1.2.0.MLNX20070514.cafab12) unstable; urgency=low
+
+  * spec summary changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 14 May 2007 13:31:05 -0400
+
+libibumad (1.2.0.MLNX20070511.802a21e) unstable; urgency=low
+
+  * configure.in: Update to correct list email address
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 11 May 2007 17:54:13 -0400
+
+libibumad (1.2.0.MLNX20070511.46fbf78) unstable; urgency=low
+
+  * libibumad: Updated to version 1.1.1
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 11 May 2007 13:22:31 -0400
+
+libibumad (1.2.0.MLNX20070511.dfb3c79) unstable; urgency=low
+
+  * libibumad/Makefile.am: Added additional libibumad man pages into build
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 11 May 2007 09:47:57 -0400
+
+libibumad (1.2.0.MLNX20070511.d9dc05f) unstable; urgency=low
+
+  * libibumad/man: Cosmetic changes for dates and fixed header
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 11 May 2007 09:43:16 -0400
+
+libibumad (1.2.0.MLNX20070511.a1b72b7) unstable; urgency=low
+
+  * libibumad/man: Initial version of libibumad man pages
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 11 May 2007 09:35:49 -0400
+
+libibumad (1.2.0.MLNX20070509.586db88) unstable; urgency=low
+
+  * libibumad/Makefile.am: Added existing libibumad man pages into Makefile
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 9 May 2007 16:17:23 -0400
+
+libibumad (1.2.0.MLNX20070509.30bae57) unstable; urgency=low
+
+  * libibumad/man: Updated existing libibumad man pages
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 9 May 2007 16:16:33 -0400
+
+libibumad (1.2.0.MLNX20070424.8698171) unstable; urgency=low
+
+  * libibumad/ChangeLog: Add entry for previous change to umad.c:umad_open_port to fix the declaration of the return value from dev_to_umad_id
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 24 Apr 2007 10:12:54 -0400
+
+libibumad (1.2.0.MLNX20070424.436f19f) unstable; urgency=low
+
+  * libibumad/umad.c: In umad_open_port, fix declaration of return value from dev_to_umad_id
+
+ --  Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>  Tue, 24 Apr 2007 10:11:19 -0400
+
+libibumad (1.2.0.MLNX20070424.78b3a0d) unstable; urgency=low
+
+  * libibumad/umad.c: In get_ca, remove no longer needed assignments
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 24 Apr 2007 09:52:33 -0400
+
+libibumad (1.2.0.MLNX20070424.9409d41) unstable; urgency=low
+
+  * libibumad/umad.c: /umad,c: In get_ca, handle drivers which do not support SYS_CA_HW_VERS or SYS_CA_TYPE
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 24 Apr 2007 09:41:04 -0400
+
+libibumad (1.2.0.MLNX20070412.a552c15) unstable; urgency=low
+
+  * Diags: Renamed openib-diags to infiniband-diags Also, some other changes based on this (openib-diags.spec.in moved to infiniband-diags.spec.in, openib-diags.spec moved to infiniband-diags.spec, and Makefile.am changed for this)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 12 Apr 2007 16:52:49 -0400
+
+libibumad (1.2.0.MLNX20070403.eb8cf62) unstable; urgency=low
+
+  * Version change in spec files
+
+ --  Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  Tue, 3 Apr 2007 16:47:44 -0400
+
+libibumad (1.2.0.MLNX20070403.290417f) unstable; urgency=low
+
+  * More mailing list updates
+
+ --  Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  Tue, 3 Apr 2007 15:12:07 -0400
+
+libibumad (1.2.0.MLNX20070403.097baf8) unstable; urgency=low
+
+  * Automatic check-in of target spec files after version processing
+
+ --  Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  Tue, 3 Apr 2007 13:47:15 -0400
+
+libibumad (1.2.0.MLNX20070402.7adf254) unstable; urgency=low
+
+  * Update all the various spec files Make spec files work with new make.dist script Add make dist script to ease the process of releasing tarballs
+
+ --  Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  Mon, 2 Apr 2007 18:43:08 -0400
+
+libibumad (1.2.0.MLNX20070329.96c1969) unstable; urgency=low
+
+  * libibumad: Updated to version 1.1.0
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 29 Mar 2007 09:20:19 -0500
+
+libibumad (1.2.0.MLNX20070324.9b56334) unstable; urgency=low
+
+  * libibumad/umad.c: Cosmetic formatting change
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 24 Mar 2007 11:59:05 -0500
+
+libibumad (1.2.0.MLNX20070323.b635125) unstable; urgency=low
+
+  * libibumad/umad.c: Implement GRH support in umad_set_grh
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 23 Mar 2007 09:11:44 -0500
+
+libibumad (1.2.0.MLNX20070323.37598fa) unstable; urgency=low
+
+  * libibumad/umad.(h c): Cosmetic changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 23 Mar 2007 09:04:54 -0500
+
+libibumad (1.2.0.MLNX20070312.4a9d682) unstable; urgency=low
+
+  * libibumad/man: Updates to initial man pages from Dotan based on changes Roland made to libibverbs man pages
+
+ --  Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Mon, 12 Mar 2007 20:49:39 -0500
+
+libibumad (1.2.0.MLNX20070312.e7b46dc) unstable; urgency=low
+
+  * libibumad/ChangeLog: Add log entry for change to umad.c:umad_get_ca_portguids to add release_ca call in error flow to prevent resource leak
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 12 Mar 2007 11:10:40 -0500
+
+libibumad (1.2.0.MLNX20070312.2600ff3) unstable; urgency=low
+
+  * libibumad/src/umad.c: In umad_get_ca_portguids, add release_ca call in error flow to prevent resource leak
+
+ --  Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Mon, 12 Mar 2007 11:07:47 -0500
+
+libibumad (1.2.0.MLNX20070214.9446558) unstable; urgency=low
+
+  * libibumad/man: Add initial libibumad man pages
+
+ --  Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  Wed, 14 Feb 2007 10:37:10 -0500
+
+libibumad (1.2.0.MLNX20070129.f335e3d) unstable; urgency=low
+
+  * management/libibumad: Release 1.0.2
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 29 Jan 2007 10:04:58 -0500
+
+libibumad (1.2.0.MLNX20070124.be676e0) unstable; urgency=low
+
+  * libibumad/libibumad.spec.in: Add doc files
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 24 Jan 2007 09:33:15 -0500
+
+libibumad (1.2.0.MLNX20070124.0d649bc) unstable; urgency=low
+
+  * Management libraries: Added AUTHORS and COPYING to libibcommon, libibumad, and libibmad
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 24 Jan 2007 09:19:30 -0500
+
+libibumad (1.2.0.MLNX20061204.6919b97) unstable; urgency=low
+
+  * Remove unneeded $Id$ from the rest of management
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 4 Dec 2006 11:55:20 -0500
+
+libibumad (1.2.0.MLNX20061120.dea8230) unstable; urgency=low
+
+  * r10124: libibumad/libibmad/diags: fix printf style uses
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 20 Nov 2006 12:07:25 +0000
+
+libibumad (1.2.0.MLNX20061102.5aa3469) unstable; urgency=low
+
+  * r10050: management/libib*: Strip trailing whitespace
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 2 Nov 2006 22:26:03 +0000
+
+libibumad (1.2.0.MLNX20061031.27976aa) unstable; urgency=low
+
+  * r10010: libibumad/umad.c: In mad_set_addr_net, fix endian used in TRACE macro
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 31 Oct 2006 11:19:56 +0000
+
+libibumad (1.2.0.MLNX20061020.6f10e64) unstable; urgency=low
+
+  * r9932: libibumad/configure.in: Update version (for previous change)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 20 Oct 2006 12:44:05 +0000
+
+libibumad (1.2.0.MLNX20061020.d8d9932) unstable; urgency=low
+
+  * r9931: libibumad: Add change log
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 20 Oct 2006 12:43:24 +0000
+
+libibumad (1.2.0.MLNX20061016.5b643b9) unstable; urgency=low
+
+  * r9827: management libraries: Added library versioning support (similar to OpenSM and it's libraries)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 16 Oct 2006 13:49:19 +0000
+
+libibumad (1.2.0.MLNX20060928.91c2c4b) unstable; urgency=low
+
+  * r9663: libibumad/src/umad.c: In umad_open_port, show open()'s errno string
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 28 Sep 2006 18:00:56 +0000
+
+libibumad (1.2.0.MLNX20060830.a977576) unstable; urgency=low
+
+  * r9191: libibumad/src/umad.c: Fix some errnos and return codes
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 30 Aug 2006 16:03:01 +0000
+
+libibumad (1.2.0.MLNX20060809.0ad5b76) unstable; urgency=low
+
+  * r8856: libibumad/umad.c: nit on short mad read in umad_recv
+
+ --  Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Wed, 9 Aug 2006 19:58:48 +0000
+
+libibumad (1.2.0.MLNX20060503.0297877) unstable; urgency=low
+
+  * r6890: Fix core dump if umad_register() fails
+
+ --  Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>  Wed, 3 May 2006 20:07:39 +0000
+
+libibumad (1.2.0.MLNX20060407.351de32) unstable; urgency=low
+
+  * r6315: In libibumad, cosmetic change to TRACE message
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 7 Apr 2006 17:17:25 +0000
+
+libibumad (1.2.0.MLNX20060308.c1d2965) unstable; urgency=low
+
+  * r5683: Merge management packaging changes from 1.0 back to trunk
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 8 Mar 2006 14:10:56 +0000
+
+libibumad (1.2.0.MLNX20060227.2340a3c) unstable; urgency=low
+
+  * r5508: Updated version identifiers for release candidate
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 27 Feb 2006 13:31:21 +0000
+
+libibumad (1.2.0.MLNX20060221.dc5b8a9) unstable; urgency=low
+
+  * r5451: In libibumad, fix some size_t issues related to memory allocation
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 21 Feb 2006 12:26:37 +0000
+
+libibumad (1.2.0.MLNX20060210.ca1cf64) unstable; urgency=low
+
+  * r5358: management/*/autogen.sh: config dir test and creation
+
+ --  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 10 Feb 2006 15:58:06 +0000
+
+libibumad (1.2.0.MLNX20060130.cbd69aa) unstable; urgency=low
+
+  * r5209: More cosmetic change from hca to ca
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 30 Jan 2006 15:08:38 +0000
+
+libibumad (1.2.0.MLNX20060111.2544451) unstable; urgency=low
+
+  * r4934: In libibumad/umad,c::resolve_ca_port, default algorithm is to prefer ports which are active, then those whose physical state is link up, and finally those ports whose physical state is not disabled.
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 11 Jan 2006 18:55:47 +0000
+
+libibumad (1.2.0.MLNX20060111.8d51568) unstable; urgency=low
+
+  * r4904: opensm fails to find HCA if port is down
+
+ --  Ralph Campbell <ralphc-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org>  Wed, 11 Jan 2006 00:01:56 +0000
+
+libibumad (1.2.0.MLNX20060110.8df6a59) unstable; urgency=low
+
+  * r4879: Fix bad free() in libibumad
+
+ --  Ralph Campbell <ralphc-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org>  Tue, 10 Jan 2006 11:52:00 +0000
+
+libibumad (1.2.0.MLNX20051216.6c3fb82) unstable; urgency=low
+
+  * r4507: In libibmad and libibumad, eliminate compile warnings with gcc version4.0.0 20050519 (Red Hat 4.0.0-8)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 16 Dec 2005 18:31:58 +0000
+
+libibumad (1.2.0.MLNX20051206.8d55619) unstable; urgency=low
+
+  * r4334: Move struct ib_user_mad into umad.h (from umad.c)i (libibumad) Save and restore ib_user_mad header in rpc.c::_do_madrpc (libibmad) so retries sent to proper DLID and DQPN
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 6 Dec 2005 21:03:52 +0000
+
+libibumad (1.2.0.MLNX20051206.b55cc0d) unstable; urgency=low
+
+  * r4333: Cosmetic changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 6 Dec 2005 20:59:09 +0000
+
+libibumad (1.2.0.MLNX20051204.5ef0364) unstable; urgency=low
+
+  * r4292: Fix previous checkin for make dist change for libibmad & libibumad
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 4 Dec 2005 23:10:08 +0000
+
+libibumad (1.2.0.MLNX20051204.5f47638) unstable; urgency=low
+
+  * r4291: fixed make dist for libibmad & libibumad
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 4 Dec 2005 23:04:47 +0000
+
+libibumad (1.2.0.MLNX20051014.d4bfdaf) unstable; urgency=low
+
+  * r3779: Fill in firmware version with null string for those drivers which do not support this. Not all IB devices have firmware so this should not be relied on.
+
+ --  Ralph Campbell <ralphc-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org>  Fri, 14 Oct 2005 11:39:12 +0000
+
+libibumad (1.2.0.MLNX20050926.35b8eb8) unstable; urgency=low
+
+  * r3540: Minor changes to diags and management libraries to eliminate possible naming conflicts warn becomes ibwarn, panic becomes ibpanic (also associated macros changed)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 26 Sep 2005 13:03:50 +0000
+
+libibumad (1.2.0.MLNX20050815.62277ec) unstable; urgency=low
+
+  * r3097: Remove a couple more instances of /usr/local/ib
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 15 Aug 2005 18:27:40 +0000
+
+libibumad (1.2.0.MLNX20050815.bf26ab0) unstable; urgency=low
+
+  * r3091: Remove special libdir to be in sync with OpenSM build change
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 15 Aug 2005 17:16:13 +0000
+
+libibumad (1.2.0.MLNX20050809.afe6e02) unstable; urgency=low
+
+  * r3036: Add option to skip infiniband library checks in libibumad.
+
+ --  Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Tue, 9 Aug 2005 13:54:08 +0000
+
+libibumad (1.2.0.MLNX20050808.d031bcc) unstable; urgency=low
+
+  * r3015: libibumad: dont assume that all headers are in the same directory.
+
+ --  Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Mon, 8 Aug 2005 13:53:49 +0000
+
+libibumad (1.2.0.MLNX20050802.c695196) unstable; urgency=low
+
+  * r2946: In umad_set_addr_net, fix format in debug message
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 2 Aug 2005 15:09:59 +0000
+
+libibumad (1.2.0.MLNX20050706.163b176) unstable; urgency=low
+
+  * r2815: Initial changes for receive side RMPP Also, some minor bug fixes and changed a couple of messages
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 6 Jul 2005 19:15:24 +0000
+
+libibumad (1.2.0.MLNX20050629.f0947ad) unstable; urgency=low
+
+  * r2748: Make length output as well as input parameter to umad_recv in order to get ready for receive side RMPP
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 29 Jun 2005 13:41:16 +0000
+
+libibumad (1.2.0.MLNX20050628.00661ea) unstable; urgency=low
+
+  * r2727: Add length parameter to umad_recv in preparation for receive side RMPP support
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 28 Jun 2005 15:28:47 +0000
+
+libibumad (1.2.0.MLNX20050627.43b2fc9) unstable; urgency=low
+
+  * r2720: Set errno in umad_recv and umad_send
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 27 Jun 2005 16:50:00 +0000
+
+libibumad (1.2.0.MLNX20050610.1726dde) unstable; urgency=low
+
+  * r2586: In osm_vendor_init, fix an initialization bug. Also, in umad_get_cas_names, only free namelist if scandir worked. Pointed out by Bernhard Fischer <rep.nop-Tswl7xcH0yE@public.gmane.org>
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 10 Jun 2005 21:27:19 +0000
+
+libibumad (1.2.0.MLNX20050607.eb965aa) unstable; urgency=low
+
+  * r2566: Add retries to umad_send ABI_VERSION is now 4
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 7 Jun 2005 11:21:44 +0000
+
+libibumad (1.2.0.MLNX20050602.46f12da) unstable; urgency=low
+
+  * r2528: Add umad_get_fd routine to libibumad
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 2 Jun 2005 18:49:59 +0000
+
+libibumad (1.2.0.MLNX20050601.d931e0a) unstable; urgency=low
+
+  * r2519: Made ports static Also, a formatting and commentary change
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 1 Jun 2005 20:35:25 +0000
+
+libibumad (1.2.0.MLNX20050524.8f74e5c) unstable; urgency=low
+
+  * r2466: Remove config.h.in files which should be generated but not part of tree
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 24 May 2005 12:59:47 +0000
+
+libibumad (1.2.0.MLNX20050523.656902f) unstable; urgency=low
+
+  * r2456: Changes to support send side RMPP (needs change to linux-kernel/infiniband/core/user_mad.c) ABI_VERSION is now 3 RMPP is enabled in build SA GetTable is now supported properly (within current RMPP limitations)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 23 May 2005 16:33:46 +0000
+
+libibumad (1.2.0.MLNX20050519.f41cef9) unstable; urgency=low
+
+  * r2413: Management libraries leak resources (memory, file/directory handles). Also a trailing whitespace fix in one place in libibcommon.
+
+ --  Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>  Thu, 19 May 2005 14:42:33 +0000
+
+libibumad (1.2.0.MLNX20050518.052c319) unstable; urgency=low
+
+  * r2398: Another change to use standard type
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 18 May 2005 21:27:37 +0000
+
+libibumad (1.2.0.MLNX20050518.16962c7) unstable; urgency=low
+
+  * r2393: Start converting to standard integer types
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 18 May 2005 19:54:08 +0000
+
+libibumad (1.2.0.MLNX20050518.c9d0cfe) unstable; urgency=low
+
+  * r2391: Converted C++ style comments to C Also, some formatting changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 18 May 2005 19:42:05 +0000
+
+libibumad (1.2.0.MLNX20050518.3590081) unstable; urgency=low
+
+  * r2389: Remove already included include
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 18 May 2005 19:30:13 +0000
+
+libibumad (1.2.0.MLNX20050329.2393a1b) unstable; urgency=low
+
+  * r2066: Enhance DEBUG output
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 29 Mar 2005 16:55:56 +0000
+
+libibumad (1.2.0.MLNX20050328.1994cfd) unstable; urgency=low
+
+  * r2053: change semantics of reveive timeout + cleanup
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 28 Mar 2005 09:00:13 +0000
+
+libibumad (1.2.0.MLNX20050322.b99dd16) unstable; urgency=low
+
+  * r2034: change umad_recv and mad_receive semantics - timeout 0 mean do not block
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 22 Mar 2005 17:12:42 +0000
+
+libibumad (1.2.0.MLNX20050316.87a7315) unstable; urgency=low
+
+  * r2006: add multi hca/port support
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Wed, 16 Mar 2005 17:57:39 +0000
+
+libibumad (1.2.0.MLNX20050220.2e0f10e) unstable; urgency=low
+
+  * r1843: Cosmetic changes
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 20 Feb 2005 15:55:52 +0000
+
+libibumad (1.2.0.MLNX20050220.77dd726) unstable; urgency=low
+
+  * r1841: debuggging
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sun, 20 Feb 2005 12:52:52 +0000
+
+libibumad (1.2.0.MLNX20050214.16858bd) unstable; urgency=low
+
+  * r1784: add oui registration
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Mon, 14 Feb 2005 17:43:42 +0000
+
+libibumad (1.2.0.MLNX20050210.08abe5f) unstable; urgency=low
+
+  * r1761: add umad & mad_addr dump functions
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 10 Feb 2005 11:43:35 +0000
+
+libibumad (1.2.0.MLNX20050203.e4ce8e4) unstable; urgency=low
+
+  * r1726: remove packet attr from ib_user_mad_t
+
+ --  Shahar Frank <shaharf-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 3 Feb 2005 17:13:05 +0000
+
+libibumad (1.2.0.MLNX20050129.3df6337) unstable; urgency=low
+
+  * r1699: Initial cutover to autotools for diags including update of README directions
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 29 Jan 2005 18:36:29 +0000
+
+libibumad (1.2.0.MLNX20050129.e53e44d) unstable; urgency=low
+
+  * r1698: Add IB header and library dependencies in for autotools
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Sat, 29 Jan 2005 18:01:07 +0000
+
+libibumad (1.2.0.MLNX20050128.b00a971) unstable; urgency=low
+
+  * r1693: Final preparations for autotools switchover for management libraries and diagnostics (but not OpenSM and its libraries as yet)
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Fri, 28 Jan 2005 20:49:06 +0000
+
+libibumad (1.2.0.MLNX20050125.acc91b0) unstable; urgency=low
+
+  * r1652: Cleanup undeleted files which were previously moved to src subdirectories
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 25 Jan 2005 23:31:32 +0000
+
+libibumad (1.2.0.MLNX20050125.293ad7d) unstable; urgency=low
+
+  * r1651: Install public headers in /usr/local/include/infiniband
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 25 Jan 2005 23:17:25 +0000
+
+libibumad (1.2.0.MLNX20050125.02aaada) unstable; urgency=low
+
+  * r1649: More changes to ready management directory for autotools switchover
+
+ --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Tue, 25 Jan 2005 22:19:06 +0000
diff --git a/debian/compat b/debian/compat
new file mode 100644
index 0000000..7f8f011
--- /dev/null
+++ b/debian/compat
@@ -0,0 +1 @@
+7
diff --git a/debian/control b/debian/control
new file mode 100644
index 0000000..2ac2773
--- /dev/null
+++ b/debian/control
@@ -0,0 +1,28 @@
+Source: libibumad
+Priority: extra
+Maintainer: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+Section: libs
+Build-Depends: debhelper (>= 8.0.0), autotools-dev
+Standards-Version: 1.3.8
+Homepage: http://www.openfabrics.org/downloads/management/libibumad-1.3.8.tar.gz
+
+Package: libibumad-devel
+Section: libdevel
+Architecture: any
+Depends: libibumad (= ${binary:Version})
+Description: Development files for the libibumad library
+
+Package: libibumad-static
+Section: libs
+Architecture: any
+Depends: libibumad (= ${binary:Version})
+Description: Static version of the libibumad library
+
+Package: libibumad
+Section: libs
+Architecture: any
+Depends: ${shlibs:Depends}, ${misc:Depends}
+Description: OpenFabrics Alliance InfiniBand umad (user MAD) library
+ libibumad provides the user MAD library functions which sit on top of
+ the user MAD modules in the kernel. These are used by the IB diagnostic
+ and management tools, including OpenSM.
diff --git a/debian/dirs b/debian/dirs
new file mode 100644
index 0000000..ca882bb
--- /dev/null
+++ b/debian/dirs
@@ -0,0 +1,2 @@
+usr/bin
+usr/sbin
diff --git a/debian/libibumad-devel.dirs b/debian/libibumad-devel.dirs
new file mode 100644
index 0000000..4418816
--- /dev/null
+++ b/debian/libibumad-devel.dirs
@@ -0,0 +1,2 @@
+usr/lib
+usr/include
diff --git a/debian/libibumad-devel.install b/debian/libibumad-devel.install
new file mode 100644
index 0000000..2a39d35
--- /dev/null
+++ b/debian/libibumad-devel.install
@@ -0,0 +1,2 @@
+usr/include/infiniband/*.h
+usr/lib/libibumad.so
diff --git a/debian/libibumad-static.dirs b/debian/libibumad-static.dirs
new file mode 100644
index 0000000..6845771
--- /dev/null
+++ b/debian/libibumad-static.dirs
@@ -0,0 +1 @@
+usr/lib
diff --git a/debian/libibumad-static.install b/debian/libibumad-static.install
new file mode 100644
index 0000000..853cf52
--- /dev/null
+++ b/debian/libibumad-static.install
@@ -0,0 +1 @@
+usr/lib/libibumad.a
diff --git a/debian/libibumad.copyright b/debian/libibumad.copyright
new file mode 100644
index 0000000..ed511b5
--- /dev/null
+++ b/debian/libibumad.copyright
@@ -0,0 +1,376 @@
+Format: http://dep.debian.net/deps/dep5
+Upstream-Name: libibumad
+Maintainer: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+Source: http://www.openfabrics.org/downloads/management
+
+Files: *
+Copyright: 2011-2013 Mellanox Technologies LTD.
+	   2004-2011 Voltaire Inc.
+License: OpenIB.org-BSD or GPLv2
+
+License: OpenIB.org-BSD
+ Redistribution and use in source and binary forms, with or without
+ modification, are permitted provided that the following conditions
+ are met:
+ .
+   * Redistributions of source code must retain the above copyright
+     notice, this list of conditions and the following disclaimer.
+ .
+   * Redistributions in binary form must reproduce the above
+     copyright notice, this list of conditions and the following
+     disclaimer in the documentation and/or other materials provided
+     with the distribution.
+ .
+ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
+ INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+ BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
+ CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
+ ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ POSSIBILITY OF SUCH DAMAGE.
+
+License: GPLv2
+                     GNU GENERAL PUBLIC LICENSE
+                        Version 2, June 1991
+ .
+  Copyright (C) 1989, 1991 Free Software Foundation, Inc.
+		59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+  Everyone is permitted to copy and distribute verbatim copies
+  of this license document, but changing it is not allowed.
+ .
+                             Preamble
+ .
+   The licenses for most software are designed to take away your
+ freedom to share and change it.  By contrast, the GNU General Public
+ License is intended to guarantee your freedom to share and change free
+ software--to make sure the software is free for all its users.  This
+ General Public License applies to most of the Free Software
+ Foundation's software and to any other program whose authors commit to
+ using it.  (Some other Free Software Foundation software is covered by
+ the GNU Library General Public License instead.)  You can apply it to
+ your programs, too.
+ .
+   When we speak of free software, we are referring to freedom, not
+ price.  Our General Public Licenses are designed to make sure that you
+ have the freedom to distribute copies of free software (and charge for
+ this service if you wish), that you receive source code or can get it
+ if you want it, that you can change the software or use pieces of it
+ in new free programs; and that you know you can do these things.
+ .
+   To protect your rights, we need to make restrictions that forbid
+ anyone to deny you these rights or to ask you to surrender the rights.
+ These restrictions translate to certain responsibilities for you if you
+ distribute copies of the software, or if you modify it.
+ .
+   For example, if you distribute copies of such a program, whether
+ gratis or for a fee, you must give the recipients all the rights that
+ you have.  You must make sure that they, too, receive or can get the
+ source code.  And you must show them these terms so they know their
+ rights.
+ .
+   We protect your rights with two steps: (1) copyright the software, and
+ (2) offer you this license which gives you legal permission to copy,
+ distribute and/or modify the software.
+ .
+   Also, for each author's protection and ours, we want to make certain
+ that everyone understands that there is no warranty for this free
+ software.  If the software is modified by someone else and passed on, we
+ want its recipients to know that what they have is not the original, so
+ that any problems introduced by others will not reflect on the original
+ authors' reputations.
+ .
+   Finally, any free program is threatened constantly by software
+ patents.  We wish to avoid the danger that redistributors of a free
+ program will individually obtain patent licenses, in effect making the
+ program proprietary.  To prevent this, we have made it clear that any
+ patent must be licensed for everyone's free use or not licensed at all.
+ .
+   The precise terms and conditions for copying, distribution and
+ modification follow.
+ .
+                     GNU GENERAL PUBLIC LICENSE
+    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+ .
+   0. This License applies to any program or other work which contains
+ a notice placed by the copyright holder saying it may be distributed
+ under the terms of this General Public License.  The "Program", below,
+ refers to any such program or work, and a "work based on the Program"
+ means either the Program or any derivative work under copyright law:
+ that is to say, a work containing the Program or a portion of it,
+ either verbatim or with modifications and/or translated into another
+ language.  (Hereinafter, translation is included without limitation in
+ the term "modification".)  Each licensee is addressed as "you".
+ .
+ Activities other than copying, distribution and modification are not
+ covered by this License; they are outside its scope.  The act of
+ running the Program is not restricted, and the output from the Program
+ is covered only if its contents constitute a work based on the
+ Program (independent of having been made by running the Program).
+ Whether that is true depends on what the Program does.
+ .
+   1. You may copy and distribute verbatim copies of the Program's
+ source code as you receive it, in any medium, provided that you
+ conspicuously and appropriately publish on each copy an appropriate
+ copyright notice and disclaimer of warranty; keep intact all the
+ notices that refer to this License and to the absence of any warranty;
+ and give any other recipients of the Program a copy of this License
+ along with the Program.
+ .
+ You may charge a fee for the physical act of transferring a copy, and
+ you may at your option offer warranty protection in exchange for a fee.
+ .
+   2. You may modify your copy or copies of the Program or any portion
+ of it, thus forming a work based on the Program, and copy and
+ distribute such modifications or work under the terms of Section 1
+ above, provided that you also meet all of these conditions:
+ .
+     a) You must cause the modified files to carry prominent notices
+     stating that you changed the files and the date of any change.
+ .
+     b) You must cause any work that you distribute or publish, that in
+     whole or in part contains or is derived from the Program or any
+     part thereof, to be licensed as a whole at no charge to all third
+     parties under the terms of this License.
+ .
+     c) If the modified program normally reads commands interactively
+     when run, you must cause it, when started running for such
+     interactive use in the most ordinary way, to print or display an
+     announcement including an appropriate copyright notice and a
+     notice that there is no warranty (or else, saying that you provide
+     a warranty) and that users may redistribute the program under
+     these conditions, and telling the user how to view a copy of this
+     License.  (Exception: if the Program itself is interactive but
+     does not normally print such an announcement, your work based on
+     the Program is not required to print an announcement.)
+ .
+ These requirements apply to the modified work as a whole.  If
+ identifiable sections of that work are not derived from the Program,
+ and can be reasonably considered independent and separate works in
+ themselves, then this License, and its terms, do not apply to those
+ sections when you distribute them as separate works.  But when you
+ distribute the same sections as part of a whole which is a work based
+ on the Program, the distribution of the whole must be on the terms of
+ this License, whose permissions for other licensees extend to the
+ entire whole, and thus to each and every part regardless of who wrote it.
+ .
+ Thus, it is not the intent of this section to claim rights or contest
+ your rights to work written entirely by you; rather, the intent is to
+ exercise the right to control the distribution of derivative or
+ collective works based on the Program.
+ .
+ In addition, mere aggregation of another work not based on the Program
+ with the Program (or with a work based on the Program) on a volume of
+ a storage or distribution medium does not bring the other work under
+ the scope of this License.
+ .
+   3. You may copy and distribute the Program (or a work based on it,
+ under Section 2) in object code or executable form under the terms of
+ Sections 1 and 2 above provided that you also do one of the following:
+ .
+     a) Accompany it with the complete corresponding machine-readable
+     source code, which must be distributed under the terms of Sections
+     1 and 2 above on a medium customarily used for software interchange; or,
+ .
+     b) Accompany it with a written offer, valid for at least three
+     years, to give any third party, for a charge no more than your
+     cost of physically performing source distribution, a complete
+     machine-readable copy of the corresponding source code, to be
+     distributed under the terms of Sections 1 and 2 above on a medium
+     customarily used for software interchange; or,
+ .
+     c) Accompany it with the information you received as to the offer
+     to distribute corresponding source code.  (This alternative is
+     allowed only for noncommercial distribution and only if you
+     received the program in object code or executable form with such
+     an offer, in accord with Subsection b above.)
+ .
+ The source code for a work means the preferred form of the work for
+ making modifications to it.  For an executable work, complete source
+ code means all the source code for all modules it contains, plus any
+ associated interface definition files, plus the scripts used to
+ control compilation and installation of the executable.  However, as a
+ special exception, the source code distributed need not include
+ anything that is normally distributed (in either source or binary
+ form) with the major components (compiler, kernel, and so on) of the
+ operating system on which the executable runs, unless that component
+ itself accompanies the executable.
+ .
+ If distribution of executable or object code is made by offering
+ access to copy from a designated place, then offering equivalent
+ access to copy the source code from the same place counts as
+ distribution of the source code, even though third parties are not
+ compelled to copy the source along with the object code.
+ .
+   4. You may not copy, modify, sublicense, or distribute the Program
+ except as expressly provided under this License.  Any attempt
+ otherwise to copy, modify, sublicense or distribute the Program is
+ void, and will automatically terminate your rights under this License.
+ However, parties who have received copies, or rights, from you under
+ this License will not have their licenses terminated so long as such
+ parties remain in full compliance.
+ .
+   5. You are not required to accept this License, since you have not
+ signed it.  However, nothing else grants you permission to modify or
+ distribute the Program or its derivative works.  These actions are
+ prohibited by law if you do not accept this License.  Therefore, by
+ modifying or distributing the Program (or any work based on the
+ Program), you indicate your acceptance of this License to do so, and
+ all its terms and conditions for copying, distributing or modifying
+ the Program or works based on it.
+ .
+   6. Each time you redistribute the Program (or any work based on the
+ Program), the recipient automatically receives a license from the
+ original licensor to copy, distribute or modify the Program subject to
+ these terms and conditions.  You may not impose any further
+ restrictions on the recipients' exercise of the rights granted herein.
+ You are not responsible for enforcing compliance by third parties to
+ this License.
+ .
+   7. If, as a consequence of a court judgment or allegation of patent
+ infringement or for any other reason (not limited to patent issues),
+ conditions are imposed on you (whether by court order, agreement or
+ otherwise) that contradict the conditions of this License, they do not
+ excuse you from the conditions of this License.  If you cannot
+ distribute so as to satisfy simultaneously your obligations under this
+ License and any other pertinent obligations, then as a consequence you
+ may not distribute the Program at all.  For example, if a patent
+ license would not permit royalty-free redistribution of the Program by
+ all those who receive copies directly or indirectly through you, then
+ the only way you could satisfy both it and this License would be to
+ refrain entirely from distribution of the Program.
+ .
+ If any portion of this section is held invalid or unenforceable under
+ any particular circumstance, the balance of the section is intended to
+ apply and the section as a whole is intended to apply in other
+ circumstances.
+ .
+ It is not the purpose of this section to induce you to infringe any
+ patents or other property right claims or to contest validity of any
+ such claims; this section has the sole purpose of protecting the
+ integrity of the free software distribution system, which is
+ implemented by public license practices.  Many people have made
+ generous contributions to the wide range of software distributed
+ through that system in reliance on consistent application of that
+ system; it is up to the author/donor to decide if he or she is willing
+ to distribute software through any other system and a licensee cannot
+ impose that choice.
+ .
+ This section is intended to make thoroughly clear what is believed to
+ be a consequence of the rest of this License.
+ .
+   8. If the distribution and/or use of the Program is restricted in
+ certain countries either by patents or by copyrighted interfaces, the
+ original copyright holder who places the Program under this License
+ may add an explicit geographical distribution limitation excluding
+ those countries, so that distribution is permitted only in or among
+ countries not thus excluded.  In such case, this License incorporates
+ the limitation as if written in the body of this License.
+ .
+   9. The Free Software Foundation may publish revised and/or new versions
+ of the General Public License from time to time.  Such new versions will
+ be similar in spirit to the present version, but may differ in detail to
+ address new problems or concerns.
+ .
+ Each version is given a distinguishing version number.  If the Program
+ specifies a version number of this License which applies to it and "any
+ later version", you have the option of following the terms and conditions
+ either of that version or of any later version published by the Free
+ Software Foundation.  If the Program does not specify a version number of
+ this License, you may choose any version ever published by the Free Software
+ Foundation.
+ .
+   10. If you wish to incorporate parts of the Program into other free
+ programs whose distribution conditions are different, write to the author
+ to ask for permission.  For software which is copyrighted by the Free
+ Software Foundation, write to the Free Software Foundation; we sometimes
+ make exceptions for this.  Our decision will be guided by the two goals
+ of preserving the free status of all derivatives of our free software and
+ of promoting the sharing and reuse of software generally.
+ .
+                             NO WARRANTY
+ .
+   11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+ FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+ OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+ PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+ OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+ TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+ PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+ REPAIR OR CORRECTION.
+ .
+   12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+ WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+ REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+ INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+ OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+ TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+ YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+ POSSIBILITY OF SUCH DAMAGES.
+ .
+                      END OF TERMS AND CONDITIONS
+ .
+             How to Apply These Terms to Your New Programs
+ .
+   If you develop a new program, and you want it to be of the greatest
+ possible use to the public, the best way to achieve this is to make it
+ free software which everyone can redistribute and change under these terms.
+ .
+   To do so, attach the following notices to the program.  It is safest
+ to attach them to the start of each source file to most effectively
+ convey the exclusion of warranty; and each file should have at least
+ the "copyright" line and a pointer to where the full notice is found.
+ .
+     <one line to give the program's name and a brief idea of what it does.>
+     Copyright (C) <year>  <name of author>
+ .
+     This program is free software; you can redistribute it and/or modify
+     it under the terms of the GNU General Public License as published by
+     the Free Software Foundation; either version 2 of the License, or
+     (at your option) any later version.
+ .
+     This program is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+     GNU General Public License for more details.
+ .
+     You should have received a copy of the GNU General Public License
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ .
+ Also add information on how to contact you by electronic and paper mail.
+ .
+ If the program is interactive, make it output a short notice like this
+ when it starts in an interactive mode:
+ .
+     Gnomovision version 69, Copyright (C) year name of author
+     Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+     This is free software, and you are welcome to redistribute it
+     under certain conditions; type `show c' for details.
+ .
+ The hypothetical commands `show w' and `show c' should show the appropriate
+ parts of the General Public License.  Of course, the commands you use may
+ be called something other than `show w' and `show c'; they could even be
+ mouse-clicks or menu items--whatever suits your program.
+ .
+ You should also get your employer (if you work as a programmer) or your
+ school, if any, to sign a "copyright disclaimer" for the program, if
+ necessary.  Here is a sample; alter the names:
+ .
+   Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+   `Gnomovision' (which makes passes at compilers) written by James Hacker.
+ .
+   <signature of Ty Coon>, 1 April 1989
+   Ty Coon, President of Vice
+ .
+ This General Public License does not permit incorporating your program into
+ proprietary programs.  If your program is a subroutine library, you may
+ consider it more useful to permit linking proprietary applications with the
+ library.  If this is what you want to do, use the GNU Library General
+ Public License instead of this License.
diff --git a/debian/libibumad.dirs b/debian/libibumad.dirs
new file mode 100644
index 0000000..507e397
--- /dev/null
+++ b/debian/libibumad.dirs
@@ -0,0 +1,2 @@
+usr/lib
+usr/share/man/man3
diff --git a/debian/libibumad.docs b/debian/libibumad.docs
new file mode 100644
index 0000000..644b98c
--- /dev/null
+++ b/debian/libibumad.docs
@@ -0,0 +1,3 @@
+AUTHORS
+COPYING
+debian/changelog
diff --git a/debian/libibumad.install b/debian/libibumad.install
new file mode 100644
index 0000000..1ff7a2f
--- /dev/null
+++ b/debian/libibumad.install
@@ -0,0 +1,2 @@
+usr/lib/lib*.so.*
+usr/share/man/man3/*
diff --git a/debian/rules b/debian/rules
new file mode 100755
index 0000000..955dd78
--- /dev/null
+++ b/debian/rules
@@ -0,0 +1,13 @@
+#!/usr/bin/make -f
+# -*- makefile -*-
+# Sample debian/rules that uses debhelper.
+# This file was originally written by Joey Hess and Craig Small.
+# As a special exception, when this file is copied by dh-make into a
+# dh-make output file, you may use that output file without restriction.
+# This special exception was added by Craig Small in version 0.37 of dh-make.
+
+# Uncomment this to turn on verbose mode.
+#export DH_VERBOSE=1
+
+%:
+	dh $@
diff --git a/debian/source/format b/debian/source/format
new file mode 100644
index 0000000..89ae9db
--- /dev/null
+++ b/debian/source/format
@@ -0,0 +1 @@
+3.0 (native)
diff --git a/gen_chlog.sh b/gen_chlog.sh
index 34dfa24..2dfdc91 100755
--- a/gen_chlog.sh
+++ b/gen_chlog.sh
@@ -8,6 +8,8 @@ usage()
 
 if [ "$1" = "--spec" ] ; then
 	spec_format=1
+elif [ "$1" = "--debian" ] ; then
+	debian_format=1
 fi
 
 GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
@@ -56,12 +58,50 @@ mkchlog()
 	done
 }
 
+mkchlog_debian()
+{
+	package=`grep AC_INIT configure.in | cut -d"(" -f2 | cut -d"," -f1`
+
+	prev_tag=""
+
+	for tag in `git tag -l '*'` ; do
+		obj=`git cat-file tag $tag | awk '/^object /{print $2}'`
+		base=`git merge-base $obj HEAD`
+		if [ -z "$base" -o "$base" != $obj ] ; then
+			continue
+		fi
+		all_vers="$prev_tag$tag $all_vers"
+		prev_tag=$tag..
+	done
 
-if [ -z "$spec_format" ] ; then
-	mkchlog --pretty=format:"%ad %an%n%H%n%n* %s%n" \
-		| sed -e 's/^\* /\t* /'
+	if [ -z "$prev_tag" ] ; then
+		all_vers=HEAD
+	else
+		all_vers="${prev_tag}HEAD $all_vers"
+	fi
+
+	for ver in $all_vers ; do
+		log_out=`git log $ver -- ./`
+		if [ -z "$log_out" ] ; then
+			continue
+		fi
+		ver_name=`echo $ver | sed -e 's/\.\..*$//'`
+		ver_num=`echo $ver_name | cut -d"-" -f2`
+		log_format="--pretty=format:${package} ($ver_num.MLNX%ai.%h) unstable; urgency=low%n%n  * %s%n%n --  %an <%ae>  %aD%n"
+		git log --no-merges "${log_format}" $ver -- ./
+		prev_t=$tag..
+	done
+}
+
+if [ -z "$debian_format" ] ; then
+	if [ -z "$spec_format" ] ; then
+		mkchlog --pretty=format:"%ad %an%n%H%n%n* %s%n" \
+			| sed -e 's/^\* /\t* /'
+	else
+		echo "%changelog"
+		mkchlog --pretty=format:"- %ad %an: %s"
+		echo ""
+	fi
 else
-	echo "%changelog"
-	mkchlog --pretty=format:"- %ad %an: %s"
-	echo ""
+	mkchlog_debian | sed -e 's/\(MLNX\w\{4\}\)-\(\w\{2\}\)-\(\w\{2\}\) [0-9:]\{8\} [0-9+-]\{5\}/\1\2\3/'
 fi
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
