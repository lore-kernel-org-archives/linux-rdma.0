From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH,RFC] nfsd: Make INET6 transport creation failure an informational
 message
Date: Thu, 01 Apr 2010 14:12:56 -0500
Message-ID: <4BB4F038.50906@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If this looks right to everyone, I'll post this to linux-nfs.

Tom

nfsd: Make INET6 transport creation failure an informational message

The write_ports code will fail both the IENT4 and INET6 transport creation if
the transport returns an error when PF_INET6 is specified. Some transports
that do not support INET6 return an error other than EAFNOSUPPORT. We should
allow communication on INET4 even if INET6 is not yet supported or fails
for some reason.

Signed-off-by: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 fs/nfsd/nfsctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 0f0e77f..019a89e 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1008,8 +1008,10 @@ static ssize_t __write_ports_addxprt(char *buf)
 
 	err = svc_create_xprt(nfsd_serv, transport,
 				PF_INET6, port, SVC_SOCK_ANONYMOUS);
-	if (err < 0 && err != -EAFNOSUPPORT)
-		goto out_close;
+	if (err < 0)
+		dprintk("nfsd: Error creating PF_INET6 listener for transport '%s'\n",
+			 transport);
+
 	return 0;
 out_close:
 	xprt = svc_find_xprt(nfsd_serv, transport, PF_INET, port);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
