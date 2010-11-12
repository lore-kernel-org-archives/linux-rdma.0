From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 06/13] opensm/osm_torus.c: Also parse DOS line endings
 in torus-2QoS.conf.
Date: Fri, 12 Nov 2010 15:11:15 -0700
Message-ID: <1289599882-15165-7-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 784955d..804334f 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -980,7 +980,7 @@ bool parse_config(const char *fn, struct fabric *f, struct torus *t)
 	FILE *fp;
 	char *keyword;
 	char *line_buf = NULL;
-	const char *parse_sep = " \n\t";
+	const char *parse_sep = " \n\t\015";
 	size_t line_buf_sz = 0;
 	size_t line_cntr = 0;
 	ssize_t llen;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
