From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: Change return value from find_gid_port()
Date: Wed, 28 Nov 2012 20:39:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346ADA9E1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Problem reported by Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:

The patch 3c86aa70bf67: "RDMA/cm: Add RDMA CM support for IBoE
devices" from Oct 13, 2010, leads to the following warning:
net/sunrpc/xprtrdma/svc_rdma_transport.c:722 svc_rdma_create()
	 error: passing non neg 1 to ERR_PTR

This bug would result in a NULL dereference.  svc_rdma_create() is
supposed to return ERR_PTRs or valid pointers, but instead it returns
ERR_PTRs, valid pointers and 1.

The call tree is:

svc_rdma_create()
   => rdma_bind_addr()
      => cma_acquire_dev()
         => find_gid_port()

rdma_bind_addr() should return a valid errno.  Fix this by having
find_gid_port() also return a valid errno.  If we can't find the
specified GID on a given port, return -EADDRNOTAVAIL, rather than
-EAGAIN, to better indicate the error.  We also drop using the
special return value of '1' and instead pass through the error
returned by the underlying verbs call.  On such errors, rather
than aborting the search,  we simply continue to check the next
device/port.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 18271e1..59f89c7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -345,17 +345,17 @@ static int find_gid_port(struct ib_device *device, union ib_gid *gid, u8 port_nu
 
 	err = ib_query_port(device, port_num, &props);
 	if (err)
-		return 1;
+		return err;
 
 	for (i = 0; i < props.gid_tbl_len; ++i) {
 		err = ib_query_gid(device, port_num, i, &tmp);
 		if (err)
-			return 1;
+			return err;
 		if (!memcmp(&tmp, gid, sizeof tmp))
 			return 0;
 	}
 
-	return -EAGAIN;
+	return -EADDRNOTAVAIL;
 }
 
 static int cma_acquire_dev(struct rdma_id_private *id_priv)
@@ -388,8 +388,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 				if (!ret) {
 					id_priv->id.port_num = port;
 					goto out;
-				} else if (ret == 1)
-					break;
+				}
 			}
 		}
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
