From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Mon, 11 Nov 2013 18:46:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF6FD0@ORSMSX109.amr.corp.intel.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
 <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > As part of the AF_IB changes, additional queries were introduced that
> > separated out retrieving the different kernel data -- assigned address,
> > GID mappings, and IB PR data.  (New queries were necessary, since
> > sockaddr_ib is larger than sockaddr_in6, and we want to eventually
> > handle non-reversible paths.)  The librdmacm 1.0.17 changed which query
> > was called after rdma_bind_addr was invoked to only retrieve the
> > assigned address, versus retrieving everything.  I think this is why you
> > see an SGID of all 0's after calling rdma_bind_addr.
> 
> Is there another call that allows the retrieval of the SGID?

Yes - something like this patch should help, but I don't think this is the correct behavior when the IP address is 'any' addresss.

Retrieve SGID after calling rdma_bind_addr

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A change was made to rdma_bind_addr when AF_IB is enabled
to only retrieve the resulting bound address.  Previously,
rdma_bind_addr would retrieve the corresponding SGID as
well.  This breaks some apps which were checking the
SGID after binding to an IP address.  Revert to the
previous behavior of also retrieving the SGID after
calling rdma_bind_addr.
---
 src/cma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 4f41879..0cf4203 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -753,7 +753,10 @@ static int rdma_bind_addr2(struct rdma_cm_id *id, struct sockaddr *addr,
 	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	return ucma_query_addr(id);
+	ret = ucma_query_addr(id);
+	if (!ret)
+		ret = ucma_query_gid(id);
+	return ret;
 }
 
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
