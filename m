From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 04/15 ibacm] ibacm*.cfg: Change DOS formatting to unix formatting
Date: Fri, 21 Jun 2013 07:01:31 -0400
Message-ID: <51C4328B.4030906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm_addr.cfg |   46 +++++-----
 ibacm_opts.cfg |  260 ++++++++++++++++++++++++++++----------------------------
 2 files changed, 153 insertions(+), 153 deletions(-)

diff --git a/ibacm_addr.cfg b/ibacm_addr.cfg
index cfb17de..dd2bd6e 100644
--- a/ibacm_addr.cfg
+++ b/ibacm_addr.cfg
@@ -1,24 +1,24 @@
-# InfiniBand Communication Management Assistant for clusters address file
-#
-# Use ib_acme utility with -G option to automatically generate a sample
-# acm_addr.cfg file for the current system.
-#
-# Entry format is:
-# address device port pkey
-#
-# The address may be one of the following:
-# host_name - ascii character string, up to 31 characters
-# address - IPv4 or IPv6 formatted address
-#
-# device name - struct ibv_device name
-# port number - valid port number on device (numbering starts at 1)
-# pkey - partition key in hex (can specify 'default' for pkey 0xFFFF)
-#
-# Up to 4 addresses can be associated with a given <device, port, pkey> tuple
-#
-# Samples:
-# node31      ibv_device0 1 default
-# node31-1    ibv_device0 1 0x00FF
-# node31-2    ibv_device0 2 0x00FF
-# 192.168.0.1 ibv_device0 1 0xFFFF
+# InfiniBand Communication Management Assistant for clusters address file
+#
+# Use ib_acme utility with -G option to automatically generate a sample
+# acm_addr.cfg file for the current system.
+#
+# Entry format is:
+# address device port pkey
+#
+# The address may be one of the following:
+# host_name - ascii character string, up to 31 characters
+# address - IPv4 or IPv6 formatted address
+#
+# device name - struct ibv_device name
+# port number - valid port number on device (numbering starts at 1)
+# pkey - partition key in hex (can specify 'default' for pkey 0xFFFF)
+#
+# Up to 4 addresses can be associated with a given <device, port, pkey> tuple
+#
+# Samples:
+# node31      ibv_device0 1 default
+# node31-1    ibv_device0 1 0x00FF
+# node31-2    ibv_device0 2 0x00FF
+# 192.168.0.1 ibv_device0 1 0xFFFF
 # 192.168.0.2 ibv_device0 2 default
