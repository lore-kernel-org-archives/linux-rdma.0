From: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>
Subject: [PATCH] srp_daemon: pr_err date format bug
Date: Fri, 22 Jul 2011 09:48:18 -0500
Message-ID: <20110722144818.GA7450@bukharin.us.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The pr_err macro used by srp_daemon to log errors prints the incorrect
date (month).  The month is one less than the actual month since a
tm_mon is the number of months since January (0 - 11) and not the
actual month number (1 - 12).   Easily fixed by adding 1 to the
tm_mon value.

Also opened OpenFabrics Bug 2281
(http://bugs.openfabrics.org/bugzilla/show_bug?id=2281) for this
issue.

[Aside:  It would be nice if the srptools tree was public.  The
 README also contains reference to outdated openib mailing lists!]

Signed-off-by: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>

---

--- srp_daemon.h.orig	2009-08-30 08:56:11.000000000 -0500
+++ srp_daemon.h	2011-07-07 12:54:02.000000000 -0500
@@ -406,7 +406,7 @@
 		struct tm *t = localtime(&tt);				\
 		sprintf(str, arg);					\
 		fprintf(stderr, "%02d/%02d/%02d %02d:%02d:%02d : %s", 	\
-			t->tm_mday, t->tm_mon, t->tm_year%100, 		\
+			t->tm_mday, t->tm_mon+1, t->tm_year%100, 	\
 			t->tm_hour, t->tm_min, t->tm_sec, str);		\
 	} while (0)
