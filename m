Received: from aer-iport-6.cisco.com (aer-iport-6.cisco.com [173.38.203.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B03C988E;
	Fri, 21 Aug 2026 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787348332; cv=none; b=C4MwjxHLFcvZA/j6Aq3UvwHQg2g13BuZ+w2baxDqLTjlBIo/g3mR0hO9J65QnAgk5IS1+Oj3gEKyoDGLtGQgstIugBgGryL5J4Gm7gKE9mF10A2jzbQ0kKPzU1pUS4oeC8Z3C/I0efltQt+HceGLwnN6F/+SKeetXJl4QKrKZBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787348332; c=relaxed/simple;
	bh=fL9I0FIOdljGTeoVp4eM1RD5K7ahN8IClrirStl9klU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQAhBul9/2kFlzPDKxqcTNTA40qFNdEtenu/XUZAEcnJJJyiKbih0Rk6JejbipU3uklcS+CRXGo4nazHkolIKDlCnKRoSMIrYYXy6encfhKF/4eSNh3T4M2L9X7tLry/gIMIGMZhAnAMg15YA9TZd/dx2oMRIBGWiGKyvtypquo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=R4hH6j8g; arc=none smtp.client-ip=173.38.203.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="R4hH6j8g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2159; q=dns/txt;
  s=iport01; t=1787348330; x=1788557930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JyBwlx5IO1iiLzZ8YxacdSgho9wzqqVl4F5mopwsHQE=;
  b=R4hH6j8gzjhRbXPzxo4jwXNeHvZjkjZqYkJqpcqeyrFtj2+73UVljgVM
   GkC6ORv6q0lOxRDdNlhb3DtRFjsUOpSWptJu3RdUniqoBtjOy2DwglT+I
   ofm6C4OJ8UUZZUC24jrEJHLoAqOhtfwttKlyJRXrBdUP9kz0bitvZD647
   H46fsERHmkRiAlwiA6IZbf5kF0V09GmUYr5Z5SFcxrYm4iTjPfsqqnSOk
   Dw8WkzxvFb8NzQxEiLVEJjNa8JbxrhusRTlewlSiSg0VmcPyO7xWWe6jt
   jcFwlLDu7Lb56MKhWWStUO7IMM2YW/Q+plAZ7zzxovSYgOOpBKhqoLfPR
   A==;
X-CSE-ConnectionGUID: a9Hd/yHDQvKF4zoi/0Vv1A==
X-CSE-MsgGUID: w00Nf1UpRYC5EO3XoHy5qA==
X-IPAS-Result: =?us-ascii?q?A0DEAgADxIhq/9JK/pBaglmCGD+BUkNJlCmCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUFAo1sAiY1CA4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdQPBV4F5M4EB3keBZgELFAGBOI1hd?=
 =?us-ascii?q?oR8JxuBSUSBFTKCQQdvhRCFeASDLpNXSIEeA1ksAVUTDQoLBwWBZgM1EioVM?=
 =?us-ascii?q?jwyHYEjPheBDRsGBYEdWU+EECMZNnqBCV6BKylgARIXgQmCBwKCWoIFAgFJQ?=
 =?us-ascii?q?w4HSCILGA1IESw3FBkEPm4Hjl4fggpCATFdCoFlbpZdsCOEKKF2M5dfkw2ZC?=
 =?us-ascii?q?KlDgWoBOYFZMxoIGxWDIlMZD45feAECzmRFMj0BAQcCBw4DC4FokX4BAQ?=
IronPort-Data: A9a23:J82ej6/32NjuFusu5yI2DrUDSH6TJUtcMsCJ2f8bNWPcYEJGY0x3x
 jcaUGDUO//cYmXzc4p1Odyz8xtU6JKHnYA3GQs9pShEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mvyyHjEAX9gWAsYjhNs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2k/bK0UvfdXLVhQ1
 tJEOjcMKUi9mbuflefTpulE3qzPLeHiMZlavjRryivUSK53B5vCWK7No9Rf2V/chOgXQaqYP
 ZdFL2UzKk6ZO3WjOX9PYH46tOW0gX37fiFwo1OOrq1x6G/WpOB0+OWzYYWNJ4fTLSlTtlnA/
 kTIplnhOCAxafG4kgqC0mPxn8aayEsXX6pXTtVU7MVCjFSNy2k7BBQIWF6/pvelzEizR7p3M
 EAa0iQpqKk59EG1CNzwNzW6p36C+BAVQMZZGeA85CmCz6PV50CSAW1sZjNNddkvpsIqbTMt0
 VCNkpXiAjkHmLGcT3OQ8p+Vqjy/MDIfKn9EYyIYJSMM+MXLo4wpiB/LCNF5H8adjtTqGhnzz
 iqMoSx4gK8c5eYIyq+y1VPKmTShot7OVAFdzgzRUnio8UB/aZKpapKA7UXd67BLLO6xQkWIo
 GUAlsG26v4PAZCE0ieKRY0lGLyu4eyCGDvCgFJuFt8q8DHF03upeYdb4Bl4OkZlM89CcjjsC
 GfIsA5c6Jp7OmWrYa5+JYm2DqwC0aH6FM35fvbKb9ZPa956cwrv1Dlnb0OW3kj3nUQsmL15M
 pCeGe6mFXgyF6tq1ny1Sv0b3LttwToxrUvXRJbm31Gk3KCYaXq9V7gIKh2NY/o/4afCpx/am
 /5bNs2X21BFXOj3SjfY/JRVLl0QK3U/Q5fspKR/cOOfLgd4MH8uBuWXwr47fYFh2aNPmY/g5
 W20UEtV4ETwiGeBKgiQbH1nLrT1Uv5CQWkTNCE2eFLt0H85bMP3veEUdoA8ev8s8+kLIeNIc
 sTpsv6oWpxnIgkrMRxEBXUhhOSOrCiWuD8=
IronPort-HdrOrdr: A9a23:xG+T3qHOJkhD+CxFpLqEyMeALOsnbusQ8zAXPo5KJSC9Ffbo8/
 xG88506faZslwssTQb6LO90cq7MBbhHPxOgLX5VI3KNGLbUSmTXeNfBODZrAEIdReSygck78
 ddWpk7LsHsBl5nisu/ygy5H9E8hOSjysmT9IDjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: =?us-ascii?q?9a23=3AAhXSOWpyCrMlBAMGEPEzdaHmUcl0UnGa3Vf8GlG?=
 =?us-ascii?q?bJzp7T7zSEWGOoYoxxg=3D=3D?=
X-Talos-MUID: 9a23:wc3g3glYYpm+evmU2jYndnp9bJ9O7f2TEHo8usgrnJK0MgxhZi602WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,235,1779148800"; 
   d="scan'208";a="56970531"
Received: from aer-l-core-09.cisco.com ([144.254.74.210])
  by aer-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Aug 2026 21:37:35 +0000
Received: from localhost (unknown [10.189.108.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-09.cisco.com (Postfix) with ESMTPS id 8D7041800010E;
	Fri, 21 Aug 2026 21:37:35 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	dtatulea@nvidia.com,
	daniel@iogearbox.net,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v3 2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Fri, 21 Aug 2026 23:37:32 +0200
Message-ID: <675ce8a404cfe305e788a8e273b4091c9a90f867.1787347981.git.jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787347981.git.jtollet@cisco.com>
References: <20260820151558.11015-1-jtollet@cisco.com> <cover.1787347981.git.jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.108.235];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.108.235, [10.189.108.235]
X-Outbound-Node: aer-l-core-09.cisco.com

With AF_XDP on a striding RQ, mlx5e defers releasing XSK buffers until
an MPWQE is refilled. If XSK allocation then returns -ENOMEM,
actual_wq_head is not advanced and a later NAPI poll retries the same
WQE.

mlx5e_free_rx_mpwqe() currently leaves each released slot marked as
releasable. On retry it can therefore call xsk_buff_free() again through
stale pointers after the frames have returned to the XSK pool and been
reallocated.

Mark each slot as released immediately after xsk_buff_free(). The
successful allocation path already clears the bitmap after replacing
all buffers, so retries become idempotent without changing the success
path.

Fault injection forced three consecutive allocation failures for one
selected MPWQE in AF_XDP zero-copy mode. Stock freed the same 16 XSK
buffer pointers on all three attempts, for 48 frees. With this change,
only the initial 16 frees occurred; retries observed a full bitmap, and
a later successful allocation cleared it.

Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
Cc: stable@vger.kernel.org
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7bd0606a5..5fe17d295 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -609,9 +609,12 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi)
 		 * is no way to return the page to userspace when the interface
 		 * goes down.
 		 */
-		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
-			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap))
+		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
+			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap)) {
 				xsk_buff_free(xsk_buffs[i]);
+				__set_bit(i, wi->skip_release_bitmap);
+			}
+		}
 	} else {
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
 			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap)) {
-- 
2.55.0

