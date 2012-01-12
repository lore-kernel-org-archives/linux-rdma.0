From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed segfault in osm_destroy
Date: Thu, 12 Jan 2012 16:14:35 +0200
Message-ID: <20120112141435.GC6571@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixed segfault in osm_destroy() when hop_weights_file,
port_search_ordering_file or io_guid_file are configured.

The segfault introduced by d71a924736707400bed47a3c69395cf864c970bb.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index 3edc52f..c75d220 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -724,13 +724,13 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'w':
-			opt.hop_weights_file = optarg;
+			SET_STR_OPT(opt.hop_weights_file, optarg);
 			printf(" Hop Weights File = %s\n",
 			       opt.hop_weights_file);
 			break;
 
 		case 'O':
-			opt.port_search_ordering_file = optarg;
+			SET_STR_OPT(opt.port_search_ordering_file, optarg);
 			printf(" Port Search Ordering/Dimension Ports File = %s\n",
 			       opt.port_search_ordering_file);
 			break;
@@ -959,7 +959,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'G':
-			opt.io_guid_file = optarg;
+			SET_STR_OPT(opt.io_guid_file, optarg);
 			printf(" I/O Node Guid File: %s\n", opt.io_guid_file);
 			break;
 		case 11:
-- 
1.7.1

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
