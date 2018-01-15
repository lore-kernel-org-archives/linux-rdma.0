From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 2/3] travis: Do not loose ninja output if ninja fails during sparse
Date: Mon, 15 Jan 2018 14:13:46 -0700
Message-ID: <20180115211347.5651-3-jgg@ziepe.ca>
References: <20180115211347.5651-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115211347.5651-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It turns out that cgcc is an older version of gcc on travis
and can produce warnings that the prior gcc runs didn't, but
due to how the output is filtered the messages are discarded
totally.

Ensure any output from ninja that is not a progress print is
displayed.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/travis-build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/buildlib/travis-build b/buildlib/travis-build
index bf86baa7432c6b..0efcbc60d18be5 100755
--- a/buildlib/travis-build
+++ b/buildlib/travis-build
@@ -30,9 +30,9 @@ cd ../build-sparse
 mv ../CMakeLists.txt ../CMakeLists-orig.txt
 grep -v "# NO SPARSE" ../CMakeLists-orig.txt > ../CMakeLists.txt
 CC=cgcc CFLAGS="-Werror" cmake -GNinja ..
-ninja > out
+ninja | grep -v '^\[' | tee out
 # sparse does not fail gcc on messages
-if grep -v '^\[' out; then
+if [ -s out ]; then
    false
 fi
 mv ../CMakeLists-orig.txt ../CMakeLists.txt
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
