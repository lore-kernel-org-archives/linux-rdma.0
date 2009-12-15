From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: SRP issues with OpenSM 3.3.3
Date: Mon, 14 Dec 2009 16:43:34 -0800
Message-ID: <20091214164334.064102f0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha, Hal,

I have found that the following patch caused our SRP connected storage to
break.

patch: 3d20f82edd3246879063b77721d0bcef927bdc48

    opensm/osm_sa_path_record.c: separate router guid resolution code
    
    Move off subnet destination (router address) resolution code to separate
    function to improve readability.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

I further traced the problem to pr_rcv_build_pr and the patch below fixes the
bug.

16:03:34 > git diff 
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index be0cd71..32c889f 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -800,7 +800,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 
        /* Only set HopLimit if going through a router */
        if (is_nonzero_gid)
-               p_pr->hop_flow_raw |= cl_hton32(IB_HOPLIMIT_MAX);
+               p_pr->hop_flow_raw |= IB_HOPLIMIT_MAX;
 
        p_pr->pkey = p_parms->pkey;
        ib_path_rec_set_sl(p_pr, p_parms->sl);


"hop_flow_raw" is not really a 32bit value but rather 4 fields:
Component     Length(bits)   Offset(bits)
RawTraffic    1              352
Reserved      3              353
FlowLabel     20             356
HopLimit      8              384


However, I don't understand the comment "Only set HopLimit if going through a
router"?

Was the intent to only set p_dgid in pr_rcv_get_end_points if we are heading
through a router?  I don't think it matters if we are going through a router
or not does it?  If not, I think the comment needs to be removed in the patch
above.

Thanks,
Ira

-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
