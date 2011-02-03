From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed getline pointer allocation free in
 osm_console_io
Date: Thu, 3 Feb 2011 13:53:55 +0200
Message-ID: <20110203115355.GA5246@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

p_line allocated by getline() isn't being freed at the end.

Signed-off-by: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_console_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_console_io.c b/opensm/opensm/osm_console_io.c
index 0a15313..1205a5f 100644
--- a/opensm/opensm/osm_console_io.c
+++ b/opensm/opensm/osm_console_io.c
@@ -130,8 +130,10 @@ int cio_open(osm_console_t * p_oct, int new_fd, osm_log_t * p_log)
 				"Console connection aborted: %s (%s)\n",
 				p_oct->client_hn, p_oct->client_ip);
 			close(new_fd);
+			free(p_line);
 			return -1;
 		}
+		free(p_line);
 	}
 	p_oct->in_fd = new_fd;
 	p_oct->out_fd = p_oct->in_fd;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
