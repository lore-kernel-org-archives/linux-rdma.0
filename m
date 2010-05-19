From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/9] dapl-2.0: scm: add option to use other network devices
 with environment variable DAPL_SCM_NETDEV
Date: Wed, 19 May 2010 11:25:23 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130E0@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New environment variable can be used to set the netdev
for sockets to use instead of the default network device
returned using gethostname.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/device.c            |  152 +++++++++--------------------------
 dapl/openib_common/dapl_ib_common.h |    3 +-
 dapl/openib_common/util.c           |  101 +++++++++++++++++++++++-
 dapl/openib_scm/device.c            |    2 +-
 4 files changed, 141 insertions(+), 117 deletions(-)

diff --git a/dapl/openib_cma/device.c b/dapl/openib_cma/device.c
index 12593cf..c9fc8c3 100644
--- a/dapl/openib_cma/device.c
+++ b/dapl/openib_cma/device.c
@@ -59,46 +59,6 @@ struct dapl_llist_entry *g_hca_list;
 
 static COMP_SET ufds;
 
-static int getipaddr_netdev(char *name, char *addr, int addr_len)
-{
-	IWVProvider *prov;
-	WV_DEVICE_ADDRESS devaddr;
-	struct addrinfo *res, *ai;
-	HRESULT hr;
-	int index;
-
-	if (strncmp(name, "rdma_dev", 8)) {
-		return EINVAL;
-	}
-
-	index = atoi(name + 8);
-
-	hr = WvGetObject(&IID_IWVProvider, (LPVOID *) &prov);
-	if (FAILED(hr)) {
-		return hr;
-	}
-
-	hr = getaddrinfo("..localmachine", NULL, NULL, &res);
-	if (hr) {
-		goto release;
-	}
-
-	for (ai = res; ai; ai = ai->ai_next) {
-		hr = prov->lpVtbl->TranslateAddress(prov, ai->ai_addr, &devaddr);
-		if (SUCCEEDED(hr) && (ai->ai_addrlen <= addr_len) && (index-- == 0)) {
-			memcpy(addr, ai->ai_addr, ai->ai_addrlen);
-			goto free;
-		}
-	}
-	hr = ENODEV;
-
-free:
-	freeaddrinfo(res);
-release:
-	prov->lpVtbl->Release(prov);
-	return hr;
-}
-
 static int dapls_os_init(void)
 {
 	return CompSetInit(&ufds);
@@ -133,6 +93,7 @@ static int dapls_thread_signal(void)
 	return 0;
 }
 #else				// _WIN64 || WIN32
+
 int g_ib_pipe[2];
 
 static int dapls_os_init(void)
@@ -146,43 +107,6 @@ static void dapls_os_release(void)
 	/* close pipe? */
 }
 
-/* Get IP address using network device name */
-static int getipaddr_netdev(char *name, char *addr, int addr_len)
-{
-	struct ifreq ifr;
-	int skfd, ret, len;
-
-	/* Fill in the structure */
-	snprintf(ifr.ifr_name, IFNAMSIZ, "%s", name);
-	ifr.ifr_hwaddr.sa_family = ARPHRD_INFINIBAND;
-
-	/* Create a socket fd */
-	skfd = socket(PF_INET, SOCK_STREAM, 0);
-	ret = ioctl(skfd, SIOCGIFADDR, &ifr);
-	if (ret)
-		goto bail;
-
-	switch (ifr.ifr_addr.sa_family) {
-#ifdef	AF_INET6
-	case AF_INET6:
-		len = sizeof(struct sockaddr_in6);
-		break;
-#endif
-	case AF_INET:
-	default:
-		len = sizeof(struct sockaddr);
-		break;
-	}
-
-	if (len <= addr_len)
-		memcpy(addr, &ifr.ifr_addr, len);
-	else
-		ret = EINVAL;
-
-      bail:
-	close(skfd);
-	return ret;
-}
 
 static int dapls_config_fd(int fd)
 {
@@ -220,43 +144,43 @@ static int dapls_thread_signal(void)
 }
 #endif
 
