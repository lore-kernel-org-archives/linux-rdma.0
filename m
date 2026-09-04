Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464F04FECF2;
	Fri,  4 Sep 2026 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788553663; cv=none; b=hYqir7SGyOy2JYtLiuE7Z2p424NXnVo/2PC96RfkUBoIYtdecjw6mKYhtvZZs3ttlFFkeFXYMI/cO365TpaBgcTs0dPSHW1ukWWpKfvluCA60RShPhFAnl9LEAsxx+eN7//Kp+6w3aKOdHz9utEz0MES+nFm84wxBmPEpV12iHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788553663; c=relaxed/simple;
	bh=bVEKSvzw0dN9Fi8lwDSBwxTVPXdWFQOikJ8eH4oAuNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bbwSx+71U8HEXenqKAnn6gHCpEmyAd158ihYjZm+xww088qZuqBkz+eU5m+XwqwQR9NwUIVQRTI/bbYnB1BQYErZal6tZb/zuqviRFH0ocCe4iVEtrpEyrTX/JX/w/MCjynxvPQNQqewgPst8c5gihV6EOcdORAJAHaqjFGbqNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id F259E20B7167; Fri,  4 Sep 2026 13:26:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F259E20B7167
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com
Subject: [PATCH net] net: mana: restore the XDP program pointer when pre-allocation fails
Date: Fri,  4 Sep 2026 13:26:40 -0700
Message-ID: <20260904202640.3900685-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_xdp_set() publishes the new program into apc->bpf_prog before it
allocates anything, because mana_pre_alloc_rxbufs() sizes the buffers
from it via mana_get_rxbuf_cfg(). When that allocation fails the
function returns the error directly, skipping the err_dealloc_rxbuffs
label which is the only place that restores the previous pointer.

The attach is reported as failed, so the BPF core drops the reference it
held for the caller and the program can be freed, while apc->bpf_prog
still points at it. The next consumer of mana_xdp_get() - typically
mana_chn_setxdp() from mana_alloc_queues() on the following ifup, or
after a TX timeout reset - then calls bpf_prog_add() on freed memory.

This is reachable from an ordinary "ip link set dev ethX xdp obj ..."
whenever the per-queue RX buffer pre-allocation cannot be satisfied.

Restore the previous program on that error path.

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 53308e139cbe917b074dd381c83546fc74d7b79f..5c9961ee9747ab7747ce2f51eb40f3e7a55510cf 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -208,6 +208,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "XDP: Insufficient memory for tx/rx re-config");
+			apc->bpf_prog = old_prog;
 			return err;
 		}
 
-- 
2.43.0

