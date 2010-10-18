From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] Hang in dat_ia_open()
Date: Mon, 18 Oct 2010 13:22:56 -0700
Message-ID: <4CBCACA0.5030304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070401030508010200030005"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070401030508010200030005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Arlin,

During some error case testing we discovered a hang in dat_ia_open(). A colleague
wrote a test program that duplicates the issue. 

Here is the trace of the hang:

# ./testUdaplDyn
coralxib40:6122:  open_hca: rdma_bind ERR Cannot assign requested address. Is
ib1 configured?
                                                                               
                                <<<<------------   Executable hangs here:


Stack:

(gdb) where
#0  0x00002aaaab5906a8 in __lll_mutex_lock_wait () from /lib64/libpthread.so.0
#1  0x00002aaaab58e3ba in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#2  0x00002aaaab7bd82d in rdma_destroy_id () from /usr/lib64/librdmacm.so.1
#3  0x00002aaaab6b0144 in ?? () from /usr/lib64/libdaplofa.so.2
#4  0x00002aaaab6a7a03 in ?? () from /usr/lib64/libdaplofa.so.2
#5  0x00002aaaab3703fb in dat_ia_openv () from /usr/lib64/libdat2.so
#6  0x00000000004009c6 in isDatDeviceValidDyn(char*) ()
#7  0x0000000000400b87 in main ()
(gdb) 


I checked (the code in) several versions of dapl-2.0 and this problem exists
in all of them including dapl-2.0.30. In this case I happened to use dapl-2.0.27.
The hang is caused due to the erroneous invocation of rdma_destroy_id() twice in a row.

Signed-off-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
--- 

$diff -Nup dapl-2.0.27/dapl/openib_cma/device.c.orig dapl-2.0.27/dapl/openib_cma/device.c
--- dapl-2.0.27/dapl/openib_cma/device.c.orig   2010-10-15 17:19:06.572503024 -0400
+++ dapl-2.0.27/dapl/openib_cma/device.c        2010-10-15 17:19:16.013082441 -0400
@@ -358,7 +358,6 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_N
        }
        ret = rdma_bind_addr(cm_id, (struct sockaddr *)&hca_ptr->hca_address);
        if ((ret) || (cm_id->verbs == NULL)) {
-               rdma_destroy_id(cm_id);
                dapl_log(DAPL_DBG_TYPE_ERR,
                         " open_hca: rdma_bind ERR %s."
                         " Is %s configured?\n", strerror(errno), hca_name);
$


--------------070401030508010200030005
Content-Type: text/plain;
 name="dat_ia_open_hang.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dat_ia_open_hang.patch"

--- dapl-2.0.27/dapl/openib_cma/device.c.orig	2010-10-15 17:19:06.572503024 -0400
+++ dapl-2.0.27/dapl/openib_cma/device.c	2010-10-15 17:19:16.013082441 -0400
@@ -358,7 +358,6 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_N
 	}
 	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&hca_ptr->hca_address);
 	if ((ret) || (cm_id->verbs == NULL)) {
-		rdma_destroy_id(cm_id);
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " open_hca: rdma_bind ERR %s."
 			 " Is %s configured?\n", strerror(errno), hca_name);

--------------070401030508010200030005--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
