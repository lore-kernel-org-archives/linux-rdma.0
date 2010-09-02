From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibsim: parse width and speed from ibnetdiscover output
Date: Thu, 02 Sep 2010 10:37:40 +0300
Message-ID: <4C7F5444.4030302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Search for the pattern '[0-9]*x[SDQ]DR'
Validate that width value is valid.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/sim_net.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 13c3b8c..278c065 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -611,6 +611,7 @@ static int parse_port(char *line, Node * node, int type, int maxports)
 	int portnum, isalias = 0;
 	Port *port;
 	char *s;
+	char *p;
 
 	if (line[0] == '@') {
 		isalias = 1;
@@ -671,6 +672,7 @@ static int parse_port(char *line, Node * node, int type, int maxports)
 	}
       parse_opt:
 	line = s;
+	p = s;
 	while (s && (s = strchr(s + 1, '='))) {
 		char *opt = s;
 		while (opt && !isalpha(*opt))
@@ -685,6 +687,52 @@ static int parse_port(char *line, Node * node, int type, int maxports)
 		IBWARN("cannot parse lid, lmc");
 		return -1;
 	}
+
+	/* parse width speed from '[0-9]*x[SDQ]DR' pattern */
+	/* also checking for valid width value */
+	char wstr[3];
+	char sstr[3];
+	s = p;
+	while (s && (s = strchr(s + 1, 'x'))) {
+		int width;
+		p = s - 1;
+		while (p && !isdigit(*p))
+			p--;
+		width = atoi(p);
+		switch (width) {
+			case 1: strcpy(wstr, "1");
+				break;
+			case 4: strcpy(wstr, "2");
+				break;
+			case 8: strcpy(wstr, "4");
+				break;
+			case 12: strcpy(wstr, "8");
+				break;
+			default: wstr[0] = sstr[0] = 0;
+				continue;
+		}
+		p = p + 2;
+		if (!strncmp("SDR", p, 3))
+			strcpy(sstr, "1");
+		else if (!strncmp("DDR", p, 3))
+			strcpy(sstr, "2");
+		else if (!strncmp("QDR", p, 3))
+			strcpy(sstr, "4");
+		else {
+			wstr[0] = sstr[0] = 0;
+			continue;
+		}
+	}
+
+	if (parse_port_opt(port, "w", wstr) < 0) {
+		IBWARN("bad port option");
+		return -1;
+	}
+
+	if (parse_port_opt(port, "s", sstr) < 0) {
+		IBWARN("bad port option");
+		return -1;
+	}
 	return 1;
 }
 
-- 
1.7.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
