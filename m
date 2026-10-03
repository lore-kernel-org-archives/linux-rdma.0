Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1332747A894;
	Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045252; cv=none; b=QNWd28N+22tOInVaRiFVlkQ2ycysDO2Z/WdCc2IQiwLL9QqrA9znGtQRQCuioujBzRnNLeeLh+WNGRcN0crkGqlQCBW9HPwZDjB/M7FmPrUlaMS7UGoLYFQlbqzAZXp7jcbvjdRY9BAz0dxPCPJ4OLsRNw2jWzHesscTCCzt/cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045252; c=relaxed/simple;
	bh=8Jpgu807ckWG+qfaJ+TsNrGwOZqOCNkG+A2tBGeaIoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLfdSUMTZnTEHB8n+4kpv8xEvKWFlnZnpO6pLdqXbeG+NhpB+dwMqnB+jS2Jo9CupRi+rruRtAR6sSTOP9ngO0l2+UtZEVA6LiO7ojG5xdBiJ5YjdFkSBAOfDVgdV9Pj0Wvhy1O1Cc2rwmBwD7SfCTlh2Cit0Ms6yDmaTuWbymY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LcApQZeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LcApQZeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB3A1F0089F;
	Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045250;
	bh=/ub/+Gx9bPwwtaANK/Cn8b5+X8YVvEpP6pTinf/0UfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcApQZeQhXUQNzTaLe8vA3GzM2SLsdakXJA0lDbXVYhlNVUG3uRqt4gduvF36+GAZ
	 KdKqpVbrdX1kj0fk4J67/SnMjYBrS68wsdtgt8JJ35DNYQYl4UNKnF8S7CEDan1oZf
	 B0wHRx+xuW/NaMCcpaGvQf11uugT1wfqURIK3H74+yJCSfuosYsc8Y9WST1ECWwrrc
	 swgGuolodKdKfR0NwGe/JeTJQErry8NzIanucL4C4ynJgk1EkCYJvKRjNqiBWDnYP6
	 /j2GA1w7ImuxT/qFzqrvIr81i0x9YwY+oLcrRAQluzJCrhZXodHeW11hbUJWn2JGbH
	 dC8cxQoGk5g3Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	ljp1205831794@gmail.com,
	henrymei@tencent.com
Subject: [PATCH net v4 2/2] net/rds: don't let the rdma_cm destroy an id RDS still owns on route failure
Date: Sat,  3 Oct 2026 09:34:08 -0700
Message-Id: <20261003163408.250568-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163408.250568-1-achender@kernel.org>
References: <20261003163408.250568-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_rdma_cm_event_handler_cmn() hands the return value of
rdma_resolve_route() straight back to the rdma_cm on
RDMA_CM_EVENT_ADDR_RESOLVED.  A synchronous failure there - -ENOMEM
from the route work allocation, an SA query that cannot be set up, a
RoCE route with no usable device - makes addr_handler() destroy the
id the event was delivered on.  That id is ic->i_cm_id, and nothing
clears the pointer: the connection sits in RDS_CONN_CONNECTING with a
freed id until its shutdown calls rdma_disconnect() and
rdma_destroy_id() on it.

The ROUTE_RESOLVED case already avoids this: rds_ib_cm_initiate_connect()
forces a zero return while ic->i_cm_id == cm_id, as the comment there
explains.  Do the same here - drop the connection and return 0 - so
the id stays RDS's to destroy from the shutdown, and the reconnect
gets a fresh one.

Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/rdma_transport.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 09cc2ba23570..7be38be1228e 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -107,9 +107,19 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 			}
 			rdma_set_service_type(cm_id, conn->c_tos);
 			rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
-			/* XXX do we need to clean up if this fails? */
 			ret = rdma_resolve_route(cm_id,
 						 RDS_RDMA_RESOLVE_TIMEOUT_MS);
+			if (ret) {
+				/* A non-zero return has the rdma_cm destroy
+				 * the id, but it is still ic->i_cm_id, which
+				 * the connection's shutdown would then
+				 * disconnect and destroy again.  Drop the
+				 * connection and keep the id for that
+				 * shutdown.
+				 */
+				rds_conn_drop(conn);
+				ret = 0;
+			}
 		}
 		break;
 
-- 
2.25.1

