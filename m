Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E6136358;
	Sat, 11 Jul 2026 02:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783738280; cv=none; b=SuHsV2I6Byy8J6ZM9vphAayr4jPCrHdngShcQnJKWZ9Jr6YHLSnBAqUv7JueMl/qAYNBPj0BBXdw2yoay10w4KVouiCyCspOM07F5Zh6sin7cNP19y/WJtGiRar8C3i9vZKN5DrgOx8UjZWqKlLjvKcK1plCDQRafKyp/R7lQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783738280; c=relaxed/simple;
	bh=bd18IFWQpM0ebcomxZuB4L4ko5eV8jmQgUxrqLup2K4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=BH2JnW2KtQHG/AY0SNx5rNBCrq1XdOamQRJh6t4enN9JVxdZM0mRelA4dfYEQkQUO+4fAgV0hD+ZU8HrzQczfS1ekdav9lE0ji+wHjh9pVjkAO3DJXtthU/fXKiu+L/XO63zmfcqBzh2fxYrRIN2aggT9rLnK7Fid+TrJZ7WkPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUABoD6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUABoD6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34FC1F000E9;
	Sat, 11 Jul 2026 02:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783738279;
	bh=nXlCt7TQl+2YOnusGTjqwb0r34TzcUVXdjnfZeLEByU=;
	h=From:To:Cc:Subject:Date;
	b=iUABoD6e0AQcDY/66yiUjr8s5ujJyayiyTZjoxOX+z5wqMkxrnqEKEtpy918KEAfp
	 W2NdhtJNLPNyVPPA8UQ1RkESkD8tA8J4Qab9lSA5at+WQbEcnobQT3VF3p4Yx75z8t
	 47XjxlQX0KtUgSA1ZGssz8aZV0QEFDqoji6SA9SACv1rdVRZlFoZSZLP3LpIiktrwl
	 BmLaY1RvVo2Is572dcBoOqSp+ad1iyxcAien1Z4w4TUcDougKPPbE0n4kbuLB6eJoH
	 uDlj4MDM8kyUf/5jpcKNtN5lX02n62JpHLDjq0latWc1IeKO1pD4sjAHq1n4ZfdJFz
	 +fkjXyvMWJM4Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net 0/3] net/rds: Bug fix ports
Date: Fri, 10 Jul 2026 19:51:15 -0700
Message-Id: <20260711025118.2449428-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This is a small set of net/rds bug fixes ported from uek to upstream
rds.  I've been working on extending the rds selftest case, but need to
stabilize a few more bugs and the first few fall into net with Fixes
tags. I decided to leverage fable for this set and I thought the ports we
clean and well explained.

[PATCH net 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
   Port: commit 4d4a5551a1d2 ("net/rds: Avoid unpin_user_pages_dirty_lock() in tasklets")
   https://github.com/oracle/linux-uek/commit/4d4a5551a1d2

[PATCH net 2/3] net/rds: hold the socket while an rds_mr references it
   Port: commit c4d69e511f3b ("rds: Add proper refcnt when an RDS MR references an RDS Socket")
   https://github.com/oracle/linux-uek/commit/94549e4732d8

[PATCH net-next 3/7] net/rds: fix rds_message leak in the rds_send_xmit() drop path
  Port: commit 94549e4732d8 ("net/rds: fix rds_message memleak in rds_send_xmit")
  https://github.com/oracle/linux-uek/commit/94549e4732d8

These were carved out of a larger porting effort, but I'll follow up with a few more
targeted for net-net after these land in net.

Question and comments appreciated! 

Thanks,
Allison

Gerd Rausch (1):
  net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Håkon Bugge (1):
  net/rds: hold the socket while an rds_mr references it

Sharath Srinivasan (1):
  net/rds: fix rds_message leak in the rds_send_xmit() drop path

 net/rds/rdma.c | 25 +++++++++++++++++++++----
 net/rds/send.c | 12 ++++++++++--
 2 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.25.1

