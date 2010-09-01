From: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>
Subject: install libsdp openib setup
Date: Wed, 01 Sep 2010 11:39:18 -0400
Message-ID: <1283355558.14487.83.camel@bohr.ornl.gov>
References: <1283354621.14487.80.camel@bohr.ornl.gov>
Reply-To: simmonsja-1Heg1YXhbW8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yhA5L3iN9OkbsRSL0LnP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1283354621.14487.80.camel-TbGF127JXZUcvh0c176lvQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-yhA5L3iN9OkbsRSL0LnP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch has the install.pl pass in the default --with-openib=$value
for libsdp.



--=-yhA5L3iN9OkbsRSL0LnP
Content-Disposition: attachment; filename=sdp-select.diff
Content-Type: text/x-patch; name=sdp-select.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- install.pl.orig	2010-09-01 11:36:11.000000000 -0400
+++ install.pl	2010-09-01 11:36:50.000000000 -0400
@@ -3098,6 +3098,12 @@
             $cmd .= " --define 'build_ibmgtsim 1'";
             $cmd .= " --define '__arch_install_post %{nil}'";
         }
+        elsif ( $parent eq "libsdp") {
+            $packages_info{'libsdp'}{'configure_options'} .= " --with-openib=$prefix/src/openib";
+            $cmd .= " --define '_prefix $prefix'";
+            $cmd .= " --define '_exec_prefix $prefix'";
+            $cmd .= " --define '_sysconfdir $sysconfdir'";
+        }
         elsif ( $parent eq "mvapich") {
             my $compiler = (split('_', $name))[1];
             $cmd .= " --define '_name $name'";

--=-yhA5L3iN9OkbsRSL0LnP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
