From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core 3/5] redhat: fix typo in librdacm package
 description
Date: Fri, 25 Aug 2017 12:40:09 +0200
Message-ID: <662abf0c-736c-7b21-5141-7667203c67ce@suse.de>
References: <88926674-d707-6f00-e9a1-e2a823fec323@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88926674-d707-6f00-e9a1-e2a823fec323-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 redhat/rdma-core.spec | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index ca11f663..cc0c3ba0 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -183,7 +183,7 @@ Summary: Userspace RDMA Connection Manager
 Requires: %{name}%{?_isa} = %{version}-%{release}
 
 %description -n librdmacm
-librdmacm provides a userspace RDMA Communication Managment API.
+librdmacm provides a userspace RDMA Communication Management API.
 
 %package -n librdmacm-utils
 Summary: Examples for the librdmacm library
-- 
2.14.1.252.gf15771ee3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
