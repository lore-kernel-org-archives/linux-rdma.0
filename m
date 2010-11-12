From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 10/13] opensm/main.c: Add description of "no_fallback"
 to "--routing_engine" option documentation.
Date: Fri, 12 Nov 2010 15:11:19 -0700
Message-ID: <1289599882-15165-11-git-send-email-jaschut@sandia.gov>
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
 opensm/opensm/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index e74dc46..756fe6f 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -174,6 +174,9 @@ static void show_usage(void)
 	       "          Min Hop algorithm.  Multiple routing engines can be specified\n"
 	       "          separated by commas so that specific ordering of routing\n"
 	       "          algorithms will be tried if earlier routing engines fail.\n"
+	       "          If all configured routing engines fail, OpenSM will always\n"
+	       "          attempt to route with Min Hop unless 'no_fallback' is\n"
+	       "          included in the list of routing engines.\n"
 	       "          Supported engines: updn, file, ftree, lash, dor, torus-2QoS\n\n");
 	printf("--do_mesh_analysis\n"
 	       "          This option enables additional analysis for the lash\n"
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
