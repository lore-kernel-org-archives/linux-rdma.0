From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Subject: opensm segfault in osm_ucast_ftree.c
Date: Thu, 10 May 2012 09:33:31 +0200
Message-ID: <4FAB6F4B.6040409@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: DUGUE SEBASTIEN <Sebastien.Dugue-6ktuUTfB/bM@public.gmane.org>, Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, LOUVET ALEXANDRE <Alexandre.Louvet-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

We recently came accross the following bug in the latest opensm release
(3.3.13)  / OFED 1.5.4.1 on 3 large customer sites.
On these sites, opensm is used to route a fat-tree IB network using the
ftree routing algorithm, either with a root_guid_file or not, depending
on the cluster topology.

Many dumps/stack traces were taken and analysed:

Stack Trace #1:

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x42804950 (LWP 29770)]
0x0000000000466c11 in fabric_dump_hca_ordering (p_ftree=0x966df0) at
osm_ucast_ftree.c:1263
1263            for (j = 0; j < p_sw->down_port_groups_num; j++) {
(gdb) bt
#0  0x0000000000466c11 in fabric_dump_hca_ordering (p_ftree=0x966df0) at
osm_ucast_ftree.c:1263
#1  0x000000000046c6af in do_routing (context=0x966df0) at
osm_ucast_ftree.c:4078
#2  0x000000000045da18 in ucast_mgr_route (r=0x966db0,
osm=0x7ffffffd03c0) at osm_ucast_mgr.c:1049
#3  0x000000000045db68 in osm_ucast_mgr_process (p_mgr=0x7fffffffcf18)
at osm_ucast_mgr.c:1089
#4  0x00000000004508f9 in do_sweep (sm=0x7fffffff0a90) at
osm_state_mgr.c:1317
#5  0x0000000000450dd9 in osm_state_mgr_process (sm=0x7fffffff0a90,
signal=1) at osm_state_mgr.c:1441
#6  0x0000000000448d59 in sm_process (sm=0x7fffffff0a90, signal=1) at
osm_sm.c:87
#7  0x0000000000448ec1 in sm_sweeper (p_ptr=0x7fffffff0a90) at osm_sm.c:127
#8  0x00007f914f95fc4a in __cl_thread_wrapper (arg=0x7fffffff0de0) at
cl_thread.c:57
#9  0x00007f914ed11fc7 in start_thread () from /lib/libpthread.so.0
#10 0x00007f914ea8764d in clone () from /lib/libc.so.6
#11 0x0000000000000000 in ?? ()

Stack trace #2:

Thread 1 (Thread 0x7ffd2ab2e700 (LWP 1098)):
#0  0x00007ffd2d38015e in cl_ptr_vector_at (p_vector=0x7ffd1c983310, index=0, p_element=0x7ffd2ab2db18) at
cl_ptr_vector.c:114
#1  0x000000000044f34d in port_group_destroy (p_group=0x7ffd1c983290) at osm_ucast_ftree.c:466
#2  0x000000000044f3da in hca_destroy (p_ftree=0x6fc780) at osm_ucast_ftree.c:835
#3  fabric_clear (p_ftree=0x6fc780) at osm_ucast_ftree.c:973
#4  0x0000000000453439 in construct_fabric (context=0x6fc780) at osm_ucast_ftree.c:3893
#5  0x000000000044a1e8 in ucast_mgr_route (p_mgr=0x7fff3cc29270) at osm_ucast_mgr.c:1048
#6  osm_ucast_mgr_process (p_mgr=0x7fff3cc29270) at osm_ucast_mgr.c:1099
#7  0x000000000043f8d2 in do_sweep (sm=0x7fff3cc1cde0) at osm_state_mgr.c:1341
#8  0x00000000004401d8 in osm_state_mgr_process (sm=0x7fff3cc1cde0, signal=1) at osm_state_mgr.c:1470
#9  0x000000000043ac1b in sm_process (p_ptr=0x7fff3cc1cde0) at osm_sm.c:88
#10 sm_sweeper (p_ptr=0x7fff3cc1cde0) at osm_sm.c:128
#11 0x00007ffd2d3805fe in __cl_thread_wrapper (arg=&lt;value optimized out&gt;) at cl_thread.c:57
#12 0x00000036996077f1 in start_thread () from /lib64/libpthread.so.0
#13 0x0000003698ee570d in clone () from /lib64/libc.so.6

(gdb) p index
$1 = 0

(gdb) p p_vector
$2 = (const cl_ptr_vector_t * const) 0x7ffd1c983310

