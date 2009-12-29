From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_slvl_map_rcv.c: fix port parsing on BE machine
Date: Tue, 29 Dec 2009 17:05:28 +0200
Message-ID: <20091229150528.GV26940@me>
References: <20091201194110.GA26753@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091201194110.GA26753-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Ports (input and output) number parsing from attribute modifier value of
SLtoVLMappingTable response was endianess dependent and actually was
broken on a big endian machines. Fix it by doing this endianess
independently.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

On 14:41 Tue 01 Dec     , Hal Rosenstock wrote:
> 
> Optimized SLtoVLMappingTable programming reduces the number of MADs
> needed from O(n**2) to O(n). See IBA 1.2.1 vol 1 p. 843 14.2.5.8
> SLtoVLMappingTable.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When reviewing this patch I found couple of bugs in this code unrelated
to the proposed change. Posting the fixes in this thread.

 opensm/opensm/osm_slvl_map_rcv.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_slvl_map_rcv.c
index 4f75690..3b24a8e 100644
--- a/opensm/opensm/osm_slvl_map_rcv.c
+++ b/opensm/opensm/osm_slvl_map_rcv.c
@@ -105,10 +105,8 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 
 	/* in case of a non switch node the attr modifier should be ignored */
 	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
-		out_port_num =
-		    (uint8_t) cl_ntoh32(p_smp->attr_mod & 0xFF000000);
-		in_port_num =
-		    (uint8_t) cl_ntoh32((p_smp->attr_mod & 0x00FF0000) << 8);
+		out_port_num = cl_ntoh32(p_smp->attr_mod) & 0xff;
+		in_port_num = (cl_ntoh32(p_smp->attr_mod) >> 8) & 0xff;
 		p_physp = osm_node_get_physp_ptr(p_node, out_port_num);
 	} else {
 		p_physp = p_port->p_physp;
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