-/* Get IP address using network name, address, or device name */
-static int getipaddr(char *name, char *addr, int len)
-{
-	struct addrinfo *res;
-
-	/* assume netdev for first attempt, then network and address type */
-	if (getipaddr_netdev(name, addr, len)) {
-		if (getaddrinfo(name, NULL, NULL, &res)) {
-			dapl_log(DAPL_DBG_TYPE_ERR,
-				 " open_hca: getaddr_netdev ERROR:"
-				 " %s. Is %s configured?\n",
-				 strerror(errno), name);
-			return 1;
-		} else {
-			if (len >= res->ai_addrlen)
-				memcpy(addr, res->ai_addr, res->ai_addrlen);
-			else {
-				freeaddrinfo(res);
-				return 1;
-			}
-			freeaddrinfo(res);
-		}
-	}
-
-	dapl_dbg_log(
-		DAPL_DBG_TYPE_UTIL,
-		" getipaddr: family %d port %d addr %d.%d.%d.%d\n",
-		((struct sockaddr_in *)addr)->sin_family,
-		((struct sockaddr_in *)addr)->sin_port,
-		((struct sockaddr_in *)addr)->sin_addr.s_addr >> 0 & 0xff,
-		((struct sockaddr_in *)addr)->sin_addr.s_addr >> 8 & 0xff,
-		((struct sockaddr_in *)addr)->sin_addr.s_addr >> 16 & 0xff,
-		((struct sockaddr_in *)addr)->sin_addr.
-		 s_addr >> 24 & 0xff);
-
-	return 0;
-}
+/* Get IP address using network name, address, or device name */
+static int getipaddr(char *name, char *addr, int len)
+{
+        struct addrinfo *res;
+
+        /* assume netdev for first attempt, then network and address type */
+        if (getipaddr_netdev(name, addr, len)) {
+                if (getaddrinfo(name, NULL, NULL, &res)) {
+                        dapl_log(DAPL_DBG_TYPE_ERR,
+                                 " open_hca: getaddr_netdev ERROR:"
+                                 " %s. Is %s configured?\n",
+                                 strerror(errno), name);
+                        return 1;
+                } else {
+                        if (len >= res->ai_addrlen)
+                                memcpy(addr, res->ai_addr, res->ai_addrlen);
+                        else {
+                                freeaddrinfo(res);
+                                return 1;
+                        }
+                        freeaddrinfo(res);
+                }
+        }
+
+        dapl_dbg_log(
+                DAPL_DBG_TYPE_UTIL,
+                " getipaddr: family %d port %d addr %d.%d.%d.%d\n",
+                ((struct sockaddr_in *)addr)->sin_family,
+                ((struct sockaddr_in *)addr)->sin_port,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 0 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 8 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 16 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.
+                 s_addr >> 24 & 0xff);
+
+        return 0;
+}
 
 /*
  * dapls_ib_init, dapls_ib_release
diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index cc416d2..d3cf2e0 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -299,7 +299,8 @@ int32_t	dapls_ib_release(void);
 /* util.c */
 enum ibv_mtu dapl_ib_mtu(int mtu);
 char *dapl_ib_mtu_str(enum ibv_mtu mtu);
-DAT_RETURN getlocalipaddr(DAT_SOCK_ADDR *addr, int addr_len);
+int getipaddr_netdev(char *name, char *addr, int addr_len);
+DAT_RETURN getlocalipaddr(char *addr, int addr_len);
 
 /* qp.c */
 DAT_RETURN dapls_modify_qp_ud(IN DAPL_HCA *hca, IN ib_qp_handle_t qp);
diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index 704d85a..dd1454e 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -31,6 +31,91 @@
 
 int g_dapl_loopback_connection = 0;
 
