From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/4] add support for end port selection
Date: Sun, 21 Mar 2010 17:24:00 +0200
Message-ID: <4BA63A10.3070909@voltaire.com>
References: <4BA6391A.7020608@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BA6391A.7020608-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

add support for end port selection instead
of using only the first port.

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/ibsim.c         |   29 +++++
 umad2sim/sim_client.c |   49 +++++++-
 umad2sim/sim_client.h |    6 +-
 umad2sim/umad2sim.c   |  332 +++++++++++++++++++++++++++----------------------
 4 files changed, 259 insertions(+), 157 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index 3cb97e4..f59257d 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -289,6 +289,31 @@ static int sim_ctl_get_port(Client * cl, struct sim_ctl * ctl)
 	return 0;
 }
 
+static int sim_ctl_set_port(Client *cl, struct sim_ctl *ctl)
+{
+	int portnum = ctl->data[0];
+	Node *node;
+
+	if (!(node = find_node(cl->nodeid)) &&
+			!(node = find_node_by_desc(cl->nodeid))) {
+		IBWARN("client %d attempt to set port to unknown host"
+				" \"%s\"", cl->id, cl->nodeid);
+		ctl->type = SIM_CTL_ERROR;
+		return -1;
+	}
+	if (portnum < 0 || portnum > node->numports) {
+		IBWARN("client %d attempt to set invalid port number %d",
+				cl->id, portnum);
+		ctl->type = SIM_CTL_ERROR;
+		return -1;
+	}
+	cl->port = node_get_port(node, portnum);
+	VERB("Setting port %d to client %d at node \"%s\" port 0x%" PRIx64,
+			portnum, cl->id, node->nodeid, cl->port->portguid);
+	return 0;
+}
+
+
 static int sim_ctl_get_gid(Client * cl, struct sim_ctl * ctl)
 {
 	char *gid = (void *)ctl->data;
@@ -458,6 +483,10 @@ static int sim_ctl(int fd)
 		sim_ctl_get_pkeys(cl, &ctl);
 		break;
 
+	case SIM_CTL_SET_PORT:
+		sim_ctl_set_port(cl, &ctl);
+		break;
+
 	default:
 	case SIM_CTL_ERROR:
 		IBWARN("bad ctl pkt type %d", ctl.type);
diff --git a/umad2sim/sim_client.c b/umad2sim/sim_client.c
index eb42a7c..ac8526c 100644
--- a/umad2sim/sim_client.c
+++ b/umad2sim/sim_client.c
@@ -61,7 +61,7 @@
 static unsigned int remote_mode = 0;
 static char* socket_basename;
 
-static int sim_ctl(struct sim_client *sc, int type, void *data, int len)
+int sim_ctl(struct sim_client *sc, int type, void *data, int len)
 {
 	struct sim_ctl ctl;
 
@@ -284,6 +284,10 @@ int sim_client_set_sm(struct sim_client *sc, unsigned issm)
 int sim_client_init(struct sim_client *sc)
 {
 	char *nodeid;
+	int i, startport, endport;
+	uint8_t numports = 1, nodetype;
+	uint8_t *portinfo;
+	uint16_t *pkeys;
 
 	nodeid = getenv("SIM_HOST");
 	if (sim_init(sc, nodeid) < 0)
@@ -295,12 +299,43 @@ int sim_client_init(struct sim_client *sc)
 		    sizeof(sc->nodeinfo)) < 0)
 		goto _exit;
 
-	sc->portinfo[0] = 0;	// portno requested
-	if (sim_ctl(sc, SIM_CTL_GET_PORTINFO, sc->portinfo,
-		    sizeof(sc->portinfo)) < 0)
-		goto _exit;
-	if (sim_ctl(sc, SIM_CTL_GET_PKEYS, sc->pkeys, sizeof(sc->pkeys)) < 0)
+	nodetype = mad_get_field(sc->nodeinfo, 0, IB_NODE_TYPE_F);
+
+	if (nodetype == IB_NODE_SWITCH) {
+		startport = 0;
+		endport = 0;
+	} else {
+		numports = mad_get_field(sc->nodeinfo, 0, IB_NODE_NPORTS_F);
+		startport = 1;
+		endport = numports;
+	}
+
+	/*
+	 * portinfo and pkeys size x number of ports starting at 0
+	 * for Ca we allocate entry 0 just for compatibility with Switch node
+	 */
+	if (nodetype == IB_NODE_SWITCH) {
+		sc->portinfo = malloc(64);
+		sc->pkeys = malloc(64);
+	} else {
+		sc->portinfo = malloc(64 * (numports + 1));
+		sc->pkeys = malloc(64 * (numports + 1));
+	}
+
+	if (!sc->portinfo || !sc->pkeys)
 		goto _exit;
+	/* loop through end ports */
+	for (i = startport; i <= endport ; i++) {
+		portinfo = sc->portinfo + 64 * i;
+		*portinfo = i;
+		if (sim_ctl(sc, SIM_CTL_GET_PORTINFO, portinfo, 64) < 0)
+			goto _exit;
+		pkeys = sc->pkeys + 64 * i;
+		*pkeys = i;
+		if (sim_ctl(sc, SIM_CTL_GET_PKEYS, pkeys, 64) < 0)
+			goto _exit;
+	}
+
 	if (getenv("SIM_SET_ISSM"))
 		sim_client_set_sm(sc, 1);
 	return 0;
@@ -314,4 +349,6 @@ void sim_client_exit(struct sim_client *sc)
 {
 	sim_disconnect(sc);
 	sc->fd_ctl = sc->fd_pktin = sc->fd_pktout = -1;
+	free(sc->portinfo);
+	free(sc->pkeys);
 }
diff --git a/umad2sim/sim_client.h b/umad2sim/sim_client.h
index 80ed442..01d0939 100644
--- a/umad2sim/sim_client.h
+++ b/umad2sim/sim_client.h
@@ -37,13 +37,15 @@
 
 #include <ibsim.h>
 
+#define MAX_PORTS 8
+
 struct sim_client {
 	int clientid;
 	int fd_pktin, fd_pktout, fd_ctl;
 	struct sim_vendor vendor;
 	uint8_t nodeinfo[64];
-	uint8_t portinfo[64];
-	uint16_t pkeys[SIM_CTL_MAX_DATA/sizeof(uint16_t)];
+	uint8_t *portinfo;
+	uint16_t *pkeys;
 };
 
 extern int sim_client_set_sm(struct sim_client *sc, unsigned issm);
diff --git a/umad2sim/umad2sim.c b/umad2sim/umad2sim.c
index 55440ec..8c1050e 100644
--- a/umad2sim/umad2sim.c
+++ b/umad2sim/umad2sim.c
@@ -64,6 +64,7 @@
 #define ERROR(fmt...) fprintf(stderr, "ERR: " fmt)
 
 #define arrsize(a) (sizeof(a)/sizeof(a[0]))
+extern int sim_ctl(struct sim_client *, int, void *, int);
 
 struct ib_user_mad_reg_req {
 	uint32_t id;
@@ -79,7 +80,7 @@ struct umad2sim_dev {
 	int fd;
 	unsigned num;
 	char name[32];
-	uint8_t port;
+	int umadport[MAX_PORTS];
 	struct sim_client sim_client;
 	unsigned agent_idx[256];
 	struct ib_user_mad_reg_req agents[32];
@@ -186,7 +187,13 @@ static int dev_sysfs_create(struct umad2sim_dev *dev)
 	struct sim_client *sc = &dev->sim_client;
 	char *str;
 	uint8_t *portinfo;
-	int i;
+	uint16_t *pkeys;
+	int i, p;
+	char *ports_path_end;
+	int startport = 0, endport = 0, offset = 0;
+	int portnum;
+	uint8_t numports, nodetype;
+	char name[8];
 
 	/* /sys/class/infiniband_mad/abi_version */
 	snprintf(path, sizeof(path), "%s", sysfs_infiniband_mad_dir);
@@ -211,7 +218,6 @@ static int dev_sysfs_create(struct umad2sim_dev *dev)
 
 	/* /sys/class/infiniband/mthca0/fw_ver */
 	file_printf(path, SYS_CA_FW_VERS, "%llx\n", sc->vendor.fw_ver);
-	//file_printf(path, SYS_CA_FW_VERS, "3.2.2\n");
 
 	/* /sys/class/infiniband/mthca0/hw_rev */
 	file_printf(path, SYS_CA_HW_VERS, "%x\n", sc->vendor.hw_ver);
@@ -239,137 +245,154 @@ static int dev_sysfs_create(struct umad2sim_dev *dev)
 	strncat(path, "/ports", sizeof(path) - 1);
 	make_path(path);
 
-	portinfo = sc->portinfo;
-
-	/* /sys/class/infiniband/mthca0/ports/1/ */
-	val = mad_get_field(portinfo, 0, IB_PORT_LOCAL_PORT_F);
-	snprintf(path + strlen(path), sizeof(path) - strlen(path), "/%u", val);
-	make_path(path);
-
-	/* /sys/class/infiniband/mthca0/ports/1/lid_mask_count */
-	val = mad_get_field(portinfo, 0, IB_PORT_LMC_F);
-	file_printf(path, SYS_PORT_LMC, "%d", val);
-
-	/* /sys/class/infiniband/mthca0/ports/1/sm_lid */
-	val = mad_get_field(portinfo, 0, IB_PORT_SMLID_F);
-	file_printf(path, SYS_PORT_SMLID, "0x%x", val);
-
-	/* /sys/class/infiniband/mthca0/ports/1/sm_sl */
-	val = mad_get_field(portinfo, 0, IB_PORT_SMSL_F);
-	file_printf(path, SYS_PORT_SMSL, "%d", val);
-
-	/* /sys/class/infiniband/mthca0/ports/1/lid */
-	val = mad_get_field(portinfo, 0, IB_PORT_LID_F);
-	file_printf(path, SYS_PORT_LID, "0x%x", val);
-
-	/* /sys/class/infiniband/mthca0/ports/1/state */
-	val = mad_get_field(portinfo, 0, IB_PORT_STATE_F);
-	if (val == 0)
-		str = "NOP";
-	else if (val == 1)
-		str = "DOWN";
-	else if (val == 2)
-		str = "INIT";
-	else if (val == 3)
-		str = "ARMED";
-	else if (val == 4)
-		str = "ACTIVE";
-	else if (val == 5)
-		str = "ACTIVE_DEFER";
-	else
-		str = "<unknown>";
-	file_printf(path, SYS_PORT_STATE, "%d: %s\n", val, str);
-
-	/* /sys/class/infiniband/mthca0/ports/1/phys_state */
-	val = mad_get_field(portinfo, 0, IB_PORT_PHYS_STATE_F);
-	if (val == 1)
-		str = "Sleep";
-	else if (val == 2)
-		str = "Polling";
-	else if (val == 3)
-		str = "Disabled";
-	else if (val == 4)
-		str = "PortConfigurationTraining";
-	else if (val == 5)
-		str = "LinkUp";
-	else if (val == 6)
-		str = "LinkErrorRecovery";
-	else if (val == 7)
-		str = "Phy Test";
-	else
-		str = "<unknown>";
-	file_printf(path, SYS_PORT_PHY_STATE, "%d: %s\n", val, str);
-
-	/* /sys/class/infiniband/mthca0/ports/1/rate */
-	val = mad_get_field(portinfo, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
-	speed = mad_get_field(portinfo, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
-	if (val == 1)
-		val = 1;
-	else if (val == 2)
-		val = 4;
-	else if (val == 4)
-		val = 8;
-	else if (val == 8)
-		val = 12;
-	else
-		val = 0;
-	if (speed == 2)
-		str = " DDR";
-	else if (speed == 4)
-		str = " QDR";
-	else
-		str = "";
-	file_printf(path, SYS_PORT_RATE, "%d%s Gb/sec (%dX%s)\n",
-		    (val * speed * 25) / 10,
-		    (val * speed * 25) % 10 ? ".5" : "", val, str);
-
-	/* /sys/class/infiniband/mthca0/ports/1/cap_mask */
-	val = mad_get_field(portinfo, 0, IB_PORT_CAPMASK_F);
-	file_printf(path, SYS_PORT_CAPMASK, "0x%08x", val);
-
-	/* /sys/class/infiniband/mthca0/ports/1/gids/0 */
-	str = path + strlen(path);
-	strncat(path, "/gids", sizeof(path) - 1);
-	make_path(path);
-	*str = '\0';
-	gid = mad_get_field64(portinfo, 0, IB_PORT_GID_PREFIX_F);
-	guid = mad_get_field64(sc->nodeinfo, 0, IB_NODE_GUID_F) +
-	    mad_get_field(portinfo, 0, IB_PORT_LOCAL_PORT_F);
-	file_printf(path, SYS_PORT_GID,
-		    "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
-		    (uint16_t) ((gid >> 48) & 0xffff),
-		    (uint16_t) ((gid >> 32) & 0xffff),
-		    (uint16_t) ((gid >> 16) & 0xffff),
-		    (uint16_t) ((gid >> 0) & 0xffff),
-		    (uint16_t) ((guid >> 48) & 0xffff),
-		    (uint16_t) ((guid >> 32) & 0xffff),
-		    (uint16_t) ((guid >> 16) & 0xffff),
-		    (uint16_t) ((guid >> 0) & 0xffff));
-
-	/* /sys/class/infiniband/mthca0/ports/1/pkeys/0 */
-	str = path + strlen(path);
-	strncat(path, "/pkeys", sizeof(path) - 1);
-	make_path(path);
-	for (i = 0; i < sizeof(sc->pkeys)/sizeof(sc->pkeys[0]); i++) {
-		char name[8];
-		snprintf(name, sizeof(name), "%u", i);
-		file_printf(path, name, "0x%04x\n", ntohs(sc->pkeys[i]));
+	numports = mad_get_field(sc->nodeinfo, 0, IB_NODE_NPORTS_F);
+	nodetype = mad_get_field(sc->nodeinfo, 0, IB_NODE_TYPE_F);
+	if (nodetype != IB_NODE_SWITCH) {
+		offset = 1;
+		endport = numports - 1;
+		if (endport > MAX_PORTS)
+			endport = MAX_PORTS;
 	}
-	*str = '\0';
 
-	/* /sys/class/infiniband_mad/umad0/ */
-	snprintf(path, sizeof(path), "%s/umad%u", sysfs_infiniband_mad_dir,
-		 dev->num);
-	make_path(path);
-	file_printf(path, SYS_IB_MAD_DEV, "%s\n", dev->name);
-	file_printf(path, SYS_IB_MAD_PORT, "%d\n", dev->port);
+	ports_path_end = path + strlen(path);
+	/* loop through end ports */
+	for (p = startport; p <= endport; p++) {
+		portnum = p + offset;
+		portinfo = sc->portinfo + 64 * portnum;
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/ */
+		snprintf(path + strlen(path), sizeof(path) - strlen(path), "/%u", portnum);
+		make_path(path);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/lid_mask_count */
+		val = mad_get_field(portinfo, 0, IB_PORT_LMC_F);
+		file_printf(path, SYS_PORT_LMC, "%d", val);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/sm_lid */
+		val = mad_get_field(portinfo, 0, IB_PORT_SMLID_F);
+		file_printf(path, SYS_PORT_SMLID, "0x%x", val);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/sm_sl */
+		val = mad_get_field(portinfo, 0, IB_PORT_SMSL_F);
+		file_printf(path, SYS_PORT_SMSL, "%d", val);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/lid */
+		val = mad_get_field(portinfo, 0, IB_PORT_LID_F);
+		file_printf(path, SYS_PORT_LID, "0x%x", val);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/state */
+		val = mad_get_field(portinfo, 0, IB_PORT_STATE_F);
+		if (val == 0)
+			str = "NOP";
+		else if (val == 1)
+			str = "DOWN";
+		else if (val == 2)
+			str = "INIT";
+		else if (val == 3)
+			str = "ARMED";
+		else if (val == 4)
+			str = "ACTIVE";
+		else if (val == 5)
+			str = "ACTIVE_DEFER";
+		else
+			str = "<unknown>";
+		file_printf(path, SYS_PORT_STATE, "%d: %s\n", val, str);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/phys_state */
+		val = mad_get_field(portinfo, 0, IB_PORT_PHYS_STATE_F);
+		if (val == 1)
+			str = "Sleep";
+		else if (val == 2)
+			str = "Polling";
+		else if (val == 3)
+			str = "Disabled";
+		else if (val == 4)
+			str = "PortConfigurationTraining";
+		else if (val == 5)
+			str = "LinkUp";
+		else if (val == 6)
+			str = "LinkErrorRecovery";
+		else if (val == 7)
+			str = "Phy Test";
+		else
+			str = "<unknown>";
+		file_printf(path, SYS_PORT_PHY_STATE, "%d: %s\n", val, str);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/rate */
+		val = mad_get_field(portinfo, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
+		speed = mad_get_field(portinfo, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+		if (val == 1)
+			val = 1;
+		else if (val == 2)
+			val = 4;
+		else if (val == 4)
+			val = 8;
+		else if (val == 8)
+			val = 12;
+		else
+			val = 0;
+		if (speed == 2)
+			str = " DDR";
+		else if (speed == 4)
+			str = " QDR";
+		else
+			str = "";
+		file_printf(path, SYS_PORT_RATE, "%d%s Gb/sec (%dX%s)\n",
+				(val * speed * 25) / 10,
+				(val * speed * 25) % 10 ? ".5" : "", val, str);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/cap_mask */
+		val = mad_get_field(portinfo, 0, IB_PORT_CAPMASK_F);
+		file_printf(path, SYS_PORT_CAPMASK, "0x%08x", val);
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/gids/0 */
+		str = path + strlen(path);
+		strncat(path, "/gids", sizeof(path) - 1);
+		make_path(path);
+		*str = '\0';
+		gid = mad_get_field64(portinfo, 0, IB_PORT_GID_PREFIX_F);
+		guid = mad_get_field64(sc->nodeinfo, 0, IB_NODE_GUID_F) + portnum;
+		file_printf(path, SYS_PORT_GID,
+				"%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
+				(uint16_t) ((gid >> 48) & 0xffff),
+				(uint16_t) ((gid >> 32) & 0xffff),
+				(uint16_t) ((gid >> 16) & 0xffff),
+				(uint16_t) ((gid >> 0) & 0xffff),
+				(uint16_t) ((guid >> 48) & 0xffff),
+				(uint16_t) ((guid >> 32) & 0xffff),
+				(uint16_t) ((guid >> 16) & 0xffff),
+				(uint16_t) ((guid >> 0) & 0xffff));
+
+		/* /sys/class/infiniband/mthca0/ports/<n>/pkeys/0 */
+		str = path + strlen(path);
+		strncat(path, "/pkeys", sizeof(path) - 1);
+		make_path(path);
+		pkeys = sc->pkeys + 64 * portnum;
+		for (i = 0; i < 32; i++) {
+			snprintf(name, sizeof(name), "%u", i);
+			file_printf(path, name, "0x%04x\n", ntohs(pkeys[i]));
+		}
+		*str = '\0';
+		*ports_path_end = '\0';
+	}
 
-	/* /sys/class/infiniband_mad/issm0/ */
-	snprintf(path, sizeof(path), "%s/issm%u", sysfs_infiniband_mad_dir,
-		 dev->num);
-	make_path(path);
-	file_printf(path, SYS_IB_MAD_DEV, "%s\n", dev->name);
-	file_printf(path, SYS_IB_MAD_PORT, "%d\n", dev->port);
+	for (p = startport; p <= endport; p++) {
+		portnum = p + offset;
+		/* /sys/class/infiniband_mad/umad<n>/ */
+		snprintf(path, sizeof(path), "%s/umad%u",
+				sysfs_infiniband_mad_dir, p);
+		make_path(path);
+		file_printf(path, SYS_IB_MAD_DEV, "%s\n", dev->name);
+		file_printf(path, SYS_IB_MAD_PORT, "%d\n", portnum);
+		dev->umadport[p] = portnum;
+
+		/* /sys/class/infiniband_mad/issm<n>/ */
+		snprintf(path, sizeof(path), "%s/issm%u",
+				sysfs_infiniband_mad_dir, p);
+		make_path(path);
+		file_printf(path, SYS_IB_MAD_DEV, "%s\n", dev->name);
+		file_printf(path, SYS_IB_MAD_PORT, "%d\n", portnum);
+	}
 
 	return 0;
 }
@@ -571,8 +594,6 @@ static struct umad2sim_dev *umad2sim_dev_create(unsigned num, const char *name)
 	if (sim_client_init(&dev->sim_client) < 0)
 		goto _error;
 
-	dev->port = mad_get_field(&dev->sim_client.portinfo, 0,
-				  IB_PORT_LOCAL_PORT_F);
 	for (i = 0; i < arrsize(dev->agents); i++)
 		dev->agents[i].id = (uint32_t)(-1);
 	for (i = 0; i < arrsize(dev->agent_idx); i++)
@@ -724,20 +745,24 @@ int scandir(const char *path, struct dirent ***namelist,
 	return real_scandir(path, namelist, filter, compar);
 }
 
+void __attribute__ ((constructor)) my_init(void)
+{
+	umad2sim_init();
+}
+
 int open(const char *path, int flags, ...)
 {
 	struct umad2sim_dev *dev;
 	va_list args;
 	mode_t mode = 0;
-	unsigned i;
+	char portno;
+	int offset;
+	int umadnum;
+	int portnum;
+	static char umad_dir[] = UMAD_DEV_DIR"/umad";
 
 	CHECK_INIT();
 
-	if (!umad2sim_initialized && (is_sysfs_file(path) ||
-				      !strncmp(path, umad_dev_dir,
-					       strlen(umad_dev_dir))))
-		umad2sim_init();
-
 	DEBUG("libs_wrap: open: %s...\n", path);
 
 	if (flags & O_CREAT) {
@@ -752,16 +777,25 @@ int open(const char *path, int flags, ...)
 		return real_open(new_path, flags, mode);
 	}
 
-	for (i = 0; i < arrsize(devices); i++) {
-		if (!(dev = devices[i]))
-			continue;
-		if (!strncmp(path, dev->umad_path, sizeof(dev->umad_path))) {
-			return 1024 + i;
-		}
-		if (!strncmp(path, dev->issm_path, sizeof(dev->issm_path))) {
-			sim_client_set_sm(&dev->sim_client, 1);
-			return 2048 + i;
-		}
+	dev = devices[0];
+	offset = strlen(umad_dir);
+	if (!strncmp(path, umad_dir, offset)) {
+		strcpy(&portno, path + offset);
+		/* update portnum */
+		umadnum = atoi(&portno);
+		portnum = dev->umadport[umadnum];
+		sim_ctl(&dev->sim_client, SIM_CTL_SET_PORT, &portnum, sizeof(portnum));
+
+		snprintf(dev->umad_path, sizeof(dev->umad_path), "%s/%s%u",
+				 umad_dev_dir, "umad", umadnum);
+		snprintf(dev->issm_path, sizeof(dev->issm_path), "%s/%s%u",
+			 umad_dev_dir, "issm", umadnum);
+	}
+	if (!strncmp(path, dev->umad_path, sizeof(dev->umad_path)))
+		return 1024;
+	if (!strncmp(path, dev->issm_path, sizeof(dev->issm_path))) {
+		sim_client_set_sm(&dev->sim_client, 1);
+		return 2048;
 	}
 
 	return real_open(path, flags, mode);
-- 
1.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
