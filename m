From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: fix ibidsverify portguid validation.
Date: Fri, 4 May 2012 12:19:10 -0700
Message-ID: <20120504121910.9074eca4.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



PortGUID may be equal to the NodeGUID of it's own node for 1 port.  Duplicate
PortGUID's on that node will be detected in insert_portguid

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 scripts/ibidsverify.pl |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/scripts/ibidsverify.pl b/scripts/ibidsverify.pl
index 2552a7b..6f3d309 100755
--- a/scripts/ibidsverify.pl
+++ b/scripts/ibidsverify.pl
@@ -136,12 +136,11 @@ sub insert_nodeguid
 sub validate_portguid
 {
 	my ($portguid)  = shift(@_);
-	my ($firstport) = shift(@_);
+	my ($nodeguid)  = shift(@_);
 
-	if (defined($insert_nodeguid::nodeguids{$portguid})
-		&& ($firstport ne "yes"))
-	{
-		print "PortGUID $portguid is invalid duplicate of a NodeGUID\n";
+	if (($nodeguid ne $portguid)
+		&& defined($insert_nodeguid::nodeguids{$portguid})) {
+		print "PortGUID $portguid is an invalid duplicate of a NodeGUID\n";
 	}
 }
 
@@ -150,7 +149,7 @@ sub insert_portguid
 	my ($lid)       = shift(@_);
 	my ($portguid)  = shift(@_);
 	my ($nodetype)  = shift(@_);
-	my ($firstport) = shift(@_);
+	my ($nodeguid)  = shift(@_);
 	my $rec         = undef;
 	my $status      = "";
 
@@ -162,7 +161,7 @@ sub insert_portguid
 		} else {
 			$rec = {lid => $lid, portguid => $portguid};
 			$insert_portguid::portguids{$portguid} = $rec;
-			validate_portguid($portguid, $firstport);
+			validate_portguid($portguid, $nodeguid);
 		}
 	}
 }
@@ -208,7 +207,7 @@ sub main
 			insert_lid($lid, $nodeguid, $nodetype);
 			insert_nodeguid($lid, $nodeguid, $nodetype);
 			if ($portguid ne "") {
-				insert_portguid($lid, $portguid, $nodetype, $firstport);
+				insert_portguid($lid, $portguid, $nodetype, $nodeguid);
 			}
 		}
 		if ($line =~ /^Ca.*/) {
@@ -247,7 +246,7 @@ sub main
 			}
 			if ($line =~ /^\[(\d+)\]\((.*)\)/) {
 				$portguid = "0x" . $2;
-				insert_portguid($lid, $portguid, $nodetype, $firstport);
+				insert_portguid($lid, $portguid, $nodetype, $nodeguid);
 			}
 		}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
