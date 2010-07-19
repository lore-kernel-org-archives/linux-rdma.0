From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: some dapl assistance - [PATCH] dapl-2.0 improperly handles pkey
 check/query in host order
Date: Mon, 19 Jul 2010 12:04:13 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010D14039A@orsmsx506.amr.corp.intel.com>
References: <4C344493.2030600@Voltaire.com><E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com><4C3C50CC.7000508@Voltaire.com><E3280858FA94444CA49D2BA02341C9830104493030@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B9894@exil.voltaire.com><E3280858FA94444CA49D2BA02341C983010458ECD5@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B98F3@exil.voltaire.com>
 <E3280858FA94444CA49D2BA02341C983010458EF5E@orsmsx506.amr.corp.intel.com>
 <6D1AA8ED7402FF49AFAB26F0C948ACF5014B9BD0@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6D1AA8ED7402FF49AFAB26F0C948ACF5014B9BD0-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Itay Berman <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
Itay,

>>>OK, we got Intel MPI to run. To test the pkey usage we 
>>>configured it to run over pkey that is not configured on the 
>>>node. In this case the MPI should have failed, but it didn't.
>>>The dapl debug reports the given pkey (0x8001 = 32769).
>>>How can that be?
>>
>>If the pkey override is not valid it uses default idx of 0 and 
>>ignores pkey value given. 

Sorry, verbs pkey_query is network order and the consumer
variable is assumed host order. Please try the following
v2.0 patch (or use 0x0280 without patch):

---

scm, ucm: improperly handles pkey check/query in host order

Convert consumer input to network order before verbs
query pkey check.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index a69261f..73730ef 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -326,7 +326,7 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 
                /* set SL, PKEY values, defaults = 0 */
                hca_ptr->ib_trans.pkey_idx = 0;
-               hca_ptr->ib_trans.pkey = dapl_os_get_env_val("DAPL_IB_PKEY", 0);
+               hca_ptr->ib_trans.pkey = htons(dapl_os_get_env_val("DAPL_IB_PKEY", 0));
                hca_ptr->ib_trans.sl = dapl_os_get_env_val("DAPL_IB_SL", 0);
 
 		/* index provided, get pkey; pkey provided, get index */
@@ -345,10 +345,10 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 				}
 			}
 			if (i == dev_attr.max_pkeys) {
-				dapl_log(DAPL_DBG_TYPE_WARN,
-					 " Warning: new pkey(%d), query (%s)"
-					 " err or key !found, using defaults\n",
-					 hca_ptr->ib_trans.pkey, strerror(errno));
+				dapl_log(DAPL_DBG_TYPE_ERR,
+					 " ERR: new pkey(0x%x), query (%s)"
+					 " err or key !found, using default pkey_idx=0\n",
+					 ntohs(hca_ptr->ib_trans.pkey), strerror(errno));
 			}
 		}
 skip_ib:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
