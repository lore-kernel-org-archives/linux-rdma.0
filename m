From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] Fix -Wformat-security warnings with clang
Date: Sun, 9 Dec 2012 03:06:25 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090305120.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-1315199876-1355051186=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-1315199876-1355051186=:64779
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

clang with -Wformat-security warnings is extremely paranoid when it come 
to calling printf-like functions like osm_log* with a variable content 
buffer of some kind. This commit explicitly uses the "%s" format string to 
make formatting the variable buffer safer.

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  opensm/osm_helper.c | 96 ++++++++++++++++++++++++++---------------------------
  1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index e13b044..10b88d7 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -888,7 +888,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
  		osm_dump_port_info_to_buf(node_guid, port_guid,
  					  port_num, p_pi, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);

  		/*  show the capabilities mask */
  		if (p_pi->capability_mask) {
@@ -910,7 +910,7 @@ void osm_dump_port_info_v2(IN osm_log_t * p_log, IN ib_net64_t node_guid,
  		osm_dump_port_info_to_buf(node_guid, port_guid,
  					  port_num, p_pi, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);

  		/*  show the capabilities mask */
  		if (p_pi->capability_mask) {
@@ -955,7 +955,7 @@ void osm_dump_mlnx_ext_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
  		osm_dump_mlnx_ext_port_info_to_buf(node_guid, port_guid,
  						   port_num, p_pi, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -970,7 +970,7 @@ void osm_dump_mlnx_ext_port_info_v2(IN osm_log_t * p_log, IN ib_net64_t node_gui
  		osm_dump_mlnx_ext_port_info_to_buf(node_guid, port_guid,
  						   port_num, p_pi, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
          }
  }

@@ -1072,7 +1072,7 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,

  		osm_dump_portinfo_record_to_buf(p_pir, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);

  		/*  show the capabilities mask */
  		if (p_pi->capability_mask) {
@@ -1094,7 +1094,7 @@ void osm_dump_portinfo_record_v2(IN osm_log_t * p_log,

  		osm_dump_portinfo_record_to_buf(p_pir, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);

  		/*  show the capabilities mask */
  		if (p_pi->capability_mask) {
@@ -1146,7 +1146,7 @@ void osm_dump_guid_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
  		osm_dump_guid_info_to_buf(node_guid, port_guid,
  					  block_num, p_gi, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1162,7 +1162,7 @@ void osm_dump_guid_info_v2(IN osm_log_t * p_log, IN ib_net64_t node_guid,
  		osm_dump_guid_info_to_buf(node_guid, port_guid,
  					  block_num, p_gi, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1207,7 +1207,7 @@ void osm_dump_guidinfo_record(IN osm_log_t * p_log,

  		osm_dump_guidinfo_record_to_buf(p_gir, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1221,7 +1221,7 @@ void osm_dump_guidinfo_record_v2(IN osm_log_t * p_log,

  		osm_dump_guidinfo_record_to_buf(p_gir, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1264,7 +1264,7 @@ void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,

  		osm_dump_node_info_to_buf(p_ni, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1276,7 +1276,7 @@ void osm_dump_node_info_v2(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,

  		osm_dump_node_info_to_buf(p_ni, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1333,7 +1333,7 @@ void osm_dump_node_record(IN osm_log_t * p_log,

  		osm_dump_node_record_to_buf(p_nr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1347,7 +1347,7 @@ void osm_dump_node_record_v2(IN osm_log_t * p_log,

  		osm_dump_node_record_to_buf(p_nr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1401,7 +1401,7 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,

  		osm_dump_path_record_to_buf(p_pr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1413,7 +1413,7 @@ void osm_dump_path_record_v2(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr

  		osm_dump_path_record_to_buf(p_pr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1486,7 +1486,7 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,

  		osm_dump_multipath_record_to_buf(p_mpr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1500,7 +1500,7 @@ void osm_dump_multipath_record_v2(IN osm_log_t * p_log,

  		osm_dump_multipath_record_to_buf(p_mpr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1547,7 +1547,7 @@ void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,

  		osm_dump_mc_record_to_buf(p_mcmr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1559,7 +1559,7 @@ void osm_dump_mc_record_v2(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mc

  		osm_dump_mc_record_to_buf(p_mcmr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1664,7 +1664,7 @@ void osm_dump_service_record(IN osm_log_t * p_log,

  		osm_dump_service_record_to_buf(p_sr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1678,7 +1678,7 @@ void osm_dump_service_record_v2(IN osm_log_t * p_log,

  		osm_dump_service_record_to_buf(p_sr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1768,7 +1768,7 @@ void osm_dump_inform_info(IN osm_log_t * p_log,
  		else
  			osm_dump_inform_info_to_buf(p_ii, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1785,7 +1785,7 @@ void osm_dump_inform_info_v2(IN osm_log_t * p_log,
  		else
  			osm_dump_inform_info_to_buf(p_ii, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1897,7 +1897,7 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,
  		else
  			osm_dump_inform_info_record_to_buf(p_iir, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1914,7 +1914,7 @@ void osm_dump_inform_info_record_v2(IN osm_log_t * p_log,
  		else
  			osm_dump_inform_info_record_to_buf(p_iir, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -1945,7 +1945,7 @@ void osm_dump_link_record(IN osm_log_t * p_log,

  		osm_dump_link_record_to_buf(p_lr, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -1959,7 +1959,7 @@ void osm_dump_link_record_v2(IN osm_log_t * p_log,

  		osm_dump_link_record_to_buf(p_lr, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2002,7 +2002,7 @@ void osm_dump_switch_info(IN osm_log_t * p_log,

  		osm_dump_switch_info_to_buf(p_si, buf);

-		osm_log(p_log, OSM_LOG_VERBOSE, buf);
+		osm_log(p_log, OSM_LOG_VERBOSE, "%s", buf);
  	}
  }

@@ -2016,7 +2016,7 @@ void osm_dump_switch_info_v2(IN osm_log_t * p_log,

  		osm_dump_switch_info_to_buf(p_si, buf);

-		osm_log_v2(p_log, OSM_LOG_VERBOSE, file_id, buf);
+		osm_log_v2(p_log, OSM_LOG_VERBOSE, file_id, "%s", buf);
  	}
  }

@@ -2066,7 +2066,7 @@ void osm_dump_switch_info_record(IN osm_log_t * p_log,

  		osm_dump_switch_info_record_to_buf(p_sir, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2080,7 +2080,7 @@ void osm_dump_switch_info_record_v2(IN osm_log_t * p_log,

  		osm_dump_switch_info_record_to_buf(p_sir, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2120,7 +2120,7 @@ void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_pkey_block_to_buf(port_guid, block_num, port_num,
  					   p_pkey_tbl, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2136,7 +2136,7 @@ void osm_dump_pkey_block_v2(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_pkey_block_to_buf(port_guid, block_num,
  					   port_num, p_pkey_tbl, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2179,7 +2179,7 @@ void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_slvl_map_table_to_buf(port_guid, in_port_num,
  					       out_port_num, p_slvl_tbl, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2195,7 +2195,7 @@ void osm_dump_slvl_map_table_v2(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_slvl_map_table_to_buf(port_guid, in_port_num,
  					       out_port_num, p_slvl_tbl, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2237,7 +2237,7 @@ void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_vl_arb_table_to_buf(port_guid, block_num,
  					     port_num, p_vla_tbl, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2253,7 +2253,7 @@ void osm_dump_vl_arb_table_v2(IN osm_log_t * p_log, IN uint64_t port_guid,
  		osm_dump_vl_arb_table_to_buf(port_guid, block_num,
  					     port_num, p_vla_tbl, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2285,7 +2285,7 @@ void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,

  		osm_dump_sm_info_to_buf(p_smi, buf);

-		osm_log(p_log, OSM_LOG_DEBUG, buf);
+		osm_log(p_log, OSM_LOG_DEBUG, "%s", buf);
  	}
  }

@@ -2297,7 +2297,7 @@ void osm_dump_sm_info_v2(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,

  		osm_dump_sm_info_to_buf(p_smi, buf);

-		osm_log_v2(p_log, OSM_LOG_DEBUG, file_id, buf);
+		osm_log_v2(p_log, OSM_LOG_DEBUG, file_id, "%s", buf);
  	}
  }

@@ -2336,7 +2336,7 @@ void osm_dump_sm_info_record(IN osm_log_t * p_log,

  		osm_dump_sm_info_record_to_buf(p_smir, buf);

-		osm_log(p_log, OSM_LOG_DEBUG, buf);
+		osm_log(p_log, OSM_LOG_DEBUG, "%s", buf);
  	}
  }

@@ -2350,7 +2350,7 @@ void osm_dump_sm_info_record_v2(IN osm_log_t * p_log,

  		osm_dump_sm_info_record_to_buf(p_smir, buf);

-		osm_log_v2(p_log, OSM_LOG_DEBUG, file_id, buf);
+		osm_log_v2(p_log, OSM_LOG_DEBUG, file_id, "%s", buf);
  	}
  }

@@ -2569,7 +2569,7 @@ void osm_dump_notice(IN osm_log_t * p_log,
  		else
  			osm_dump_notice_to_buf(p_ntci, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2585,7 +2585,7 @@ void osm_dump_notice_v2(IN osm_log_t * p_log,
  		else
  			osm_dump_notice_to_buf(p_ntci, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2700,7 +2700,7 @@ void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,

  		osm_dump_dr_smp_to_buf(p_smp, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s", buf);
  	}
  }

@@ -2712,7 +2712,7 @@ void osm_dump_dr_smp_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,

  		osm_dump_dr_smp_to_buf(p_smp, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

@@ -2774,7 +2774,7 @@ void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,

  		osm_dump_sa_mad_to_buf(p_mad, buf);

-		osm_log(p_log, log_level, buf);
+		osm_log(p_log, log_level, "%s\n", buf);
  	}
  }

@@ -2786,7 +2786,7 @@ void osm_dump_sa_mad_v2(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,

  		osm_dump_sa_mad_to_buf(p_mad, buf);

-		osm_log_v2(p_log, log_level, file_id, buf);
+		osm_log_v2(p_log, log_level, file_id, "%s", buf);
  	}
  }

-- 
1.8.0

--967339439-1315199876-1355051186=:64779
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0002-Fix-Wformat-security-warnings-with-clang.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212090306250.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0002-Fix-Wformat-security-warnings-with-clang.patch

RnJvbSA5MjVhM2E5MjRmYWY1NTU2YmJhZGNlNjE3NTg3ZTlkNzA0ZWQxMzc2
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMjo1NDo1NyAtMDgwMA0KU3ViamVjdDogW1BBVENIIDIvM10gRml4IC1X
Zm9ybWF0LXNlY3VyaXR5IHdhcm5pbmdzIHdpdGggY2xhbmcNCg0KY2xhbmcg
d2l0aCAtV2Zvcm1hdC1zZWN1cml0eSB3YXJuaW5ncyBpcyBleHRyZW1lbHkg
cGFyYW5vaWQgd2hlbiBpdCBjb21lDQp0byBjYWxsaW5nIHByaW50Zi1saWtl
IGZ1bmN0aW9ucyBsaWtlIG9zbV9sb2cqIHdpdGggYSB2YXJpYWJsZSBjb25l
bnQgYnVmZmVyDQpvZiBzb21lIGtpbmQuIFRoaXMgY29tbWl0IGV4cGxpY2l0
bHkgdXNlcyB0aGUgIiVzIiBmb3JtYXQgc3RyaW5nIHRvIG1ha2UNCmZvcm1h
dHRpbmcgdGhlIHZhcmlhYmxlIGJ1ZmZlciBzYWZlci4NCg0KU2lnbmVkLW9m
Zi1ieTogR2FycmV0dCBDb29wZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCi0t
LQ0KIG9wZW5zbS9vc21faGVscGVyLmMgfCA5NiArKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCA0OCBpbnNlcnRpb25zKCspLCA0OCBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL29wZW5zbS9vc21faGVscGVyLmMgYi9vcGVuc20v
b3NtX2hlbHBlci5jDQppbmRleCBlMTNiMDQ0Li4xMGI4OGQ3IDEwMDY0NA0K
LS0tIGEvb3BlbnNtL29zbV9oZWxwZXIuYw0KKysrIGIvb3BlbnNtL29zbV9o
ZWxwZXIuYw0KQEAgLTg4OCw3ICs4ODgsNyBAQCB2b2lkIG9zbV9kdW1wX3Bv
cnRfaW5mbyhJTiBvc21fbG9nX3QgKiBwX2xvZywgSU4gaWJfbmV0NjRfdCBu
b2RlX2d1aWQsDQogCQlvc21fZHVtcF9wb3J0X2luZm9fdG9fYnVmKG5vZGVf
Z3VpZCwgcG9ydF9ndWlkLA0KIAkJCQkJICBwb3J0X251bSwgcF9waSwgYnVm
KTsNCiANCi0JCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgYnVmKTsNCisJ
CW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgIiVzIiwgYnVmKTsNCiANCiAJ
CS8qICBzaG93IHRoZSBjYXBhYmlsaXRpZXMgbWFzayAqLw0KIAkJaWYgKHBf
cGktPmNhcGFiaWxpdHlfbWFzaykgew0KQEAgLTkxMCw3ICs5MTAsNyBAQCB2
b2lkIG9zbV9kdW1wX3BvcnRfaW5mb192MihJTiBvc21fbG9nX3QgKiBwX2xv
ZywgSU4gaWJfbmV0NjRfdCBub2RlX2d1aWQsDQogCQlvc21fZHVtcF9wb3J0
X2luZm9fdG9fYnVmKG5vZGVfZ3VpZCwgcG9ydF9ndWlkLA0KIAkJCQkJICBw
b3J0X251bSwgcF9waSwgYnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2cs
IGxvZ19sZXZlbCwgZmlsZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9s
b2csIGxvZ19sZXZlbCwgZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiANCiAJCS8q
ICBzaG93IHRoZSBjYXBhYmlsaXRpZXMgbWFzayAqLw0KIAkJaWYgKHBfcGkt
PmNhcGFiaWxpdHlfbWFzaykgew0KQEAgLTk1NSw3ICs5NTUsNyBAQCB2b2lk
IG9zbV9kdW1wX21sbnhfZXh0X3BvcnRfaW5mbyhJTiBvc21fbG9nX3QgKiBw
X2xvZywgSU4gaWJfbmV0NjRfdCBub2RlX2d1aWQsDQogCQlvc21fZHVtcF9t
bG54X2V4dF9wb3J0X2luZm9fdG9fYnVmKG5vZGVfZ3VpZCwgcG9ydF9ndWlk
LA0KIAkJCQkJCSAgIHBvcnRfbnVtLCBwX3BpLCBidWYpOw0KIA0KLQkJb3Nt
X2xvZyhwX2xvZywgbG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xv
ZywgbG9nX2xldmVsLCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAgLTk3
MCw3ICs5NzAsNyBAQCB2b2lkIG9zbV9kdW1wX21sbnhfZXh0X3BvcnRfaW5m
b192MihJTiBvc21fbG9nX3QgKiBwX2xvZywgSU4gaWJfbmV0NjRfdCBub2Rl
X2d1aQ0KIAkJb3NtX2R1bXBfbWxueF9leHRfcG9ydF9pbmZvX3RvX2J1Zihu
b2RlX2d1aWQsIHBvcnRfZ3VpZCwNCiAJCQkJCQkgICBwb3J0X251bSwgcF9w
aSwgYnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwg
ZmlsZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZl
bCwgZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiAgICAgICAgIH0NCiB9DQogDQpA
QCAtMTA3Miw3ICsxMDcyLDcgQEAgdm9pZCBvc21fZHVtcF9wb3J0aW5mb19y
ZWNvcmQoSU4gb3NtX2xvZ190ICogcF9sb2csDQogDQogCQlvc21fZHVtcF9w
b3J0aW5mb19yZWNvcmRfdG9fYnVmKHBfcGlyLCBidWYpOw0KIA0KLQkJb3Nt
X2xvZyhwX2xvZywgbG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xv
ZywgbG9nX2xldmVsLCAiJXMiLCBidWYpOw0KIA0KIAkJLyogIHNob3cgdGhl
IGNhcGFiaWxpdGllcyBtYXNrICovDQogCQlpZiAocF9waS0+Y2FwYWJpbGl0
eV9tYXNrKSB7DQpAQCAtMTA5NCw3ICsxMDk0LDcgQEAgdm9pZCBvc21fZHVt
cF9wb3J0aW5mb19yZWNvcmRfdjIoSU4gb3NtX2xvZ190ICogcF9sb2csDQog
DQogCQlvc21fZHVtcF9wb3J0aW5mb19yZWNvcmRfdG9fYnVmKHBfcGlyLCBi
dWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xvZywgbG9nX2xldmVsLCBmaWxl
X2lkLCBidWYpOw0KKwkJb3NtX2xvZ192MihwX2xvZywgbG9nX2xldmVsLCBm
aWxlX2lkLCAiJXMiLCBidWYpOw0KIA0KIAkJLyogIHNob3cgdGhlIGNhcGFi
aWxpdGllcyBtYXNrICovDQogCQlpZiAocF9waS0+Y2FwYWJpbGl0eV9tYXNr
KSB7DQpAQCAtMTE0Niw3ICsxMTQ2LDcgQEAgdm9pZCBvc21fZHVtcF9ndWlk
X2luZm8oSU4gb3NtX2xvZ190ICogcF9sb2csIElOIGliX25ldDY0X3Qgbm9k
ZV9ndWlkLA0KIAkJb3NtX2R1bXBfZ3VpZF9pbmZvX3RvX2J1Zihub2RlX2d1
aWQsIHBvcnRfZ3VpZCwNCiAJCQkJCSAgYmxvY2tfbnVtLCBwX2dpLCBidWYp
Ow0KIA0KLQkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVsLCBidWYpOw0KKwkJ
b3NtX2xvZyhwX2xvZywgbG9nX2xldmVsLCAiJXMiLCBidWYpOw0KIAl9DQog
fQ0KIA0KQEAgLTExNjIsNyArMTE2Miw3IEBAIHZvaWQgb3NtX2R1bXBfZ3Vp
ZF9pbmZvX3YyKElOIG9zbV9sb2dfdCAqIHBfbG9nLCBJTiBpYl9uZXQ2NF90
IG5vZGVfZ3VpZCwNCiAJCW9zbV9kdW1wX2d1aWRfaW5mb190b19idWYobm9k
ZV9ndWlkLCBwb3J0X2d1aWQsDQogCQkJCQkgIGJsb2NrX251bSwgcF9naSwg
YnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmls
ZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwg
ZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0xMjA3LDcg
KzEyMDcsNyBAQCB2b2lkIG9zbV9kdW1wX2d1aWRpbmZvX3JlY29yZChJTiBv
c21fbG9nX3QgKiBwX2xvZywNCiANCiAJCW9zbV9kdW1wX2d1aWRpbmZvX3Jl
Y29yZF90b19idWYocF9naXIsIGJ1Zik7DQogDQotCQlvc21fbG9nKHBfbG9n
LCBsb2dfbGV2ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2
ZWwsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMTIyMSw3ICsxMjIx
LDcgQEAgdm9pZCBvc21fZHVtcF9ndWlkaW5mb19yZWNvcmRfdjIoSU4gb3Nt
X2xvZ190ICogcF9sb2csDQogDQogCQlvc21fZHVtcF9ndWlkaW5mb19yZWNv
cmRfdG9fYnVmKHBfZ2lyLCBidWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xv
ZywgbG9nX2xldmVsLCBmaWxlX2lkLCBidWYpOw0KKwkJb3NtX2xvZ192Mihw
X2xvZywgbG9nX2xldmVsLCBmaWxlX2lkLCAiJXMiLCBidWYpOw0KIAl9DQog
fQ0KIA0KQEAgLTEyNjQsNyArMTI2NCw3IEBAIHZvaWQgb3NtX2R1bXBfbm9k
ZV9pbmZvKElOIG9zbV9sb2dfdCAqIHBfbG9nLCBJTiBjb25zdCBpYl9ub2Rl
X2luZm9fdCAqIHBfbmksDQogDQogCQlvc21fZHVtcF9ub2RlX2luZm9fdG9f
YnVmKHBfbmksIGJ1Zik7DQogDQotCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2
ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2ZWwsICIlcyIs
IGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMTI3Niw3ICsxMjc2LDcgQEAgdm9p
ZCBvc21fZHVtcF9ub2RlX2luZm9fdjIoSU4gb3NtX2xvZ190ICogcF9sb2cs
IElOIGNvbnN0IGliX25vZGVfaW5mb190ICogcF9uaSwNCiANCiAJCW9zbV9k
dW1wX25vZGVfaW5mb190b19idWYocF9uaSwgYnVmKTsNCiANCi0JCW9zbV9s
b2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmlsZV9pZCwgYnVmKTsNCisJCW9z
bV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmlsZV9pZCwgIiVzIiwgYnVm
KTsNCiAJfQ0KIH0NCiANCkBAIC0xMzMzLDcgKzEzMzMsNyBAQCB2b2lkIG9z
bV9kdW1wX25vZGVfcmVjb3JkKElOIG9zbV9sb2dfdCAqIHBfbG9nLA0KIA0K
IAkJb3NtX2R1bXBfbm9kZV9yZWNvcmRfdG9fYnVmKHBfbnIsIGJ1Zik7DQog
DQotCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2ZWwsIGJ1Zik7DQorCQlvc21f
bG9nKHBfbG9nLCBsb2dfbGV2ZWwsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQog
DQpAQCAtMTM0Nyw3ICsxMzQ3LDcgQEAgdm9pZCBvc21fZHVtcF9ub2RlX3Jl
Y29yZF92MihJTiBvc21fbG9nX3QgKiBwX2xvZywNCiANCiAJCW9zbV9kdW1w
X25vZGVfcmVjb3JkX3RvX2J1ZihwX25yLCBidWYpOw0KIA0KLQkJb3NtX2xv
Z192MihwX2xvZywgbG9nX2xldmVsLCBmaWxlX2lkLCBidWYpOw0KKwkJb3Nt
X2xvZ192MihwX2xvZywgbG9nX2xldmVsLCBmaWxlX2lkLCAiJXMiLCBidWYp
Ow0KIAl9DQogfQ0KIA0KQEAgLTE0MDEsNyArMTQwMSw3IEBAIHZvaWQgb3Nt
X2R1bXBfcGF0aF9yZWNvcmQoSU4gb3NtX2xvZ190ICogcF9sb2csIElOIGNv
bnN0IGliX3BhdGhfcmVjX3QgKiBwX3ByLA0KIA0KIAkJb3NtX2R1bXBfcGF0
aF9yZWNvcmRfdG9fYnVmKHBfcHIsIGJ1Zik7DQogDQotCQlvc21fbG9nKHBf
bG9nLCBsb2dfbGV2ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9nLCBsb2df
bGV2ZWwsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMTQxMyw3ICsx
NDEzLDcgQEAgdm9pZCBvc21fZHVtcF9wYXRoX3JlY29yZF92MihJTiBvc21f
bG9nX3QgKiBwX2xvZywgSU4gY29uc3QgaWJfcGF0aF9yZWNfdCAqIHBfcHIN
CiANCiAJCW9zbV9kdW1wX3BhdGhfcmVjb3JkX3RvX2J1ZihwX3ByLCBidWYp
Ow0KIA0KLQkJb3NtX2xvZ192MihwX2xvZywgbG9nX2xldmVsLCBmaWxlX2lk
LCBidWYpOw0KKwkJb3NtX2xvZ192MihwX2xvZywgbG9nX2xldmVsLCBmaWxl
X2lkLCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAgLTE0ODYsNyArMTQ4
Niw3IEBAIHZvaWQgb3NtX2R1bXBfbXVsdGlwYXRoX3JlY29yZChJTiBvc21f
bG9nX3QgKiBwX2xvZywNCiANCiAJCW9zbV9kdW1wX211bHRpcGF0aF9yZWNv
cmRfdG9fYnVmKHBfbXByLCBidWYpOw0KIA0KLQkJb3NtX2xvZyhwX2xvZywg
bG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVs
LCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAgLTE1MDAsNyArMTUwMCw3
IEBAIHZvaWQgb3NtX2R1bXBfbXVsdGlwYXRoX3JlY29yZF92MihJTiBvc21f
bG9nX3QgKiBwX2xvZywNCiANCiAJCW9zbV9kdW1wX211bHRpcGF0aF9yZWNv
cmRfdG9fYnVmKHBfbXByLCBidWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xv
ZywgbG9nX2xldmVsLCBmaWxlX2lkLCBidWYpOw0KKwkJb3NtX2xvZ192Mihw
X2xvZywgbG9nX2xldmVsLCBmaWxlX2lkLCAiJXMiLCBidWYpOw0KIAl9DQog
fQ0KIA0KQEAgLTE1NDcsNyArMTU0Nyw3IEBAIHZvaWQgb3NtX2R1bXBfbWNf
cmVjb3JkKElOIG9zbV9sb2dfdCAqIHBfbG9nLCBJTiBjb25zdCBpYl9tZW1i
ZXJfcmVjX3QgKiBwX21jbXIsDQogDQogCQlvc21fZHVtcF9tY19yZWNvcmRf
dG9fYnVmKHBfbWNtciwgYnVmKTsNCiANCi0JCW9zbV9sb2cocF9sb2csIGxv
Z19sZXZlbCwgYnVmKTsNCisJCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwg
IiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0xNTU5LDcgKzE1NTksNyBA
QCB2b2lkIG9zbV9kdW1wX21jX3JlY29yZF92MihJTiBvc21fbG9nX3QgKiBw
X2xvZywgSU4gY29uc3QgaWJfbWVtYmVyX3JlY190ICogcF9tYw0KIA0KIAkJ
b3NtX2R1bXBfbWNfcmVjb3JkX3RvX2J1ZihwX21jbXIsIGJ1Zik7DQogDQot
CQlvc21fbG9nX3YyKHBfbG9nLCBsb2dfbGV2ZWwsIGZpbGVfaWQsIGJ1Zik7
DQorCQlvc21fbG9nX3YyKHBfbG9nLCBsb2dfbGV2ZWwsIGZpbGVfaWQsICIl
cyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMTY2NCw3ICsxNjY0LDcgQEAg
dm9pZCBvc21fZHVtcF9zZXJ2aWNlX3JlY29yZChJTiBvc21fbG9nX3QgKiBw
X2xvZywNCiANCiAJCW9zbV9kdW1wX3NlcnZpY2VfcmVjb3JkX3RvX2J1Zihw
X3NyLCBidWYpOw0KIA0KLQkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVsLCBi
dWYpOw0KKwkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVsLCAiJXMiLCBidWYp
Ow0KIAl9DQogfQ0KIA0KQEAgLTE2NzgsNyArMTY3OCw3IEBAIHZvaWQgb3Nt
X2R1bXBfc2VydmljZV9yZWNvcmRfdjIoSU4gb3NtX2xvZ190ICogcF9sb2cs
DQogDQogCQlvc21fZHVtcF9zZXJ2aWNlX3JlY29yZF90b19idWYocF9zciwg
YnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmls
ZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwg
ZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0xNzY4LDcg
KzE3NjgsNyBAQCB2b2lkIG9zbV9kdW1wX2luZm9ybV9pbmZvKElOIG9zbV9s
b2dfdCAqIHBfbG9nLA0KIAkJZWxzZQ0KIAkJCW9zbV9kdW1wX2luZm9ybV9p
bmZvX3RvX2J1ZihwX2lpLCBidWYpOw0KIA0KLQkJb3NtX2xvZyhwX2xvZywg
bG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVs
LCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAgLTE3ODUsNyArMTc4NSw3
IEBAIHZvaWQgb3NtX2R1bXBfaW5mb3JtX2luZm9fdjIoSU4gb3NtX2xvZ190
ICogcF9sb2csDQogCQllbHNlDQogCQkJb3NtX2R1bXBfaW5mb3JtX2luZm9f
dG9fYnVmKHBfaWksIGJ1Zik7DQogDQotCQlvc21fbG9nX3YyKHBfbG9nLCBs
b2dfbGV2ZWwsIGZpbGVfaWQsIGJ1Zik7DQorCQlvc21fbG9nX3YyKHBfbG9n
LCBsb2dfbGV2ZWwsIGZpbGVfaWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQog
DQpAQCAtMTg5Nyw3ICsxODk3LDcgQEAgdm9pZCBvc21fZHVtcF9pbmZvcm1f
aW5mb19yZWNvcmQoSU4gb3NtX2xvZ190ICogcF9sb2csDQogCQllbHNlDQog
CQkJb3NtX2R1bXBfaW5mb3JtX2luZm9fcmVjb3JkX3RvX2J1ZihwX2lpciwg
YnVmKTsNCiANCi0JCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgYnVmKTsN
CisJCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgIiVzIiwgYnVmKTsNCiAJ
fQ0KIH0NCiANCkBAIC0xOTE0LDcgKzE5MTQsNyBAQCB2b2lkIG9zbV9kdW1w
X2luZm9ybV9pbmZvX3JlY29yZF92MihJTiBvc21fbG9nX3QgKiBwX2xvZywN
CiAJCWVsc2UNCiAJCQlvc21fZHVtcF9pbmZvcm1faW5mb19yZWNvcmRfdG9f
YnVmKHBfaWlyLCBidWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xvZywgbG9n
X2xldmVsLCBmaWxlX2lkLCBidWYpOw0KKwkJb3NtX2xvZ192MihwX2xvZywg
bG9nX2xldmVsLCBmaWxlX2lkLCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0K
QEAgLTE5NDUsNyArMTk0NSw3IEBAIHZvaWQgb3NtX2R1bXBfbGlua19yZWNv
cmQoSU4gb3NtX2xvZ190ICogcF9sb2csDQogDQogCQlvc21fZHVtcF9saW5r
X3JlY29yZF90b19idWYocF9sciwgYnVmKTsNCiANCi0JCW9zbV9sb2cocF9s
b2csIGxvZ19sZXZlbCwgYnVmKTsNCisJCW9zbV9sb2cocF9sb2csIGxvZ19s
ZXZlbCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0xOTU5LDcgKzE5
NTksNyBAQCB2b2lkIG9zbV9kdW1wX2xpbmtfcmVjb3JkX3YyKElOIG9zbV9s
b2dfdCAqIHBfbG9nLA0KIA0KIAkJb3NtX2R1bXBfbGlua19yZWNvcmRfdG9f
YnVmKHBfbHIsIGJ1Zik7DQogDQotCQlvc21fbG9nX3YyKHBfbG9nLCBsb2df
bGV2ZWwsIGZpbGVfaWQsIGJ1Zik7DQorCQlvc21fbG9nX3YyKHBfbG9nLCBs
b2dfbGV2ZWwsIGZpbGVfaWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpA
QCAtMjAwMiw3ICsyMDAyLDcgQEAgdm9pZCBvc21fZHVtcF9zd2l0Y2hfaW5m
byhJTiBvc21fbG9nX3QgKiBwX2xvZywNCiANCiAJCW9zbV9kdW1wX3N3aXRj
aF9pbmZvX3RvX2J1ZihwX3NpLCBidWYpOw0KIA0KLQkJb3NtX2xvZyhwX2xv
ZywgT1NNX0xPR19WRVJCT1NFLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xvZywg
T1NNX0xPR19WRVJCT1NFLCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAg
LTIwMTYsNyArMjAxNiw3IEBAIHZvaWQgb3NtX2R1bXBfc3dpdGNoX2luZm9f
djIoSU4gb3NtX2xvZ190ICogcF9sb2csDQogDQogCQlvc21fZHVtcF9zd2l0
Y2hfaW5mb190b19idWYocF9zaSwgYnVmKTsNCiANCi0JCW9zbV9sb2dfdjIo
cF9sb2csIE9TTV9MT0dfVkVSQk9TRSwgZmlsZV9pZCwgYnVmKTsNCisJCW9z
bV9sb2dfdjIocF9sb2csIE9TTV9MT0dfVkVSQk9TRSwgZmlsZV9pZCwgIiVz
IiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0yMDY2LDcgKzIwNjYsNyBAQCB2
b2lkIG9zbV9kdW1wX3N3aXRjaF9pbmZvX3JlY29yZChJTiBvc21fbG9nX3Qg
KiBwX2xvZywNCiANCiAJCW9zbV9kdW1wX3N3aXRjaF9pbmZvX3JlY29yZF90
b19idWYocF9zaXIsIGJ1Zik7DQogDQotCQlvc21fbG9nKHBfbG9nLCBsb2df
bGV2ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2ZWwsICIl
cyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMjA4MCw3ICsyMDgwLDcgQEAg
dm9pZCBvc21fZHVtcF9zd2l0Y2hfaW5mb19yZWNvcmRfdjIoSU4gb3NtX2xv
Z190ICogcF9sb2csDQogDQogCQlvc21fZHVtcF9zd2l0Y2hfaW5mb19yZWNv
cmRfdG9fYnVmKHBfc2lyLCBidWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xv
ZywgbG9nX2xldmVsLCBmaWxlX2lkLCBidWYpOw0KKwkJb3NtX2xvZ192Mihw
X2xvZywgbG9nX2xldmVsLCBmaWxlX2lkLCAiJXMiLCBidWYpOw0KIAl9DQog
fQ0KIA0KQEAgLTIxMjAsNyArMjEyMCw3IEBAIHZvaWQgb3NtX2R1bXBfcGtl
eV9ibG9jayhJTiBvc21fbG9nX3QgKiBwX2xvZywgSU4gdWludDY0X3QgcG9y
dF9ndWlkLA0KIAkJb3NtX2R1bXBfcGtleV9ibG9ja190b19idWYocG9ydF9n
dWlkLCBibG9ja19udW0sIHBvcnRfbnVtLA0KIAkJCQkJICAgcF9wa2V5X3Ri
bCwgYnVmKTsNCiANCi0JCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgYnVm
KTsNCisJCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgIiVzIiwgYnVmKTsN
CiAJfQ0KIH0NCiANCkBAIC0yMTM2LDcgKzIxMzYsNyBAQCB2b2lkIG9zbV9k
dW1wX3BrZXlfYmxvY2tfdjIoSU4gb3NtX2xvZ190ICogcF9sb2csIElOIHVp
bnQ2NF90IHBvcnRfZ3VpZCwNCiAJCW9zbV9kdW1wX3BrZXlfYmxvY2tfdG9f
YnVmKHBvcnRfZ3VpZCwgYmxvY2tfbnVtLA0KIAkJCQkJICAgcG9ydF9udW0s
IHBfcGtleV90YmwsIGJ1Zik7DQogDQotCQlvc21fbG9nX3YyKHBfbG9nLCBs
b2dfbGV2ZWwsIGZpbGVfaWQsIGJ1Zik7DQorCQlvc21fbG9nX3YyKHBfbG9n
LCBsb2dfbGV2ZWwsIGZpbGVfaWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQog
DQpAQCAtMjE3OSw3ICsyMTc5LDcgQEAgdm9pZCBvc21fZHVtcF9zbHZsX21h
cF90YWJsZShJTiBvc21fbG9nX3QgKiBwX2xvZywgSU4gdWludDY0X3QgcG9y
dF9ndWlkLA0KIAkJb3NtX2R1bXBfc2x2bF9tYXBfdGFibGVfdG9fYnVmKHBv
cnRfZ3VpZCwgaW5fcG9ydF9udW0sDQogCQkJCQkgICAgICAgb3V0X3BvcnRf
bnVtLCBwX3NsdmxfdGJsLCBidWYpOw0KIA0KLQkJb3NtX2xvZyhwX2xvZywg
bG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVs
LCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0KQEAgLTIxOTUsNyArMjE5NSw3
IEBAIHZvaWQgb3NtX2R1bXBfc2x2bF9tYXBfdGFibGVfdjIoSU4gb3NtX2xv
Z190ICogcF9sb2csIElOIHVpbnQ2NF90IHBvcnRfZ3VpZCwNCiAJCW9zbV9k
dW1wX3NsdmxfbWFwX3RhYmxlX3RvX2J1Zihwb3J0X2d1aWQsIGluX3BvcnRf
bnVtLA0KIAkJCQkJICAgICAgIG91dF9wb3J0X251bSwgcF9zbHZsX3RibCwg
YnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmls
ZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwg
ZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0yMjM3LDcg
KzIyMzcsNyBAQCB2b2lkIG9zbV9kdW1wX3ZsX2FyYl90YWJsZShJTiBvc21f
bG9nX3QgKiBwX2xvZywgSU4gdWludDY0X3QgcG9ydF9ndWlkLA0KIAkJb3Nt
X2R1bXBfdmxfYXJiX3RhYmxlX3RvX2J1Zihwb3J0X2d1aWQsIGJsb2NrX251
bSwNCiAJCQkJCSAgICAgcG9ydF9udW0sIHBfdmxhX3RibCwgYnVmKTsNCiAN
Ci0JCW9zbV9sb2cocF9sb2csIGxvZ19sZXZlbCwgYnVmKTsNCisJCW9zbV9s
b2cocF9sb2csIGxvZ19sZXZlbCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiAN
CkBAIC0yMjUzLDcgKzIyNTMsNyBAQCB2b2lkIG9zbV9kdW1wX3ZsX2FyYl90
YWJsZV92MihJTiBvc21fbG9nX3QgKiBwX2xvZywgSU4gdWludDY0X3QgcG9y
dF9ndWlkLA0KIAkJb3NtX2R1bXBfdmxfYXJiX3RhYmxlX3RvX2J1Zihwb3J0
X2d1aWQsIGJsb2NrX251bSwNCiAJCQkJCSAgICAgcG9ydF9udW0sIHBfdmxh
X3RibCwgYnVmKTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZl
bCwgZmlsZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19s
ZXZlbCwgZmlsZV9pZCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0y
Mjg1LDcgKzIyODUsNyBAQCB2b2lkIG9zbV9kdW1wX3NtX2luZm8oSU4gb3Nt
X2xvZ190ICogcF9sb2csIElOIGNvbnN0IGliX3NtX2luZm9fdCAqIHBfc21p
LA0KIA0KIAkJb3NtX2R1bXBfc21faW5mb190b19idWYocF9zbWksIGJ1Zik7
DQogDQotCQlvc21fbG9nKHBfbG9nLCBPU01fTE9HX0RFQlVHLCBidWYpOw0K
KwkJb3NtX2xvZyhwX2xvZywgT1NNX0xPR19ERUJVRywgIiVzIiwgYnVmKTsN
CiAJfQ0KIH0NCiANCkBAIC0yMjk3LDcgKzIyOTcsNyBAQCB2b2lkIG9zbV9k
dW1wX3NtX2luZm9fdjIoSU4gb3NtX2xvZ190ICogcF9sb2csIElOIGNvbnN0
IGliX3NtX2luZm9fdCAqIHBfc21pLA0KIA0KIAkJb3NtX2R1bXBfc21faW5m
b190b19idWYocF9zbWksIGJ1Zik7DQogDQotCQlvc21fbG9nX3YyKHBfbG9n
LCBPU01fTE9HX0RFQlVHLCBmaWxlX2lkLCBidWYpOw0KKwkJb3NtX2xvZ192
MihwX2xvZywgT1NNX0xPR19ERUJVRywgZmlsZV9pZCwgIiVzIiwgYnVmKTsN
CiAJfQ0KIH0NCiANCkBAIC0yMzM2LDcgKzIzMzYsNyBAQCB2b2lkIG9zbV9k
dW1wX3NtX2luZm9fcmVjb3JkKElOIG9zbV9sb2dfdCAqIHBfbG9nLA0KIA0K
IAkJb3NtX2R1bXBfc21faW5mb19yZWNvcmRfdG9fYnVmKHBfc21pciwgYnVm
KTsNCiANCi0JCW9zbV9sb2cocF9sb2csIE9TTV9MT0dfREVCVUcsIGJ1Zik7
DQorCQlvc21fbG9nKHBfbG9nLCBPU01fTE9HX0RFQlVHLCAiJXMiLCBidWYp
Ow0KIAl9DQogfQ0KIA0KQEAgLTIzNTAsNyArMjM1MCw3IEBAIHZvaWQgb3Nt
X2R1bXBfc21faW5mb19yZWNvcmRfdjIoSU4gb3NtX2xvZ190ICogcF9sb2cs
DQogDQogCQlvc21fZHVtcF9zbV9pbmZvX3JlY29yZF90b19idWYocF9zbWly
LCBidWYpOw0KIA0KLQkJb3NtX2xvZ192MihwX2xvZywgT1NNX0xPR19ERUJV
RywgZmlsZV9pZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIE9TTV9M
T0dfREVCVUcsIGZpbGVfaWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpA
QCAtMjU2OSw3ICsyNTY5LDcgQEAgdm9pZCBvc21fZHVtcF9ub3RpY2UoSU4g
b3NtX2xvZ190ICogcF9sb2csDQogCQllbHNlDQogCQkJb3NtX2R1bXBfbm90
aWNlX3RvX2J1ZihwX250Y2ksIGJ1Zik7DQogDQotCQlvc21fbG9nKHBfbG9n
LCBsb2dfbGV2ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9nLCBsb2dfbGV2
ZWwsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAtMjU4NSw3ICsyNTg1
LDcgQEAgdm9pZCBvc21fZHVtcF9ub3RpY2VfdjIoSU4gb3NtX2xvZ190ICog
cF9sb2csDQogCQllbHNlDQogCQkJb3NtX2R1bXBfbm90aWNlX3RvX2J1Zihw
X250Y2ksIGJ1Zik7DQogDQotCQlvc21fbG9nX3YyKHBfbG9nLCBsb2dfbGV2
ZWwsIGZpbGVfaWQsIGJ1Zik7DQorCQlvc21fbG9nX3YyKHBfbG9nLCBsb2df
bGV2ZWwsIGZpbGVfaWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQpAQCAt
MjcwMCw3ICsyNzAwLDcgQEAgdm9pZCBvc21fZHVtcF9kcl9zbXAoSU4gb3Nt
X2xvZ190ICogcF9sb2csIElOIGNvbnN0IGliX3NtcF90ICogcF9zbXAsDQog
DQogCQlvc21fZHVtcF9kcl9zbXBfdG9fYnVmKHBfc21wLCBidWYpOw0KIA0K
LQkJb3NtX2xvZyhwX2xvZywgbG9nX2xldmVsLCBidWYpOw0KKwkJb3NtX2xv
ZyhwX2xvZywgbG9nX2xldmVsLCAiJXMiLCBidWYpOw0KIAl9DQogfQ0KIA0K
QEAgLTI3MTIsNyArMjcxMiw3IEBAIHZvaWQgb3NtX2R1bXBfZHJfc21wX3Yy
KElOIG9zbV9sb2dfdCAqIHBfbG9nLCBJTiBjb25zdCBpYl9zbXBfdCAqIHBf
c21wLA0KIA0KIAkJb3NtX2R1bXBfZHJfc21wX3RvX2J1ZihwX3NtcCwgYnVm
KTsNCiANCi0JCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmlsZV9p
ZCwgYnVmKTsNCisJCW9zbV9sb2dfdjIocF9sb2csIGxvZ19sZXZlbCwgZmls
ZV9pZCwgIiVzIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0yNzc0LDcgKzI3
NzQsNyBAQCB2b2lkIG9zbV9kdW1wX3NhX21hZChJTiBvc21fbG9nX3QgKiBw
X2xvZywgSU4gY29uc3QgaWJfc2FfbWFkX3QgKiBwX21hZCwNCiANCiAJCW9z
bV9kdW1wX3NhX21hZF90b19idWYocF9tYWQsIGJ1Zik7DQogDQotCQlvc21f
bG9nKHBfbG9nLCBsb2dfbGV2ZWwsIGJ1Zik7DQorCQlvc21fbG9nKHBfbG9n
LCBsb2dfbGV2ZWwsICIlc1xuIiwgYnVmKTsNCiAJfQ0KIH0NCiANCkBAIC0y
Nzg2LDcgKzI3ODYsNyBAQCB2b2lkIG9zbV9kdW1wX3NhX21hZF92MihJTiBv
c21fbG9nX3QgKiBwX2xvZywgSU4gY29uc3QgaWJfc2FfbWFkX3QgKiBwX21h
ZCwNCiANCiAJCW9zbV9kdW1wX3NhX21hZF90b19idWYocF9tYWQsIGJ1Zik7
DQogDQotCQlvc21fbG9nX3YyKHBfbG9nLCBsb2dfbGV2ZWwsIGZpbGVfaWQs
IGJ1Zik7DQorCQlvc21fbG9nX3YyKHBfbG9nLCBsb2dfbGV2ZWwsIGZpbGVf
aWQsICIlcyIsIGJ1Zik7DQogCX0NCiB9DQogDQotLSANCjEuOC4wDQoNCg==

--967339439-1315199876-1355051186=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
