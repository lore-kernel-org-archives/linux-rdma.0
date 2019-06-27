From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 81/95] IB/hfi1: Handle wakeup of orphaned QPs for pio
Date: Wed, 26 Jun 2019 20:30:06 -0400
Message-ID: <20190627003021.19867-81-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 099a884ba4c00145cef283d36e050726311c2e95 ]

Once a send context is taken down due to a link failure, any QPs waiting
for pio credits will stay on the waitlist indefinitely.

Fix by wakeing up all QPs linked to piowait list.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index a1de566fe95e..1ee47838d4de 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -952,6 +952,22 @@ void sc_disable(struct send_context *sc)
 		}
 	}
 	spin_unlock(&sc->release_lock);
+
+	write_seqlock(&sc->waitlock);
+	while (!list_empty(&sc->piowait)) {
+		struct iowait *wait;
+		struct rvt_qp *qp;
+		struct hfi1_qp_priv *priv;
+
+		wait = list_first_entry(&sc->piowait, struct iowait, list);
+		qp = iowait_to_qp(wait);
+		priv = qp->priv;
+		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
+		hfi1_qp_wakeup(qp, RVT_S_WAIT_PIO | HFI1_S_WAIT_PIO_DRAIN);
+	}
+	write_sequnlock(&sc->waitlock);
+
 	spin_unlock_irq(&sc->alloc_lock);
 }
 
-- 
2.20.1
