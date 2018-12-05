From: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 8/8] selftests: mlxsw: Add a new test
	extack.sh
Date: Wed, 5 Dec 2018 10:52:05 +0000
Message-ID: <f3977aef9b33d590d3254d5850ea25e9bbeab170.1544006963.git.petrm@mellanox.com>
References: <cover.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <cover.1544006963.git.petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org" <linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, "linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org" <dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "_govind-KK0ffGbhmjU@public.gmane.org" <_govind-KK0ffGbhmjU@public.gmane.org>, "dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org" <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>, "ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org" <ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>, kys <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org" <andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org>, "johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ioana.ciornei-3arQi8VN3Tc@public.gmane.org" <ioana.ciornei-3arQi8VN3Tc@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org" <ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org>, "jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, marcel@holtma
List-Id: linux-rdma@vger.kernel.org

Add a testsuite dedicated to testing extack propagation and related
functionality.

Signed-off-by: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Ido Schimmel <idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../testing/selftests/drivers/net/mlxsw/extack.sh  | 84 ++++++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/extack.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/extack.sh b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
new file mode 100755
index 000000000000..101a5508bdfd
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
@@ -0,0 +1,84 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test operations that we expect to report extended ack.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	netdev_pre_up_test
+"
+NUM_NETIFS=2
+source $lib_dir/lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+netdev_pre_up_test()
+{
+	RET=0
+
+	ip link add name br1 up type bridge vlan_filtering 0 mcast_snooping 0
+	ip link add name vx1 up type vxlan id 1000 \
+		local 192.0.2.17 remote 192.0.2.18 \
+		dstport 4789 nolearning noudpcsum tos inherit ttl 100
+
+	ip link set dev vx1 master br1
+	check_err $?
+
+	ip link set dev $swp1 master br1
+	check_err $?
+
+	ip link add name br2 up type bridge vlan_filtering 0 mcast_snooping 0
+	ip link add name vx2 up type vxlan id 2000 \
+		local 192.0.2.17 remote 192.0.2.18 \
+		dstport 4789 nolearning noudpcsum tos inherit ttl 100
+
+	ip link set dev vx2 master br2
+	check_err $?
+
+	ip link set dev $swp2 master br2
+	check_err $?
+
+	# Unsupported configuration: mlxsw demands that all offloaded VXLAN
+	# devices have the same TTL.
+	ip link set dev vx2 down
+	ip link set dev vx2 type vxlan ttl 200
+
+	ip link set dev vx2 up &>/dev/null
+	check_fail $?
+
+	ip link set dev vx2 up 2>&1 >/dev/null | grep -q mlxsw_spectrum
+	check_err $?
+
+	log_test "extack - NETDEV_PRE_UP"
+
+	ip link del dev vx2
+	ip link del dev br2
+
+	ip link del dev vx1
+	ip link del dev br1
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.4.11
