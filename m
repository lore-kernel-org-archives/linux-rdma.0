From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/6] Update C7 build instructions to use ninja from EPEL
Date: Wed, 23 Nov 2016 16:34:59 -0700
Message-ID: <1479944104-19949-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479944104-19949-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This made it into EPEL recently, refer people to that build.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 README.md | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/README.md b/README.md
index 1f6e20170e5ade..9c69bb545c0596 100644
--- a/README.md
+++ b/README.md
@@ -59,7 +59,7 @@ $ apt-get install build-essential cmake gcc libudev-dev libnl-3-dev libnl-route-
 $ dnf install cmake gcc libnl3-devel libudev-devel pkgconfig valgrind-devel ninja-build
 ```
 
-NOTE: Fedora Core uses the name 'ninja-build' for the ninja command.
+NOTE: Fedora Core uses the name 'ninja-build' for the 'ninja' command.
 
 ### OpenSuSE
 
@@ -75,16 +75,17 @@ Install required packages:
 $ yum install cmake gcc libnl3-devel libudev-devel make pkgconfig valgrind-devel
 ```
 
-Developers are suggested to install more modern tooling for the best experience.
+Developers on CentOS 7 are suggested to install more modern tooling for the
+best experience.
 
 ```sh
 $ yum install epel-release
-$ yum install cmake3 unzip
-$ curl -OL https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip
-$ unzip ninja-linux.zip
-$ install -m755 ninja /usr/local/bin/ninja
+$ yum install cmake3 unzip ninja-build
 ```
 
+NOTE: EPEL uses the name 'ninja-build' for the 'ninja' command, and 'cmake3'
+for the 'cmake' command.
+
 # Reporting bugs
 
 Bugs should be reported to the <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> mailing list
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
