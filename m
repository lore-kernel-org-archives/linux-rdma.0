From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually
 configured mlid
Date: Fri, 30 Oct 2009 01:02:46 +0200
Message-ID: <20091029230246.GN20136@me>
References: <20091023234856.GA1482@comcast.net>
 <20091029191732.GB20136@me>
 <20091029191945.GE20136@me>
 <20091029154431.72fc32bd.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091029154431.72fc32bd.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

Thanks for reporting.

On 15:44 Thu 29 Oct     , Ira Weiny wrote:
> 
> OpenSM $ mlid_ho 49152; p_tbl->max_mlid_ho 49152
> mlid_ho 49154; p_tbl->max_mlid_ho 49153
> opensm: osm_mcast_tbl.c:107: osm_mcast_tbl_set: Assertion `mlid_ho <= p_tbl->max_mlid_ho' failed.
> Aborted (core dumped)

Small fix:

diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index eee9290..0a45904 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -145,7 +145,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 	p_tbl->p_mask_tbl = p_mask_tbl;
 	p_tbl->mft_depth = mft_depth;
 done:
-	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO - 1;
+	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO;
 	return 0;
 }
 

Does it work for you?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
