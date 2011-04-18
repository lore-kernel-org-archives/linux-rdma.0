From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid port. Otherwise leave it as 0
Date: Sun, 17 Apr 2011 22:32:08 -0700
Message-ID: <C308E4A9-F651-4955-A1B2-73F7AE445D08@llnl.gov>
References: <20110415151736.809c550b.weiny2@llnl.gov> <20110417150614.GA31503@calypso.voltaire.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110417150614.GA31503-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 17, 2011, at 8:06 AM, Alex Netes wrote:

> Hi Ira,
> 
> On 15:17 Fri 15 Apr     , Ira Weiny wrote:
>> 
>> Subject: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid port.  Otherwise leave it as 0
>> 
>> 
>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>> ---
>> opensm/osm_perfmgr.c |    4 +++-
>> 1 files changed, 3 insertions(+), 1 deletions(-)
>> 
>> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
>> index 6a1fa63..3e1575a 100644
>> --- a/opensm/osm_perfmgr.c
>> +++ b/opensm/osm_perfmgr.c
>> @@ -454,7 +454,9 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>> 				  ib_switch_info_is_enhanced_port0(&node->sw->
>> 								   switch_info));
>> 		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
>> -			mon_node->port[port].orig_lid = get_base_lid(node, port);
>> +			mon_node->port[port].orig_lid = 0;
>> +			if (osm_physp_is_valid(&node->physp_table[port]))
>> +				mon_node->port[port].orig_lid = get_base_lid(node, port);
>> 			mon_node->port[port].valid = TRUE;
> 
> Shouldn't this port marked with mon_node->port[port].valid = FALSE ?

New patch below.


Subject: [PATCH 1/5] opensm/perfmgr: set redirect orig_lid and valid flag only when we have a valid port.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 5758587..3578e13 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -454,8 +454,12 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 				  ib_switch_info_is_enhanced_port0(&node->sw->
 								   switch_info));
 		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
-			mon_node->port[port].orig_lid = get_base_lid(node, port);
-			mon_node->port[port].valid = TRUE;
+			mon_node->port[port].orig_lid = 0;
+			mon_node->port[port].valid = FALSE;
+			if (osm_physp_is_valid(&node->physp_table[port])) {
+				mon_node->port[port].orig_lid = get_base_lid(node, port);
+				mon_node->port[port].valid = TRUE;
+			}
 		}
 
 		cl_qmap_insert(&pm->monitored_map, node_guid,
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
