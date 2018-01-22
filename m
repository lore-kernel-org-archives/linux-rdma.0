From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 03:24:15 -0800
Message-ID: <20180122112415.GA41074@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Honggang Li <honli@redhat.com>, linux-kernel@vger.kernel.org, Sowmini Varadhan <sowmini.varadhan@oracle.com>, Steve Beattie <sbeattie@ubuntu.com>, Andy Whitcroft <apw@canonical.com>, "David S. Miller" <davem@davemloft.net>, Jay Fenlason <fenlason@redhat.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

As described in: https://bugzilla.redhat.com/show_bug.cgi?id=822754

Attempting an RDS connection from the IP address of an IPoIB interface
to itself causes a kernel panic due to a BUG_ON() being triggered.
Making the test less strict allows rds-ping to work without crashing
the machine.

A local unprivileged user could use this flaw to crash the sytem.

I think this fix was written by Jay Fenlason <fenlason@redhat.com>,
and extracted from the RedHat kernel patches here:

https://oss.oracle.com/git/gitweb.cgi?p=redpatch.git;a=commitdiff;h=c7b6a0a1d8d636852be130fa15fa8be10d4704e8

This fix appears to have been carried by at least RedHat, Oracle, and
Ubuntu for several years.

CVE-2012-2372

Reported-by: Honggang Li <honli@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is what I get for researching CVE lifetimes...
---
 net/rds/ib_send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 8557a1cae041..5fbf635d17cb 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -506,7 +506,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	int flow_controlled = 0;
 	int nr_sig = 0;
 
-	BUG_ON(off % RDS_FRAG_SIZE);
+	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
 	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
 
 	/* Do not send cong updates to IB loopback */
-- 
2.7.4


-- 
Kees Cook
Pixel Security
