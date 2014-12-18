From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] opensm 3.3.19 release
Date: Thu, 18 Dec 2014 06:59:35 -0500
Message-ID: <5492C1A7.5000303@dev.mellanox.co.il>
References: <5491D664.7030909@dev.mellanox.co.il> <CAJ3xEMjWWioZ_CDwAbv+gcHzLuY7=G2zWUuA98ANt=SOuoAsNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjWWioZ_CDwAbv+gcHzLuY7=G2zWUuA98ANt=SOuoAsNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/18/2014 6:40 AM, Or Gerlitz wrote:
> On Wed, Dec 17, 2014 at 9:15 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> There is a new 3.3.19 release of OpenSM. [...] Full list of changes is below.
> 
> It would be helpful if future opensm release announces will have few
> liner writeup of the major
> features/fixes in the release. As for this one... what are they?

It's a bug fix release.

-- Hal

> Or.
> 
> 
>>
>> Albert Chu (1):
>>       osm_perfmgr.c: Output remote port on perfmgr error counter log messages
>>
>> Alex Netes (2):
>>       Better way to handle polling other MASTER SM
>>       osm_req.c: Initialize dest_port_guid in req_determine_mkey
>>
>> Dan Ben Yosef (1):
>>       iba/ib_types.h: Add support for new MAD SM:PortInfoExtended and for modifying PM:PortExtendedSpeedsCounters
>>
>> Daniel Klein (10):
>>       osm_state_mgr.c: Avoid ucast cache invalidation due to errors during initialization
>>       Change osm_subn_t.log_max_size type to uint32_t
>>       osm_mcast_mgr.c: Invalidate cache due to multicast routing errors
>>       complib/cl_dispatcher.c: Check registrations vector size when searching for handlers
>>       osm_mcast_mgr.c: Add MLID to error 0A06 log message
>>       osm_switch.c: Fix potential memory leak due to misuse of realloc
>>       osm_state_mgr.c: Avoid continuing discovery when SM port is unresponsive
>>       osm_sa.c: Check return value from chmod in opensm_dump_to_file
>>       osm_subnet.c: Update MEPI supported devices white list
>>       osm_perfmgr.c: Reset physp_discovered before discovery
>>
>> Hal Rosenstock (34):
>>       osmtest/main.c: Cosmetic change to output for consistency
>>       libvendor/osm_vendor_ibumad_sa.c: Fixed endian in debug log message
>>       doc/performance-manager-HOWTO.txt: Update perfmgr config options documentation
>>       osmtest/osmtest.c: Fix osmtest_get_sm_gid when running osmtest on node other than SM node
>>       osm_state_mgr.c: Cosmetic formatting changes
>>       osmtest/osmtest.c: Cosmetic formatting change
>>       osm_ucast_mgr.c: A couple of cosmetic log message changes in ucast_mgr_route
>>       osm_sa_path_record.c: Better logging for 1F02 error message
>>       osm_sa_multipath_record.c: Better logging for 4514, 4515, and 4505 error messages
>>       osm_subnet.c: Improve sweep_on_trap documentation in generated conf file
>>       osm_dump.c: In dump_topology_node, handle link_width_active of 4 for 8X
>>       osm_console.c: Included unknown speed/width ports in "possible issues"
>>       libvendor/osm_vendor_ibumad.c: Remove GID index 0 check in umad_receiver
>>       osm_sa_path_record.c: Cosmetic formatting changes
>>       osm_console.c: Track and report unknown/speed width ports
>>       osm_subnet.h: Fixed commentary typo
>>       Fix the difference in osm_opensm struct size between OpenSM and plugin(s)
>>       osm_console_io.c: In is_authorized, STRING_UNKNOWN is define
>>       osm_console.c: Fix unknown speed/width port reporting for portstatus command
>>       osm_console.c: Handle LinkSpeed[Ext]Active 0 for portstatus command
>>       osmeventplugin.c: Add include of osm_config.h as first OpenSM include
>>       osm_port_info_rcv.c: In osm_pi_rcv_process, move assert before first log message
>>       osm_vendor_ibumad.h: Use UMAD_MAX_DEVICES for OSM_UMAD_MAX_CAS
>>       osm_subnet.c: Cosmetic formatting change
>>       osm_congestion_control.c: Cosmetic changes
>>       osm_congestion_control.c: Fix endian of node and port GUIDs in some log messages
>>       osm_congestion_control.c: Fix endian of MAD status in cc_rcv_mad
>>       osm_perfmgr.c: Fix endian of MAD status in pc_recv_process
>>       osm_congestion_control.c: In cc_rcv_mad, add attribute ID and modifier to log message
>>       osm_congestion_control.c: Added Mellanox copyright
>>       osm_[subnet congestion_control].c: Cosmetic commentary change
>>       Update (internal) shared library versions
>>       Update package number for OpenSM to 3.3.19 for release
>>       Update opensm_release_notes-3.3.txt
>>
>> Shlomi Nimrodi (3):
>>       osm_link_mgr.c: Fix bug in mlnx extended port info setting
>>       osm_pkey_mgr.c: Use calloc instead of malloc in pkey_mgr_process_physical_port
>>       osm_subnet.[h c]: Fix possibility for open file descriptor issue
>>
>> Tomer Cohen (4):
>>       libvendor/osm_vendor_ibumad.c: memset osm_mad_addr_t before setting fields
>>       osm_config.h.in: Fixed the difference in osm_opensm_t struct size between opensm and plugins
>>       Add missing keyword in partition definition in man page and partition.txt doc
>>       osm_sa.c: Improve ERR 4C05 log message
>>
>> Vladimir Koushnir (4):
>>       osm_sa_path_record.c: Better logging for 1F05 and 1F03 error messages
>>       osm_prtn.c: Change message verbosity for log message in osm_prtn_add_port
>>       Fix turning on first_time_master_sweep flag
>>       osm_lid_mgr.c: Send client reregistration in case of SM LID change
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
