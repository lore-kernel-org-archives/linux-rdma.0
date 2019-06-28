From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 35/39] docs: infiniband: add it to the driver-api bookset
Date: Fri, 28 Jun 2019 09:30:28 -0300
Message-ID: <12743088687a9b0b305c05b62a5093056a4190b8.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1561724493.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

While this contains some uAPI stuff, it was intended to be
read by a kernel doc. So, let's not move it to a different
dir, but, instead, just add it to the driver-api bookset.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/index.rst            | 1 +
 Documentation/infiniband/index.rst | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index ea33cbbccd9d..e69d2fde7735 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -96,6 +96,7 @@ needed).
    block/index
    hid/index
    iio/index
+   infiniband/index
    leds/index
    media/index
    networking/index
diff --git a/Documentation/infiniband/index.rst b/Documentation/infiniband/index.rst
index 22eea64de722..9cd7615438b9 100644
--- a/Documentation/infiniband/index.rst
+++ b/Documentation/infiniband/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ==========
 InfiniBand
-- 
2.21.0
