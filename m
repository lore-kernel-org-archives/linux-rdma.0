From: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Subject: libacm fails to build
Date: Thu, 9 Mar 2017 11:25:27 +0100
Message-ID: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm trying to build latest rdma-core but it fails in ibacm because a library
is missing:

[   28s] FAILED: lib/libibacmp.so 
[   28s] : && /usr/bin/cc  -fPIC -fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector-strong -funwind-tables -fasynchronous-unwind-tables -DNDEBUG -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g -DNDEBUG  -Wl,--as-needed -Wl,--no-undefined -Wl,-z,now   -Wl,--version-script,/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/libibacmp.map -shared  -o lib/libibacmp.so ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o  lib/libibverbs.so.1.3.12 lib/libibumad.so.3.1.12 -lpthread && :
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_send_available':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:545: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_close_endpoint':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2471: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_close_dev':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2825: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_post_send':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:514: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:509: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:578: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_record_mc_av':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:650: undefined reference to `acm_gid_index'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_join_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:746: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:748: undefined reference to `acm_free_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:719: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:708: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:712: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:736: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:731: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:778: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_path_sa':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:797: undefined reference to `acm_alloc_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:808: undefined reference to `acm_path_comp_mask'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:810: undefined reference to `acm_increment_counter'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:813: undefined reference to `acm_send_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:814: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:820: undefined reference to `acm_free_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:799: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_sa_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1226: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1230: undefined reference to `acm_query_response'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1231: undefined reference to `acm_free_sa_mad'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_remove_addr':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2412: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_get_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:339: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:342: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:344: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_port_down':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2667: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2683: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_port_up':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2618: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2626: undefined reference to `acm_get_rate'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2662: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2621: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_open_port':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2693: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_dest_timeout':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1721: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1717: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:415: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_query':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1614: undefined reference to `acm_alloc_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1626: undefined reference to `acm_path_comp_mask'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1628: undefined reference to `acm_increment_counter'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1630: undefined reference to `acm_send_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1631: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1638: undefined reference to `acm_free_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1616: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_queue_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1701: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_response':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:932: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:961: undefined reference to `acm_resolve_response'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_complete_queued_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:969: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:974: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_dest_sa_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:995: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_init_path_av':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:686: undefined reference to `acm_gid_index'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_dest_sa_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1009: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:995: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1019: undefined reference to `acm_free_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:999: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_addr_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1139: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1139: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_open_dev':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2738: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_init_port':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2721: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2808: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_join_group':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1399: undefined reference to `acm_alloc_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1405: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_init_join':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1365: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_join_group':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1415: undefined reference to `acm_send_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1416: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_ep_join':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1427: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1437: undefined reference to `acm_get_gid'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1444: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_handle_event':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1472: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_port_join':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1452: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1462: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_acquire_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:374: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:376: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:387: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:383: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_remove_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:362: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_alloc_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:325: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:320: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_add_addr':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2389: undefined reference to `acm_get_gid'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2403: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2383: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1806: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1808: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1849: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1823: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1824: undefined reference to `acm_increment_counter'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1839: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_send_resolve':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1660: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_init_send_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:485: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_send_resolve':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1690: undefined reference to `acm_increment_counter'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1829: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1830: undefined reference to `acm_increment_counter'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_acquire_sgid':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1772: undefined reference to `ib_any_gid'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1787: undefined reference to `acm_if_get_sgid'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_path':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1917: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1905: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_record_path_addr':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:861: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:869: undefined reference to `ib_any_gid'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_path':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1909: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_dest':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1812: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_resolve_path':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1899: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1900: undefined reference to `acm_increment_counter'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_send_resolve':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1663: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_open_endpoint':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2526: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_alloc_ep':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2484: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_get_port':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2420: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_parse_hosts_file':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2278: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2322: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_parse_osm_fullv1_paths':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2104: undefined reference to `acm_get_gid'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2224: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_ep_preload':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2339: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_post_recvs':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2019: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_parse_hosts_file':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2280: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_parse_osm_fullv1':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2237: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2181: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_acm_recv':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1189: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1191: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1192: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1194: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1207: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_addr_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1068: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_validate_addr_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:883: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_addr_req':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1070: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1202: more undefined references to `acm_write' follow
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_process_timeouts':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1494: undefined reference to `acm_format_name'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1496: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_retry_handler':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1546: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `provider_query':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2928: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_set_dest_addr':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:297: undefined reference to `acm_format_name'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_query':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1648: undefined reference to `acm_query_response'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_send_addr_resp':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:906: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_join_group':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1417: undefined reference to `acm_free_sa_mad'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:1401: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_set_options':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2834: undefined reference to `acm_get_opts_file'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2867: undefined reference to `acm_convert_mtu'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2869: undefined reference to `acm_convert_rate'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o: In function `acmp_log_options':
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2885: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2886: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2887: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2888: undefined reference to `acm_write'
[   28s] /home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2889: undefined reference to `acm_write'
[   28s] ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o:/home/abuild/rpmbuild/BUILD/rdma-core-rdma-core-12/ibacm/prov/acmp/src/acmp.c:2890: more undefined references to `acm_write' follow
[   28s] collect2: error: ld returned 1 exit status
[   28s] ninja: build stopped: subcommand failed.
[   28s] error: Bad exit status from /var/tmp/rpm-tmp.ZFAdoS (%build)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
