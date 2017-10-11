From: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
Subject: [PATCH] providers/rxe: Fix rxe_cfg parsing of ethtool / ifconfig
Date: Wed, 11 Oct 2017 11:02:36 -0600
Message-ID: <CALvXFTcBcp1LxD-KpEAUkZA6hNH4qa_Q5pcJLdbUcTSvEQUDCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rxe_cfg does not always parse the output of ethtool and ifconfig correctly.

Fix two items:
1)  Parsing of ethtool's link speed field to always output a link speed.
2)  Parsing of ifconfig's IP address / MTU fields with newer builds of
ifconfig that have a slightly different output format than in the
past.

Signed-off-by: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>

--------------------------------------------------------------------------------

diff --git a/providers/rxe/rxe_cfg.in b/providers/rxe/rxe_cfg.in
index 0a8583d..8429b28 100755
--- a/providers/rxe/rxe_cfg.in
+++ b/providers/rxe/rxe_cfg.in
@@ -180,9 +180,9 @@ sub get_dev_info {
                    if ($fields[0] =~ "Link detected") {
                        $link_state{$eth} = $fields[1];
                    }
-           }
-           elsif ($line =~ "10000baseT") {
-               $link_speed{$eth} = "10GigE";
+                   elsif ($fields[0] =~ "Speed") {
+                       $link_speed{$eth} = $fields[1];
+                   }
            }
        }

@@ -197,6 +197,11 @@ sub get_dev_info {
                @fields = split(/\s+/, $line);
                $ipv4_addr{$eth} = $fields[0];
            }
+           elsif ($line =~ /inet /) {
+           $line =~ s/^\s+inet //g;
+               @fields = split(/\s+/, $line);
+               $ipv4_addr{$eth} = $fields[0];
+           }

            # get ethernet mtu
            if ($line =~ /MTU:/) {
@@ -204,6 +209,11 @@ sub get_dev_info {
                @fields = split(/\s+/, $line);
                $eth_mtu{$eth} = $fields[0];
            }
+           elsif ($line =~ /mtu /) {
+               $line =~ s/^.*mtu //g;
+               @fields = split(/\s+/, $line);
+               $eth_mtu{$eth} = $fields[0];
+           }
        }
     }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
