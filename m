From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v2 2/2] uapi: update if_link.h
Date: Thu, 20 Jun 2019 11:02:49 +0200
Message-ID: <20190620090249.106704-2-dkirjanov@suse.com>
References: <20190620090249.106704-1-dkirjanov@suse.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190620090249.106704-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
List-Id: linux-rdma@vger.kernel.org

update if_link.h to commit 75345f888f700c4ab2448287e35d48c760b202e6
("ipoib: show VF broadcast address")

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_link.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bfe7f9e6..5f271d84 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -692,6 +692,7 @@ enum {
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,      /* VF broadcast */
 	__IFLA_VF_MAX,
 };
 
@@ -702,6 +703,10 @@ struct ifla_vf_mac {
 	__u8 mac[32]; /* MAX_ADDR_LEN */
 };
 
+struct ifla_vf_broadcast {
+	__u8 broadcast[32];
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
-- 
2.12.3
