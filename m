Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69D236F437;
	Mon, 27 Jul 2026 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144946; cv=none; b=gSjTs2kYhll9f6gd2rNHqL8lbAqC1EMBJ+nLpVKKwDqRWbhofq0OBOZc0CttjTAYwuNH3AU9vWTU5Hv9SU34KhV3qs/6/t0XXYtPAp+GvY0ta6f2JYOa7pvTIdWqJeyD5Vc7awIFSw3p2TMHH1SLKDIFiKkssv6I+Obgnsem8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144946; c=relaxed/simple;
	bh=PiFexxv/63o2u/J1QELKyb7j+x37qLVEqk0JktAH1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hOPQZCg3ugUbsE88ucdSQXQEs/wsSmkDqd64q/eQe3UYDVMVGxxyRlgmc8ww9v2akfdvv0zFqokwmEX822LriqzhSCD/Yhpzp0K9awAWLy123f1L7Vw9tWQmBa312so0BYW5/Rwud6BdoJYPZPJ5inygNHy/INnOK/uyPClTMhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i5QfeznJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i5QfeznJ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R9UllS4154511;
	Mon, 27 Jul 2026 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=UO61xM23KinFQFco9FSOtMYhQPc/AbGFT6ejY4z9+
	yM=; b=i5QfeznJAZP49FNCrUZTHOanNI7NRqU3ZX7iFk6+/xZGo5N9IRddo9EJ/
	2+j4jpKY2FWAetWI10v90vePkoQT7IpGKoKHbDzUp2t6lv9IVfJGC5vWv6uq+95t
	7kHzajOJn504ZKopZjiaaG2BpFR7HSe6RjStY+OI3oQPCh+HIQf3KYz7xeKQ78Zs
	dERlNxGaj7tP/kplV4KP+uG/S7xJMUf54BV/mpUyY6vsL08ttObsiwzOoID1EUj/
	X/lQ0T025Ry/VSfHGyYfRhumcdFUcjMYfInl83lmpOvo4KhuUjbNn6/EedVAXoZk
	tqkxaf56z/J5lHBwZMXi3Y5tYEemw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyc78vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 09:35:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66R9QGjR009764;
	Mon, 27 Jul 2026 09:35:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yh4qb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 09:35:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66R9ZVV536176290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 09:35:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7565E20076;
	Mon, 27 Jul 2026 09:35:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EF2920075;
	Mon, 27 Jul 2026 09:35:31 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jul 2026 09:35:31 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
        mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com, pasic@linux.ibm.com,
        gbayer@linux.ibm.com, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister
Date: Mon, 27 Jul 2026 11:35:30 +0200
Message-ID: <20260727093530.968834-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -Ex0jxdPAV7rLypbSJS_B1Hl2CPzgfUq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA5MSBTYWx0ZWRfX4MA6FT21YQAi
 VPg2k966gfn4TWI6izLysSu6sfUb7PQxGNBD6pOQWV/wwXWTIV+UF0LTzGqoAuQ+WQdTkbM+1iR
 Mpev6q8PcgLoWZ0bY6oZLmjPosEAx5hqw6YQ6onghmyXBbU1v53U+iUdaL3iSLfu1kYS9ba7+sk
 vVvZXLgBzIJPsY5KkXRukoOhwPiUd+huTvrmJaKm2wXqUKOjqlo2B7fp5IH6wglVk4tT67Wdl9q
 00t4xapnnGZDjE2fV6VWi1ekP07KIF+2G5XKh/0XPfym870rw2Lo/P3o4TmIk1d9kYLo5vp0d6d
 hmHupieEMputlgzLwrlPcAmY+5eeUNjHi1jNTZk5ihcfXy5VXGoy6ZQS0dGStSIIsuJADX0M53o
 q8D0K3lzpS094kJxmDfZeYAl5U4dFq99jUEgqKXaQbUl+HPx7Ql+aWBZkftkjFqUiXmrT0nDSb4
 3hvS9q53jYTSSrS+23w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA5MSBTYWx0ZWRfX9nnw/RLusy/R
 gHCuFEStcsYAQuY9pZG94BqtXVg2FZzKk/QxBZ24B0ghUezgh8szdJ4eZO875qVsihdL52pu3qH
 ynavxE6UUb5ORoCsP1y7WQftPAM8odU=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a672669 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=j3-GGZ3PBAWOPdPpVlEA:9
X-Proofpoint-GUID: 4rTJSMQnV6OKOOdUU71XWwUsWfdTPJJg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_02,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1011 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270091

dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
look up the dmb_node under dmb_ht_lock, drop the lock and only then
operate on the node's refcount. Nothing keeps the node alive across
that window: __dibs_lo_unregister_dmb() removes the node from the hash
table under the write lock and immediately frees it.

A concurrent final put can therefore free the node between the lookup
and the refcount operation:

CPU0 (attach)                     CPU1 (owner unregisters)

read_lock_bh(&dmb_ht_lock)
find dmb_node (refcnt == 1)
read_unlock_bh(&dmb_ht_lock)
                                  refcount_dec_and_test() 1 -> 0
                                  write_lock_bh(&dmb_ht_lock)
                                  hash_del(&dmb_node->list)
                                  write_unlock_bh(&dmb_ht_lock)
                                  kfree(dmb_node)
refcount_inc_not_zero(&dmb_node->refcnt)  <-- use-after-free

