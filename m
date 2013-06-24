From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibsim] sim_client.c: Set issm flag on connect when SIM_SET_ISSM
 set
Date: Mon, 24 Jun 2013 09:08:10 -0400
Message-ID: <51C844BA.1050608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When the SIM_SET_ISSM environment variable is set, ibsim did not
set the issm bit until after an ibsim connection was complete.  This
allowed multiple SMs to actively run as the SM on the the same port.

Slight rework of original patch from Al Chu.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> 
---
diff --git a/umad2sim/sim_client.c b/umad2sim/sim_client.c
index eb42a7c..cec72d9 100644
--- a/umad2sim/sim_client.c
+++ b/umad2sim/sim_client.c
@@ -173,12 +173,16 @@ static int sim_attach(int fd, union name_t *name, size_t size)
 	return 0;
 }
 
-static int sim_connect(struct sim_client *sc, int id, int qp, char *nodeid)
+static int sim_connect(struct sim_client *sc, int id, int qp, char *nodeid,
+		       char *issm)
 {
 	struct sim_client_info info = { 0 };
 
 	info.id = id;
-	info.issm = 0;
+	if (issm)
+		info.issm = 1;
+	else
+		info.issm = 0;
 	info.qp = qp;
 
 	if (nodeid)
@@ -200,7 +204,7 @@ static int sim_disconnect(struct sim_client *sc)
 	return sim_ctl(sc, SIM_CTL_DISCONNECT, 0, 0);
 }
 
-static int sim_init(struct sim_client *sc, char *nodeid)
+static int sim_init(struct sim_client *sc, char *nodeid, char *issm)
 {
 	union name_t name;
 	socklen_t size;
@@ -254,7 +258,7 @@ static int sim_init(struct sim_client *sc, char *nodeid)
 		IBPANIC("can't read data from bound socket");
 	port = ntohs(name.name_i.sin_port);
 
-	sc->clientid = sim_connect(sc, remote_mode ? port : pid, 0, nodeid);
+	sc->clientid = sim_connect(sc, remote_mode ? port : pid, 0, nodeid, issm);
 	if (sc->clientid < 0)
 		IBPANIC("connect failed");
 
@@ -284,9 +288,11 @@ int sim_client_set_sm(struct sim_client *sc, unsigned issm)
 int sim_client_init(struct sim_client *sc)
 {
 	char *nodeid;
+	char *issm;
 
 	nodeid = getenv("SIM_HOST");
-	if (sim_init(sc, nodeid) < 0)
+	issm = getenv("SIM_SET_ISSM");
+	if (sim_init(sc, nodeid, issm) < 0)
 		return -1;
 	if (sim_ctl(sc, SIM_CTL_GET_VENDOR, &sc->vendor,
 		    sizeof(sc->vendor)) < 0)
@@ -301,7 +307,7 @@ int sim_client_init(struct sim_client *sc)
 		goto _exit;
 	if (sim_ctl(sc, SIM_CTL_GET_PKEYS, sc->pkeys, sizeof(sc->pkeys)) < 0)
 		goto _exit;
-	if (getenv("SIM_SET_ISSM"))
+	if (issm)
 		sim_client_set_sm(sc, 1);
 	return 0;
   _exit:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
