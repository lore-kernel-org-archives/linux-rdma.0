From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] rxe: Remove perl::switch module dependancy
Date: Wed, 16 Nov 2016 10:46:46 +0200
Message-ID: <1479286006-5265-1-git-send-email-yonatanc@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove perl::switch dependency from RXE, since it is
not installed by default.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/rxe/rxe_cfg | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
index 6c414fb..c2dbd0e 100755
--- a/providers/rxe/rxe_cfg
+++ b/providers/rxe/rxe_cfg
@@ -37,7 +37,6 @@ use strict;
 
 use File::Basename;
 use Getopt::Long;
-use Switch;
 
 my $help = 0;
 my $no_persist = 0;
@@ -559,26 +558,21 @@ sub do_debug {
     my $debugfile = "$parms/debug";
     chomp($arg2);
 
-    #print "debug $arg2\n";
-    #system("echo 'debug $arg2' > $proc");
-
     if (!(-e "$debugfile")) {
 	print "Error: debug is compiled out of this rxe driver\n";
 	return;
     }
 
-    switch ($arg2) {
-	case "on"   { 	system("echo '31' > $debugfile"); }
-	case "off"  { 	system("echo '0'  > $debugfile"); }
-	case "0"    { 	system("echo '0'  > $debugfile"); }
-	case ""     { }
+    if    ($arg2 eq "on")  { system("echo '31' > $debugfile"); }
+    elsif ($arg2 eq "off") { system("echo '0'  > $debugfile"); }
+    elsif ($arg2 eq "0")   { system("echo '0'  > $debugfile"); }
+    elsif ($arg2 eq "")    { }
 	elsif ($arg2 ge "0" && $arg2 le "31") {
 	    system("echo '$arg2' > $debugfile");
 	}
 	else {
 	    print "unrecognized debug cmd ($arg2)\n";
 	}
-    }
 
     my $current = read_file($debugfile);
     chomp($current);
@@ -645,11 +639,10 @@ sub main {
     }
 
     # stuff that does not require modules to be loaded
-    switch($arg1) {
-        case "help"		{ usage(); exit; }
-        case "start"		{ do_start(); do_status(); exit; }
-        case "persistent"	{ system("cat $persistence_file"); exit; }
-    }
+    if    ($arg1 eq "help")       { usage(); exit; }
+    elsif ($arg1 eq "start")      { do_start(); do_status(); exit; }
+    elsif ($arg1 eq "persistent") { system("cat $persistence_file"); exit; }
+
 
     # can't do much else, bail if modules aren't loaded
     if (check_module_status()) {
@@ -668,13 +661,11 @@ sub main {
     get_dev_info();
 
     # Stuff that requires the rdma_rxe module to be loaded
-    switch($arg1) {
-        case "stop"	{ do_stop(); 			exit; }
-        case "debug"	{ do_debug($arg2);	 	exit; }
-        case "add"	{ rxe_add($arg2); 		exit; }
-        case "remove"	{ rxe_remove($arg2); 		exit; }
-        case "help"	{ usage();			exit; }
-    }
+    if    ($arg1 eq "stop")   { do_stop(); 	   exit; }
+    elsif ($arg1 eq "debug")  { do_debug($arg2);   exit; }
+    elsif ($arg1 eq "add")    { rxe_add($arg2);    exit; }
+    elsif ($arg1 eq "remove") { rxe_remove($arg2); exit; }
+    elsif ($arg1 eq "help")   { usage();	   exit; }
 }
 
 main();
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