\ No newline at end of file
diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index c078aee..dc9823e 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -1,130 +1,130 @@
-# InfiniBand Multicast Communication Manager for clusters configuration file
-#
-# Use ib_acme utility with -O option to automatically generate a sample
-# acm_opts.cfg file for the current system.
-#
-# Entry format is:
-# name value
-
-# log_file:
-# Specifies the location of the ACM service output.  The log file is used to
-# assist with ACM service debugging and troubleshooting.  The log_file can
-# be set to 'stdout', 'stderr', or the name of a file.
-# Examples:
-# log_file stdout
-# log_file stderr
-# log_file /var/log/ibacm.log
-
-log_file /var/log/ibacm.log
-
-# log_level:
-# Indicates the amount of detailed data written to the log file.  Log levels
-# should be one of the following values:
-# 0 - basic configuration & errors
-# 1 - verbose configuration & errors
-# 2 - verbose operation
-
-log_level 0
-
-# lock_file:
-# Specifies the location of the ACM lock file used to ensure that only a
-# single instance of ACM is running.
-
-lock_file /var/lock/ibacm.pid
-
-# addr_prot:
-# Default resolution protocol to resolve IP addresses into IB GIDs.
-# Supported protocols are:
-# acm - Use ACM multicast protocol, which is similar to ARP.
-
-addr_prot acm
-
-# route_prot:
-# Default resolution protocol to resolve IB routing information.
-# Supported protocols are:
-# sa - Query SA for path record data and cache results.
-# acm - Use ACM multicast protocol.
-
-route_prot sa
-
-# loopback_prot:
-# Address and route resolution protocol to resolve local addresses
-# Supported protocols are:
-# none - Use same protocols defined for addr_prot and route_prot
-# local - Resolve information used locally available data
-
-loopback_prot local
-
-# server_port:
-# TCP port number that the server listens on.
-# If this value is changed, then a corresponding change is required for
-# client applications.
-
-server_port 6125
-
-# timeout:
-# Additional time, in milliseconds, that the ACM service will wait for a
-# response from a remote ACM service or the IB SA.  The actual request
-# timeout is this value plus the subnet timeout.
-
-timeout 2000
-
-# retries:
-# Number of times that the ACM service will retry a request.  This affects
-# both ACM multicast messages and and IB SA messages.
-
-retries 2
-
-# resolve_depth:
-# Specifies the maximum number of outstanding requests that can be in
-# progress simultaneously.  A larger resolve depth allows for greater
-# parallelism, but increases system resource usage and subnet load.
-# If the number of pending requests is greater than the resolve_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.
-
-resolve_depth 1
-
-# sa_depth:
-# Specifies the maximum number of outstanding requests to the SA that
-# can be in progress simultaneously.  A larger SA depth allows for greater
-# parallelism, but increases system resource usage and SA load.
-# If the number of pending SA requests is greater than the sa_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.  The number of outstanding SA requests
-# is separate from the specified resolve_depth.
-
-sa_depth 1
-
-# send_depth:
-# Specifies the maximum number of outstanding requests that can be in
-# progress simultaneously.  A larger send depth allows for greater
-# parallelism, but increases system resource usage and subnet load.
-# If the number of pending requests is greater than the send_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.
-
-send_depth 1
-
-# recv_depth:
-# Specifies the number of buffers allocated and ready to receive remote
-# requests.  A larger receive depth consumes more system resources, but
-# can avoid dropping requests due to insufficient receive buffers.
-
-recv_depth 1024
-
-# min_mtu:
-# Indicates the minimum MTU supported by the ACM service.  The ACM service
-# negotiates to use the largest MTU available between both sides of a
-# connection.  It is most efficient and recommended that min_mtu be set
-# to the largest MTU value supported by all nodes in a cluster.
-
-min_mtu 2048
-
-# min_rate:
-# Indicates the minimum link rate, in Gbps, supported by the ACM service.
-# The ACM service negotiates to use the highest rate available between both
-# sides of a connection.  It is most efficient and recommended that the
-# min_rate be set to the largest rate supported by all nodes in a cluster.
-
-min_rate 10
+# InfiniBand Multicast Communication Manager for clusters configuration file
+#
+# Use ib_acme utility with -O option to automatically generate a sample
+# acm_opts.cfg file for the current system.
+#
+# Entry format is:
+# name value
+
+# log_file:
+# Specifies the location of the ACM service output.  The log file is used to
+# assist with ACM service debugging and troubleshooting.  The log_file can
+# be set to 'stdout', 'stderr', or the name of a file.
+# Examples:
+# log_file stdout
+# log_file stderr
+# log_file /var/log/ibacm.log
+
+log_file /var/log/ibacm.log
+
+# log_level:
+# Indicates the amount of detailed data written to the log file.  Log levels
+# should be one of the following values:
+# 0 - basic configuration & errors
+# 1 - verbose configuration & errors
+# 2 - verbose operation
+
+log_level 0
+
+# lock_file:
+# Specifies the location of the ACM lock file used to ensure that only a
+# single instance of ACM is running.
+
+lock_file /var/lock/ibacm.pid
+
+# addr_prot:
+# Default resolution protocol to resolve IP addresses into IB GIDs.
+# Supported protocols are:
+# acm - Use ACM multicast protocol, which is similar to ARP.
+
+addr_prot acm
+
+# route_prot:
+# Default resolution protocol to resolve IB routing information.
+# Supported protocols are:
+# sa - Query SA for path record data and cache results.
+# acm - Use ACM multicast protocol.
+
+route_prot sa
+
+# loopback_prot:
+# Address and route resolution protocol to resolve local addresses
+# Supported protocols are:
+# none - Use same protocols defined for addr_prot and route_prot
+# local - Resolve information used locally available data
+
+loopback_prot local
+
+# server_port:
+# TCP port number that the server listens on.
+# If this value is changed, then a corresponding change is required for
+# client applications.
+
+server_port 6125
+
+# timeout:
+# Additional time, in milliseconds, that the ACM service will wait for a
+# response from a remote ACM service or the IB SA.  The actual request
+# timeout is this value plus the subnet timeout.
+
+timeout 2000
+
+# retries:
+# Number of times that the ACM service will retry a request.  This affects
+# both ACM multicast messages and and IB SA messages.
+
+retries 2
+
+# resolve_depth:
+# Specifies the maximum number of outstanding requests that can be in
+# progress simultaneously.  A larger resolve depth allows for greater
+# parallelism, but increases system resource usage and subnet load.
+# If the number of pending requests is greater than the resolve_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.
+
+resolve_depth 1
+
+# sa_depth:
+# Specifies the maximum number of outstanding requests to the SA that
+# can be in progress simultaneously.  A larger SA depth allows for greater
+# parallelism, but increases system resource usage and SA load.
+# If the number of pending SA requests is greater than the sa_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.  The number of outstanding SA requests
+# is separate from the specified resolve_depth.
+
+sa_depth 1
+
+# send_depth:
+# Specifies the maximum number of outstanding requests that can be in
+# progress simultaneously.  A larger send depth allows for greater
+# parallelism, but increases system resource usage and subnet load.
+# If the number of pending requests is greater than the send_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.
+
+send_depth 1
+
+# recv_depth:
+# Specifies the number of buffers allocated and ready to receive remote
+# requests.  A larger receive depth consumes more system resources, but
+# can avoid dropping requests due to insufficient receive buffers.
+
+recv_depth 1024
+
+# min_mtu:
+# Indicates the minimum MTU supported by the ACM service.  The ACM service
+# negotiates to use the largest MTU available between both sides of a
+# connection.  It is most efficient and recommended that min_mtu be set
+# to the largest MTU value supported by all nodes in a cluster.
+
+min_mtu 2048
+
+# min_rate:
+# Indicates the minimum link rate, in Gbps, supported by the ACM service.
+# The ACM service negotiates to use the highest rate available between both
+# sides of a connection.  It is most efficient and recommended that the
+# min_rate be set to the largest rate supported by all nodes in a cluster.
+
+min_rate 10
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
