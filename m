From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 4/4] buidlib: validate tumbleweed instead of leap
 42.3
Date: Wed, 8 Nov 2017 15:31:32 +0100
Message-ID: <d4f0997f-8883-b217-7455-a2db07373193@suse.de>
References: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/package-build-test | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/buildlib/package-build-test b/buildlib/package-build-test
index d5fcdd9c..15f24caa 100755
--- a/buildlib/package-build-test
+++ b/buildlib/package-build-test
@@ -11,7 +11,7 @@ if [ -e "/.dockerenv" ] || (grep -q docker /proc/self/cgroup &>/dev/null); then
        exit 0
 fi
 
-for OS in centos7 opensuse-42.3
+for OS in centos7 tumbleweed
 do
 	echo
 	echo "Checking package build for ${OS} ...."
-- 
2.14.1.461.g503560879

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