+#if defined(_WIN64) || defined(_WIN32)
+#include "..\..\..\..\..\etc\user\comp_channel.cpp"
+#include <rdma\winverbs.h>
+
+int getipaddr_netdev(char *name, char *addr, int addr_len)
+{
+	IWVProvider *prov;
+	WV_DEVICE_ADDRESS devaddr;
+	struct addrinfo *res, *ai;
+	HRESULT hr;
+	int index;
+
+	if (strncmp(name, "rdma_dev", 8)) {
+		return EINVAL;
+	}
+
+	index = atoi(name + 8);
+
+	hr = WvGetObject(&IID_IWVProvider, (LPVOID *) &prov);
+	if (FAILED(hr)) {
+		return hr;
+	}
+
+	hr = getaddrinfo("..localmachine", NULL, NULL, &res);
+	if (hr) {
+		goto release;
+	}
+
+	for (ai = res; ai; ai = ai->ai_next) {
+		hr = prov->lpVtbl->TranslateAddress(prov, ai->ai_addr, &devaddr);
+		if (SUCCEEDED(hr) && (ai->ai_addrlen <= addr_len) && (index-- == 0)) {
+			memcpy(addr, ai->ai_addr, ai->ai_addrlen);
+			goto free;
+		}
+	}
+	hr = ENODEV;
+
+free:
+	freeaddrinfo(res);
+release:
+	prov->lpVtbl->Release(prov);
+	return hr;
+}
+
+#else				// _WIN64 || WIN32
+
+/* Get IP address using network device name */
+int getipaddr_netdev(char *name, char *addr, int addr_len)
+{
+	struct ifreq ifr;
+	int skfd, ret, len;
+
+	/* Fill in the structure */
+	snprintf(ifr.ifr_name, IFNAMSIZ, "%s", name);
+	ifr.ifr_hwaddr.sa_family = ARPHRD_INFINIBAND;
+
+	/* Create a socket fd */
+	skfd = socket(PF_INET, SOCK_STREAM, 0);
+	ret = ioctl(skfd, SIOCGIFADDR, &ifr);
+	if (ret)
+		goto bail;
+
+	switch (ifr.ifr_addr.sa_family) {
+#ifdef	AF_INET6
+	case AF_INET6:
+		len = sizeof(struct sockaddr_in6);
+		break;
+#endif
+	case AF_INET:
+	default:
+		len = sizeof(struct sockaddr);
+		break;
+	}
+
+	if (len <= addr_len)
+		memcpy(addr, &ifr.ifr_addr, len);
+	else
+		ret = EINVAL;
+
+      bail:
+	close(skfd);
+	return ret;
+}
+#endif
+
 enum ibv_mtu dapl_ib_mtu(int mtu)
 {
 	switch (mtu) {
@@ -67,12 +152,26 @@ char *dapl_ib_mtu_str(enum ibv_mtu mtu)
 	}
 }
 
-DAT_RETURN getlocalipaddr(DAT_SOCK_ADDR * addr, int addr_len)
+DAT_RETURN getlocalipaddr(char *addr, int addr_len)
 {
 	struct sockaddr_in *sin;
 	struct addrinfo *res, hint, *ai;
 	int ret;
 	char hostname[256];
+	char *netdev = getenv("DAPL_SCM_NETDEV");
+
+	/* use provided netdev instead of default hostname */
+	if (netdev != NULL) {
+		ret = getipaddr_netdev(netdev, addr, addr_len);
+		if (ret) {			
+			dapl_log(DAPL_DBG_TYPE_ERR,
+				 " getlocalipaddr: DAPL_SCM_NETDEV provided %s"
+				" but not configured on system? ERR = %s\n",
+				netdev, strerror(ret));
+			return dapl_convert_errno(ret, "getlocalipaddr");
+		} else 
+			return DAT_SUCCESS;
+	}
 
 	if (addr_len < sizeof(*sin)) {
 		return DAT_INTERNAL_ERROR;
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index eb87a85..03d38a6 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -263,7 +263,7 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name, IN DAPL_HCA * hca_ptr)
 		     " open_hca: %s - %p\n", hca_name, hca_ptr);
 
 	/* get the IP address of the device */
-	dat_status = getlocalipaddr((DAT_SOCK_ADDR *) &hca_ptr->hca_address,
+	dat_status = getlocalipaddr((char *)&hca_ptr->hca_address,
 				    sizeof(DAT_SOCK_ADDR6));
 	if (dat_status != DAT_SUCCESS)
 		return dat_status;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
