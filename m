From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 5/7] IB/opa_vnic: Properly clear Mac Table Digest
Date: Tue, 26 Sep 2017 06:44:13 -0700
Message-ID: <20170926134412.11429.73600.stgit@scvm10.sc.intel.com>
References: <20170926134250.11429.58329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926134250.11429.58329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clear the MAC table digest when the MAC table is freed.

Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
index afa938b..a72278e 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
@@ -139,6 +139,7 @@ void opa_vnic_release_mac_tbl(struct opa_vnic_adapter *adapter)
 	rcu_assign_pointer(adapter->mactbl, NULL);
 	synchronize_rcu();
 	opa_vnic_free_mac_tbl(mactbl);
+	adapter->info.vport.mac_tbl_digest = 0;
 	mutex_unlock(&adapter->mactbl_lock);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
