From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_qos_parser_y.y: fix endless loop
Date: Sat, 3 Oct 2009 03:15:59 +0200
Message-ID: <20091003011559.GE17846@me>
References: <20091001192536.GY17846@me>
 <f0e08f230910021041p28307726j6bb280220abd1eae@mail.gmail.com>
 <20091003003357.GD17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091003003357.GD17846@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix endless loop introduced by signed --> unsigned conversion (was done
for compilation warning fix). Reimplement __parser_strip_white() in
slightly shorter variant without explicit index.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_qos_parser_y.y |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 7a2ce13..95e420e 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -2394,20 +2394,17 @@ static void yyerror(const char *format, ...)
 
 static char * __parser_strip_white(char * str)
 {
-   unsigned int i;
-   for (i = (strlen(str)-1); i >= 0; i--)
-   {
-      if (isspace(str[i]))
-          str[i] = '\0';
-      else
-         break;
-   }
-   for (i = 0; i < strlen(str); i++)
-   {
-      if (!isspace(str[i]))
-         break;
-   }
-   return &(str[i]);
+	char *p;
+
+	while (isspace(*str))
+		str++;
+	if (!*str)
+		return str;
+	p = str + strlen(str) - 1;
+	while (isspace(*p))
+		*p-- = '\0';
+
+	return str;
 }
 
 /***************************************************
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
