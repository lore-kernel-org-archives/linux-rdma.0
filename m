From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm: Add support for extended join multicast
 API V2
Date: Tue, 14 Nov 2017 13:50:54 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711141349370.13532@nuc-kabylake>
References: <20171114185720.609975150@linux.com> <20171114185739.838757957@linux.com> <20171114192558.GL4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114192558.GL4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 14 Nov 2017, Jason Gunthorpe wrote:

> Ie package version 16, not the really old 1.0.15

Ok fixup patch:

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Increase rdma_join_multicast_ex package version to 1.0.16

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: rdma-core/debian/librdmacm1.symbols
===================================================================
--- rdma-core.orig/debian/librdmacm1.symbols
+++ rdma-core/debian/librdmacm1.symbols
@@ -31,7 +31,7 @@ librdmacm.so.1 librdmacm1 #MINVER#
  rdma_get_src_port@RDMACM_1.0 1.0.19
  rdma_getaddrinfo@RDMACM_1.0 1.0.15
  rdma_join_multicast@RDMACM_1.0 1.0.15
- rdma_join_multicast_ex@RDMACM_1.1 1.0.15
+ rdma_join_multicast_ex@RDMACM_1.1 1.0.16
  rdma_leave_multicast@RDMACM_1.0 1.0.15
  rdma_listen@RDMACM_1.0 1.0.15
  rdma_migrate_id@RDMACM_1.0 1.0.15
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