(gdb) p *p_vector
$4 = {size = 1, grow_size = 8, capacity = 8, p_ptr_array = 0xff007ffd1c9833a0, state = CL_INITIALIZED}

(gdb) x/15i cl_ptr_vector_at
   0x7ffd2d380150 &lt;cl_ptr_vector_at&gt;:   cmp    %rsi,(%rdi)
   0x7ffd2d380153 &lt;cl_ptr_vector_at+3&gt;: mov    $0x5,%eax
   0x7ffd2d380158 &lt;cl_ptr_vector_at+8&gt;: jbe    0x7ffd2d380167 &lt;cl_ptr_vector_at+23&gt;
   0x7ffd2d38015a &lt;cl_ptr_vector_at+10&gt;:        mov    0x18(%rdi),%rax
=&gt; 0x7ffd2d38015e &lt;cl_ptr_vector_at+14&gt;:        mov    (%rax,%rsi,8),%rax
   0x7ffd2d380162 &lt;cl_ptr_vector_at+18&gt;:        mov    %rax,(%rdx)
   0x7ffd2d380165 &lt;cl_ptr_vector_at+21&gt;:        xor    %eax,%eax
   0x7ffd2d380167 &lt;cl_ptr_vector_at+23&gt;:        repz retq 
   0x7ffd2d380169:      nopl   0x0(%rax)
   0x7ffd2d380170 &lt;cl_ptr_vector_remove&gt;:       mov    (%rdi),%r8
   0x7ffd2d380173 &lt;cl_ptr_vector_remove+3&gt;:     mov    0x18(%rdi),%rdx
   0x7ffd2d380177 &lt;cl_ptr_vector_remove+7&gt;:     sub    $0x1,%r8
   0x7ffd2d38017b &lt;cl_ptr_vector_remove+11&gt;:    mov    (%rdx,%rsi,8),%rax
   0x7ffd2d38017f &lt;cl_ptr_vector_remove+15&gt;:    cmp    %r8,%rsi
   0x7ffd2d380182 &lt;cl_ptr_vector_remove+18&gt;:    mov    %r8,(%rdi)

(gdb) x/10g 0xff007ffd1c9833a0
0xff007ffd1c9833a0:     Cannot access memory at address 0xff007ffd1c9833a0

For all stack traces that were gathered, we always observed that the MSB part of the port group address was overwritten by the 0xff value, hence corrupting valid addresses.

Using git-bisect and ibsim on the ibnetdiscover outputs, it appears that this bug was introduced by commit 81dade3aeb1d5c80472a4f9fef55e9916bb38d3a:

<====
Author: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Date:   Mon Sep 27 09:32:14 2010 -0400

    opensm/osm_ucast_ftree: When roots are not connected, update hop count but not lft
    
    When roots are not connected, neither hops nor lfts are updated for
    root switch port 0s. This causes a problem for multicast (looping) where
    switch port 0s can join.
    
    Solution proposed by Yevgeny is to treat this as updn does and update the
    hop count but not new_lft.
    
    Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
<====

In this commit, the fabric_route_roots() function was patched as follows:

-                       /* set local lft */
-                       p_sw->p_osm_sw->new_lft[lid] = port_num;
+                       if (p_ftree->p_osm->subn.opt.connect_roots) {
+                               /* set local lft */
+                               p_sw->p_osm_sw->new_lft[lid] = port_num;
+                       }

Instead of unconditionnally assigning valid port numbers to the lft table, it now leaves 'holes' filled with the default value OSM_NO_PATH (=255)
Accessing these invalid/unassigned LFT entries yields invalid addresses starting with 0xff as in the above example.

Reproducing this bug using ibsim is easy:
1/ Load a fat-tree topology
2/ Unlink a leaf switch
3/ Start opensm (configured with the ftree routing engine)
4/ Relink the leaf switch

IMHO, commit 81dade3aeb1d5c80472a4f9fef55e9916bb38d3a should be reverted and replaced by the following patch:

<====
 diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index d74ba66..21d132a 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -4015,6 +4015,9 @@ static int construct_fabric(IN void *context)
        OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
                "Max LID in switch LFTs: %u\n", p_ftree->lft_max_lid);
 
+       /* Build the full lid matrices needed for multicast routing */
+       osm_ucast_mgr_build_lid_matrices(&p_ftree->p_osm->sm.ucast_mgr);
+
 Exit:
        if (status != 0) {
                OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
<====

After reverting commit 81dade3aeb1d5c80472a4f9fef55e9916bb38d3a and applying the above patch, we have not observed any multicast loop nor any segmentation fault.

Do you think this solution is acceptable ?

Thanks for your help,

Vincent





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
