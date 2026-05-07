Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E743CEF9;
	Thu,  7 May 2026 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778166519; cv=none; b=u1FjMqbnxVElWoaZX5+h9w71zWueAyr0CRyr92l5nwMictqAZp3UiNTRyDVoM9a5Dzg0eV9D9TyKto46l0mzqwX2q9rfQzXZtWAouaC4E6Xxv8eWKUNFhl6ws2xWMCRNMBmf9abIsq8P6K89Bar+Gbq1teCHWSQ8k/aI1IFFy6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778166519; c=relaxed/simple;
	bh=1M5MWhV5tnlU3mu77PrAzQWc3jQfbA30Li+CwEUpNY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTa1gIhIoWJCBLEu/zekLwe1h4FK+e8JSQ998iF+0UDh8yfqHLWICt3uDK/vKuRW7LmMZkKWP4HWE1puQctPrL4E7AgjuEcH2ShpjnraROoEloMUhdI3MiXiKbEsedMoU0Zgx4yDmEl7/R08L7txdmlLLQlD1bdfLFOhvZAE9nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiiDb7tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiiDb7tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BFC2BCB2;
	Thu,  7 May 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778166519;
	bh=1M5MWhV5tnlU3mu77PrAzQWc3jQfbA30Li+CwEUpNY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiiDb7trr//CwoVqvvq/7ilREHUF9907YPDciifPVJzlgZTB3rZ9iuFyMZT7CHHyg
	 L4xvncxoGaaZQMS4o/VFtwXp4uANDlRd5fXIeTBdwsFpa40NCyGFTZkBNWjiuIvgVV
	 BtvV+hZRbUuLRo5im1LSualq1XyLaScvk7BGvsdT6Wh40T8QgAjHxXF025TvnCPYkh
	 PSjBAl1Km9WuK/fL2/rStAiyWWJ4/hsYOvsy813VHz/GX1aM2eSCRoyL6BpS1a0K1l
	 UxLDM3VeZ6/JETQkoVLH/nuMbUqy+ZkrT3bBwdZWizcpkAFEiSb9c3x7cnSh6AlfO+
	 ayJVhKT6XSOlw==
From: David Ahern <dsahern@kernel.org>
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	leonro@nvidia.com,
	linux-rdma@vger.kernel.org,
	David Ahern <dahern@nvidia.com>
Subject: [PATCH iproute2-next 2/4] iplink: Update iplink_parse to use netns_get_fd_pid
Date: Thu,  7 May 2026 09:08:33 -0600
Message-ID: <20260507150836.28105-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260507150836.28105-1-dsahern@kernel.org>
References: <20260507150836.28105-1-dsahern@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Ahern <dahern@nvidia.com>

Drop the open coding of proc/pid/ns/net in favor of
netns_get_fd_pid.

Signed-off-by: David Ahern <dahern@nvidia.com>
---
 ip/iplink.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index eae51438..6c4586ee 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -650,19 +650,13 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			if (offload && name == dev)
 				dev = NULL;
 		} else if (strcmp(*argv, "netns") == 0) {
-			int pid;
-
 			NEXT_ARG();
 			if (netns != -1)
 				duparg("netns", *argv);
+			/* try by name then by pid */
 			netns = netns_get_fd(*argv);
-			if (netns < 0 && get_integer(&pid, *argv, 0) == 0) {
-				char path[PATH_MAX];
-
-				snprintf(path, sizeof(path), "/proc/%d/ns/net",
-					 pid);
-				netns = open(path, O_RDONLY);
-			}
+			if (netns < 0)
+				netns = netns_get_fd_pid(*argv);
 			if (netns < 0)
 				invarg("Invalid \"netns\" value\n", *argv);
 
-- 
2.50.1 (Apple Git-155)

