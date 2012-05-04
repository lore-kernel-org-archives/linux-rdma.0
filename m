From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibidsverify exit status 1 on errors found
Date: Fri, 4 May 2012 12:19:15 -0700
Message-ID: <20120504121915.af395323.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/ibidsverify.8      |    4 ++++
 scripts/ibidsverify.pl |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/man/ibidsverify.8 b/man/ibidsverify.8
index e3d9a03..d617387 100644
--- a/man/ibidsverify.8
+++ b/man/ibidsverify.8
@@ -27,6 +27,10 @@ information.  This option is slower but should be used if the diag tools have
 not been used for some time or if there are other reasons to believe the
 fabric has changed.
 
+.SH EXIT STATUS
+
+Exit status is 1 if errors are found, 0 otherwise.
+
 .SH SEE ALSO
 .BR ibnetdiscover(8)
 
diff --git a/scripts/ibidsverify.pl b/scripts/ibidsverify.pl
index 6114718..07142d1 100755
--- a/scripts/ibidsverify.pl
+++ b/scripts/ibidsverify.pl
@@ -37,6 +37,8 @@ use strict;
 use Getopt::Std;
 use IBswcountlimits;
 
+my $return_code = 0;
+
 sub usage_and_exit
 {
 	my $prog = $_[0];
@@ -106,10 +108,13 @@ sub insert_lid
 		if (defined($insert_lid::lids{$lid})) {
 			print
 "LID $lid already defined for NodeGUID $insert_lid::lids{$lid}->{nodeguid}\n";
+			$return_code = 1;
 		} else {
 			$rec = {lid => $lid, nodeguid => $nodeguid};
 			$insert_lid::lids{$lid} = $rec;
 		}
+	} else {
+		$return_code = $status;
 	}
 }
 
@@ -126,10 +131,13 @@ sub insert_nodeguid
 		if (defined($insert_nodeguid::nodeguids{$nodeguid})) {
 			print
 "NodeGUID $nodeguid already defined for LID $insert_nodeguid::nodeguids{$nodeguid}->{lid}\n";
+			$return_code = 1;
 		} else {
 			$rec = {lid => $lid, nodeguid => $nodeguid};
 			$insert_nodeguid::nodeguids{$nodeguid} = $rec;
 		}
+	} else {
+		$return_code = $status;
 	}
 }
 
@@ -141,6 +149,7 @@ sub validate_portguid
 	if (($nodeguid ne $portguid)
 		&& defined($insert_nodeguid::nodeguids{$portguid})) {
 		print "PortGUID $portguid is an invalid duplicate of a NodeGUID\n";
+		$return_code = 1;
 	}
 }
 
@@ -158,11 +167,14 @@ sub insert_portguid
 		if (defined($insert_portguid::portguids{$portguid})) {
 			print
 "PortGUID $portguid already defined for LID $insert_portguid::portguids{$portguid}->{lid}\n";
+			$return_code = 1;
 		} else {
 			$rec = {lid => $lid, portguid => $portguid};
 			$insert_portguid::portguids{$portguid} = $rec;
 			validate_portguid($portguid, $nodeguid);
 		}
+	} else {
+		$return_code = $status;
 	}
 }
 
@@ -256,3 +268,5 @@ sub main
 }
 main;
 
+exit ($return_code);
+
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
