From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm: Add support for extended join multicast
 API
Date: Fri, 10 Nov 2017 10:28:38 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711101026470.29707@nuc-kabylake>
References: <20171109171609.169281977@linux.com> <20171109171618.882248508@linux.com> <79363650-6aca-111c-4b8c-b1c620be5cde@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <79363650-6aca-111c-4b8c-b1c620be5cde-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Subject: rdma-core: Fixup comments in librdmacm

Fix up the two comments that Hal showed were incorrect.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: rdma-core/librdmacm/cma.c
===================================================================
--- rdma-core.orig/librdmacm/cma.c
+++ rdma-core/librdmacm/cma.c
@@ -2040,7 +2040,7 @@ static int ucma_process_join(struct cma_
 	if (!evt->id_priv->id.qp)
 		return 0;

-	/* Don't attach QP to multicast if joined as send only */
+	/* Don't attach QP to multicast if joined as send only full member */
 	if (evt->mc->join_flags == RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER)
 		return 0;

Index: rdma-core/librdmacm/rdma_cma.h
===================================================================
--- rdma-core.orig/librdmacm/rdma_cma.h
+++ rdma-core/librdmacm/rdma_cma.h
@@ -578,7 +578,7 @@ int rdma_join_multicast(struct rdma_cm_i
 int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr);

 /**
- * in_multicast_ex - Joins a multicast group with options.
+ * rdma_join_multicast_ex - Joins a multicast group with options.
  * @id: Communication identifier associated with the request.
  * @mc_join_attr: Extensive struct containing multicast join parameters.
  * @context: User-defined context associated with the join request.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