The same window exists for the refcount_dec_and_test() calls in the
detach and unregister paths.

Close the race structurally by making hash table membership and the
refcount transitions atomic with respect to each other:

- Perform the final refcount_dec_and_test() and hash_del() in a single
  dmb_ht_lock write-side critical section, in both the unregister and
  the detach path. Freeing the node still happens after the lock is
  dropped, which is safe because a node whose refcount reached zero has
  left the hash table and can no longer be found.

- This establishes the invariant that any node found in the hash table
  holds at least one reference, and that the final reference can only
  be dropped under the write lock. dibs_lo_attach_dmb() can thus take
  its reference with a plain refcount_inc() while still holding the
  read lock; refcount_inc_not_zero() is no longer needed.

__dibs_lo_unregister_dmb() no longer touches the hash table and is
renamed to dibs_lo_free_dmb() accordingly.

Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
the code to its current location; the race was introduced earlier by
commit c3a910f2380f ("net/smc: implement DMB-merged operations of
loopback-ism").

Tested SMC-D via ISM and dibs loopback.

Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
Cc: stable@vger.kernel.org
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/dibs/dibs_loopback.c | 47 ++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/dibs/dibs_loopback.c b/drivers/dibs/dibs_loopback.c
index 0f2e09311152..fd5caf1e19a8 100644
--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -118,14 +118,9 @@ static int dibs_lo_register_dmb(struct dibs_dev *dibs, struct dibs_dmb *dmb,
 	return rc;
 }
 
-static void __dibs_lo_unregister_dmb(struct dibs_lo_dev *ldev,
-				     struct dibs_lo_dmb_node *dmb_node)
+static void dibs_lo_free_dmb(struct dibs_lo_dev *ldev,
+			     struct dibs_lo_dmb_node *dmb_node)
 {
-	/* remove dmb from hash table */
-	write_lock_bh(&ldev->dmb_ht_lock);
-	hash_del(&dmb_node->list);
-	write_unlock_bh(&ldev->dmb_ht_lock);
-
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
 	folio_put(virt_to_folio(dmb_node->cpu_addr));
 	kfree(dmb_node);
@@ -139,27 +134,33 @@ static int dibs_lo_unregister_dmb(struct dibs_dev *dibs, struct dibs_dmb *dmb)
 	struct dibs_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct dibs_lo_dev *ldev;
 	unsigned long flags;
+	bool last;
 
 	ldev = dibs->drv_priv;
 
 	/* find dmb from hash table */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
 		if (tmp_node->token == dmb->dmb_tok) {
 			dmb_node = tmp_node;
 			break;
 		}
 	}
-	read_unlock_bh(&ldev->dmb_ht_lock);
-	if (!dmb_node)
+	if (!dmb_node) {
+		write_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
+	}
+	last = refcount_dec_and_test(&dmb_node->refcnt);
+	if (last)
+		hash_del(&dmb_node->list);
+	write_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt)) {
+	if (last) {
 		spin_lock_irqsave(&dibs->lock, flags);
 		dibs->dmb_clientid_arr[dmb_node->sba_idx] = NO_DIBS_CLIENT;
 		spin_unlock_irqrestore(&dibs->lock, flags);
 
-		__dibs_lo_unregister_dmb(ldev, dmb_node);
+		dibs_lo_free_dmb(ldev, dmb_node);
 	}
 	return 0;
 }
@@ -188,14 +189,9 @@ static int dibs_lo_attach_dmb(struct dibs_dev *dibs, struct dibs_dmb *dmb)
 		read_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
+	refcount_inc(&dmb_node->refcnt);
 	read_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (!refcount_inc_not_zero(&dmb_node->refcnt))
-		/* the dmb is being unregistered, but has
-		 * not been removed from the hash table.
-		 */
-		return -EINVAL;
-
 	/* provide dmb information */
 	dmb->idx = dmb_node->sba_idx;
 	dmb->dmb_tok = dmb_node->token;
@@ -209,11 +205,12 @@ static int dibs_lo_detach_dmb(struct dibs_dev *dibs, u64 token)
 {
 	struct dibs_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct dibs_lo_dev *ldev;
+	bool last;
 
 	ldev = dibs->drv_priv;
 
 	/* find dmb_node according to dmb->dmb_tok */
-	read_lock_bh(&ldev->dmb_ht_lock);
+	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, token) {
 		if (tmp_node->token == token) {
 			dmb_node = tmp_node;
@@ -221,13 +218,17 @@ static int dibs_lo_detach_dmb(struct dibs_dev *dibs, u64 token)
 		}
 	}
 	if (!dmb_node) {
-		read_unlock_bh(&ldev->dmb_ht_lock);
+		write_unlock_bh(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
-	read_unlock_bh(&ldev->dmb_ht_lock);
+	last = refcount_dec_and_test(&dmb_node->refcnt);
+	if (last)
+		hash_del(&dmb_node->list);
+	write_unlock_bh(&ldev->dmb_ht_lock);
+
+	if (last)
+		dibs_lo_free_dmb(ldev, dmb_node);
 
-	if (refcount_dec_and_test(&dmb_node->refcnt))
-		__dibs_lo_unregister_dmb(ldev, dmb_node);
 	return 0;
 }
 

base-commit: 9dca6104d80f94a285aad6eb6712d004b7151e7d
-- 
2.52.0

