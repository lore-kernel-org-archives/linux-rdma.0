From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibmad: add explicit extern for ibdebug prototype
Date: Sat, 10 Apr 2010 16:18:10 +0300
Message-ID: <20100410131810.GR4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100218124931.4d6ef34b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


'ibdebug' variable was not declared as 'extern', as result includers
(libraries and programs) may have its own copy of this variable. As
example libibnetdisc and ibnetdiscover.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 libibmad/include/infiniband/mad.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 02ef551..0687c06 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1031,7 +1031,7 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
     mad_dump_portsamples_control;
 
-MAD_EXPORT int ibdebug;
+MAD_EXPORT extern int ibdebug;
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #ifndef ntohll
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
