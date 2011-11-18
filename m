From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] dapltest-server segfault seen on recent OFED-1.5.4
 daily build
Date: Fri, 18 Nov 2011 23:48:00 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916EA49A5@ORSMSX101.amr.corp.intel.com>
References: <20111118090155.GB17346@kumars-PC.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111118090155.GB17346-ZuiPNEE88OINxtijsoNbcrBI9BrxbZE7QQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> #0  dapl_llist_remove_entry (head=0x636960, entry=0x7ffff0004bf8) at
> dapl/common/dapl_llist.c:272
> #1  0x00007ffff799fb09 in dapl_sp_remove_cr (sp_ptr=0x6368c0,
> cr_ptr=0x7ffff0004be0) at dapl/common/dapl_sp_util.c:229
> #2  0x00007ffff7998148 in dapli_connection_request (ib_cm_handle=<value
> optimized out>, sp_ptr=0x6368c0, prd_ptr=<value optimized out>,
>     private_data_size=<value optimized out>, evd_ptr=0x633fb0) at
> dapl/common/dapl_cr_callback.c:424
>
> ...
>
> Now, it seems that some time back, a new release of dapl (dapl-2.0.34-
> 1.src.rpm) was
> introduced in OFED-1.5.4. So, I am just wondering if this is a
> regression in the new
> release of dapl?
> Or if anyone is aware of this issue and what could possibly lead to
> this
> dapltest-server segfault then, it would be helpful if someone can shed
> some light.
> 
 
You should have seen a message like "WARNING: overflow event on EVD".

It appears that the default dapltest server allocates too small of a CR EVD for many client test configurations. When it hits the overflow queue case, the CR callback incorrectly frees the CR before it is removed from SP list. In your case, I am guessing that another CR came in on another thread and this memory was reallocated with flink ptr reinitialized. 

Please try the following patches. 

---------
Common: CR EVD overflow causes segfault.

The CR is freed up incorrectly before unlinking with SP.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


diff --git a/dapl/common/dapl_cr_callback.c b/dapl/common/dapl_cr_callback.c
index 3997b38..c58444b 100644
--- a/dapl/common/dapl_cr_callback.c
+++ b/dapl/common/dapl_cr_callback.c
@@ -414,7 +414,6 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
                                                     (DAT_CR_HANDLE) cr_ptr);
 
        if (dat_status != DAT_SUCCESS) {
-               dapls_cr_free(cr_ptr);
                (void)dapls_ib_reject_connection(ib_cm_handle,
                                                 DAT_CONNECTION_EVENT_BROKEN,
                                                 0, NULL);
@@ -423,6 +422,7 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
                dapl_os_lock(&sp_ptr->header.lock);
                dapl_sp_remove_cr(sp_ptr, cr_ptr);
                dapl_os_unlock(&sp_ptr->header.lock);
+               dapls_cr_free(cr_ptr);
                return DAT_INSUFFICIENT_RESOURCES;
        }


----------
dapltest: server CR EVD is too small for multi-client configurations.

Increase default size from 8 to 32.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/test/dapltest/test/dapl_server.c b/test/dapltest/test/dapl_server.c
index 443425c..92e0d21 100644
--- a/test/dapltest/test/dapl_server.c
+++ b/test/dapltest/test/dapl_server.c
@@ -34,7 +34,7 @@
 #undef DFLT_QLEN
 #endif
 
-#define DFLT_QLEN 8            /* default event queue length */
+#define DFLT_QLEN 32           /* default event queue length */
 
 int send_control_data(DT_Tdep_Print_Head * phead,
                      unsigned char *buffp,






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
