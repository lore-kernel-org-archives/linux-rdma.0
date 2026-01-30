Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C7218821;
	Fri, 30 Jan 2026 08:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760172; cv=none; b=d4Y0jmlPttWd1Zwexkszu7Oidge9O5hVcKPHdNNChTNkrXCO5it8WY15AGasAw09as1XrWI+b9IpQN6E21WBvimmvGU1BIHscdyunxp7z827rJYgOdFKe7WXJslj0r3R2OhTne9x8qu0c1Gwh4GLbpkahdlwNztq1xu2aotftFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760172; c=relaxed/simple;
	bh=J54oJ4WbesnBUVqGOh1KdeLt/bAseKg0PcZd1rG+qi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eN8EWXaTVNP8gO9MqW76SDuHSAyW5sk4no8vBLlBQOo/Sb7OJ9Gv/O+3ecI0hjIewMJXhc4iEcerwk5Yv8y5PKLHNlvoj/qCcNyuvMeZwJFvt7V3Slb+SbJtRLapkVwDWObE6K6JzmdYkdGTOtxwrgB37rj6CbuSHgHbqIrrtYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SowbgXut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SowbgXut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D34C4CEF7;
	Fri, 30 Jan 2026 08:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769760171;
	bh=J54oJ4WbesnBUVqGOh1KdeLt/bAseKg0PcZd1rG+qi4=;
	h=From:To:Cc:Subject:Date:From;
	b=SowbgXutEN25f93mw99MBhSebcWovLeHlJEZoRtHWOZMM522dBk1BJgGQZOb5I9pM
	 AB9BcxjFKtvnbf7TCHotVQewDCx2YvEwDGticeVIrLExsnrRzm5S92/fqKLC7t8Th+
	 89SWc1W8uUtoU6UlIWcGrRcjIiqmUC2tIdDJUROhOyMQoAKq34sDckF7PXUwH/VCID
	 HVTdmyFKiz4ER7VJ1KBGsFFhwubYBi8y9MHYWzqcDJoCgwiRCfROlfiiY0COa4mwKZ
	 5F5OIrRC5EFFkxQTlCCac4d+YKsLtxDzcUcQ19BigmhirLM/579fmXPNmy3l2/XYhU
	 fkgnfT43Li5FA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v3 0/8] net/rds: RDS-TCP protocol and extension improvements
Date: Fri, 30 Jan 2026 01:02:42 -0700
Message-ID: <20260130080250.696575-1-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is subset 3 of the larger RDS-TCP patch series I posted last
Oct.  The greater series aims to correct multiple rds-tcp issues that
can cause dropped or out of sequence messages.  I've broken it down into
smaller sets to make reviews more manageable.

In this set, we introduce extension headers for byte accounting
and fix several RDS/TCP protocol issues including message preservation
during connection transitions and multipath lane handling.

The entire set can be viewed in the rfc here:
https://lore.kernel.org/netdev/20251022191715.157755-1-achender@kernel.org/

Questions, comments, flames appreciated!
Thanks!
Allison

Change Log:
v2:
   [PATCH net-next v2 1/7] net/rds: new extension header: rdma bytes
     - Fixed AI complaints for uninitalized structs

   [PATCH net-next v2 2/7] net/rds: Encode cp_index in TCP source port
     - Fixed line length checkpatch complaints

   [PATCH net-next v2 3/7] net/rds: rds_tcp_conn_path_shutdown must not
   discard messages
     - Added sk convenience variable to reduce dereferencing and line
       wrapping
     - Fixed line length checkpatch complaints

   [PATCH net-next v2 6/7] net/rds: Use the first lane until
     - Added rds_mprds_cp0_catchup helper to de-nest rds_send_xmit
     - Fixed line length checkpatch complaints

   [PATCH net-next v2 7/7] net/rds: Trigger rds_send_ping() more than
   once
     - Fixed ai complaints for comment clarification

v3:
  [PATCH net-next v3 1/8] net/rds: new extension header: rdma bytes
    - Addressed ai complaints about unpacked/unpadded rds_ext_header_rdma_bytes
    - Added return code checks to rds_message_add_extension 

  [PATCH net-next v3 06/8] net/rds: Update struct rds_statistics to
  use u64 instead of uint64_t
     - NEW

  [PATCH net-next v3 6/8] net/rds: Use the first lane until
    - Fixed Prefer kernel type 'u64' over 'uint64_t' warnings

  [PATCH net-next v3 08/8] net/rds: Trigger rds_send_ping() more than once
    - Addressed ai complaints for comment clarification


Allison Henderson (1):
  net/rds: Update struct rds_statistics to use u64 instead of uint64_t

Gerd Rausch (5):
  net/rds: Encode cp_index in TCP source port
  net/rds: rds_tcp_conn_path_shutdown must not discard messages
  net/rds: Kick-start TCP receiver after accept
  net/rds: Use the first lane until RDS_EXTHDR_NPATHS arrives
  net/rds: Trigger rds_send_ping() more than once

Håkon Bugge (1):
  net/rds: Clear reconnect pending bit

Shamir Rabinovitch (1):
  net/rds: new extension header: rdma bytes

 net/rds/connection.c  |   7 ++-
 net/rds/ib_send.c     |  38 +++++++++---
 net/rds/message.c     |  66 ++++++++++++++++-----
 net/rds/rds.h         | 105 ++++++++++++++++++++--------------
 net/rds/recv.c        |  37 ++++++++++--
 net/rds/send.c        | 130 +++++++++++++++++++++++++++++-------------
 net/rds/stats.c       |   1 +
 net/rds/tcp.c         |   1 +
 net/rds/tcp.h         |   7 ++-
 net/rds/tcp_connect.c |  79 +++++++++++++++++++++++--
 net/rds/tcp_listen.c  |  92 +++++++++++++++++++++++++++---
 net/rds/tcp_recv.c    |   4 ++
 net/rds/tcp_send.c    |   2 +-
 13 files changed, 448 insertions(+), 121 deletions(-)

-- 
2.43.0

