From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: remove unused options from
 check_lft_balance.pl
Date: Mon, 27 Feb 2012 14:21:40 -0800
Message-ID: <20120227142140.b03511d5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 scripts/check_lft_balance.pl |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/scripts/check_lft_balance.pl b/scripts/check_lft_balance.pl
index 48f756b..395096c 100755
--- a/scripts/check_lft_balance.pl
+++ b/scripts/check_lft_balance.pl
@@ -45,7 +45,6 @@ use Getopt::Std;
 my $ibnetdiscover_cache = "";
 my $dump_lft_file       = "";
 my $verbose             = 0;
-my $query_opt           = "";
 
 my $switch_lid                            = undef;
 my $switch_guid                           = undef;
@@ -73,8 +72,6 @@ sub usage
 	print "  Generate ibnetdiscover-cache via \"ibnetdiscover --cache ibnetdiscover-cache\"\n";
 	print "  -e turn on heuristic(s) to look at switch balances deeper\n";
 	print "  -v verbose output, output all switches\n";
-	print "  -C <ca_name> use selected Channel Adaptor name for queries\n";
-	print "  -P <ca_port> use selected channel adaptor port for queries\n";
 	exit 2;
 }
 
@@ -178,7 +175,7 @@ sub output_switch_port_usage
 	my $all_zero_flag = 1;
 	my $ret;
 
-        $iblinkinfo_output = `iblinkinfo $query_opt --load-cache $ibnetdiscover_cache -S $switch_guid`;
+        $iblinkinfo_output = `iblinkinfo --load-cache $ibnetdiscover_cache -S $switch_guid`;
 
 	for $port (@ports) {
 		if (!defined($switch_port_count{$port})) {
@@ -359,14 +356,6 @@ if (defined($main::opt_e)) {
 	$heuristic_flag = 1;
 }
 
-if (defined $Getopt::Std::opt_C) {
-	$query_opt = "$query_opt -C $Getopt::Std::opt_C";
-}
-
-if (defined $Getopt::Std::opt_P) {
-	$query_opt = "$query_opt -P $Getopt::Std::opt_P";
-}
-
 if (!open(FH, "< $dump_lft_file")) {
 	print STDERR ("Couldn't open dump lfts file: $dump_lft_file: $!\n");
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
