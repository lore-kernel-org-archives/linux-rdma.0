From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/6] Fix RPM building on FC24
Date: Wed, 23 Nov 2016 16:35:01 -0700
Message-ID: <1479944104-19949-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479944104-19949-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ninja on RedHat distros is spelled 'ninja-build' for some reason. Missed
two places.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-core.spec        | 2 +-
 redhat/rdma-core.spec | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/rdma-core.spec b/rdma-core.spec
index 41ec47e9f86425..2c595a1da07d02 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -37,7 +37,7 @@ BuildRequires: ninja,make
 # Ninja was introduced in FC23
 BuildRequires: ninja-build
 %define CMAKE_FLAGS -GNinja
-%define make_jobs ninja -v %{?_smp_mflags}
+%define make_jobs ninja-build -v %{?_smp_mflags}
 %define cmake_install DESTDIR=%{buildroot} ninja-build install
 %else
 # Fallback to make otherwise
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 39267be2033abc..801bb9410346db 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -31,7 +31,7 @@ Obsoletes: rdma < %{version}-%{release}
 # Ninja was introduced in FC23
 BuildRequires: ninja-build
 %define CMAKE_FLAGS -GNinja
-%define make_jobs ninja -v %{?_smp_mflags}
+%define make_jobs ninja-build -v %{?_smp_mflags}
 %define cmake_install DESTDIR=%{buildroot} ninja-build install
 %else
 # Fallback to make otherwise
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
