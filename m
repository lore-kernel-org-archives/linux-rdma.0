Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5B48987C;
	Sat,  3 Oct 2026 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045251; cv=none; b=MNVZaZJRKQZ9R5LIYwmjgAim17vqrP3V9ExRyDpaA/1x8vbqlx488dXWYnpw6X2NNjbekN1Szy6f2lSwIDdimQ531htpomOv+MeZI70Rcft6u6z9TTa9Gq90YEc9XnqfpU6NBCH2hqQxbuDUDyykpaZB01zqmT4hnzg844n98Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045251; c=relaxed/simple;
	bh=OW+sSLBuHxYDcHRVBBHOjZzfLFX1igHnyFqevcD+yXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eqL0APtC3NgjqqNW7CriPnc8mshiNYjtu7jclTT61cDndFQClc1cxiRRr0LcjiIqT/zXDdZYJNHLkMYjbUlgf1tIOmVA+TiTYZLaFKlFhmK5bHG9ObqmB+38blgn5kKczIcQ/TdjZapEgkz/hBo9WvvPR2fKhHsw/rev2EtlanU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFjMGeYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFjMGeYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ACA1F0089B;
	Sat,  3 Oct 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045249;
	bh=duqSvt+SeHz6peN75yyiEStB8/5NL7DHQ+4M7amcZPg=;
	h=From:To:Cc:Subject:Date;
	b=GFjMGeYh7Tl8U1mSJmjBbS8f//eYRGUJGBOYX3O/4kYxX080VWPQawS1wdUHJYSE7
	 POkuugVd1hqq/1Y/MsCIXRe8tVoHq25+LyJpCjL+Nbe1rEOvTu9yHMdYn/JqTJpfUm
	 TuLWGPQRKZSg+e6ReBiCedEnA5iVkMe8X36KBxsZsjrnKifLNglMH4F7srVxDKNXCw
	 iv9EYjPOJtAimUjTyhaiea7mg30qQlisynr5t7cuieCpR2VrE9UkJfmrHBcoSQPBj1
	 nl4X45rz8EKrdZ2srwf2lN2+SuKspqubuIIoKm3ZBd9jhRyvnFzJrkguXN3cPdk/xE
	 WinS2Z5fiIqUg==
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
Subject: [PATCH net v4 0/2] net/rds: RDMA-CM event handler fixes for non-IB devices
Date: Sat,  3 Oct 2026 09:34:06 -0700
Message-Id: <20261003163408.250568-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v4 of Aohan Mei's fix for the uninitialized transport pointer
in the RDMA-CM event handler (v1 at [1], v2 at [2], v3 at [3]), now a
two-patch set.

  Patch 1 is the fix itself.  v3 only rejected a connect request
  arriving on a non-IB device; the active side can bind an id to one
  as well, and resolving a route on an iWARP id leaves
  cm_id->route.path_rec unset, which the ROUTE_RESOLVED case
  dereferences.  Such a connection is now dropped at ADDR_RESOLVED
  instead of resolving a route.

  Patch 2 fixes a neighbouring problem in the same case: a synchronous
  rdma_resolve_route() failure was handed back to the rdma_cm, which
  then destroyed an id RDS still owns as ic->i_cm_id and would later
  disconnect and destroy again from the connection's shutdown.

On net-next the rdma_cm ids RDS creates are restricted to IB devices
(commit c7fca8aae6fe), which makes the non-IB cases impossible there;
these are the fixes stable kernels without that API need.

Changes since v3 [3]:
 - Patch 1 also drops a connection whose address resolved to a non-IB
   device, before a route is resolved on it (review of v3).
 - New patch 2 for the rdma_resolve_route() failure return.
 - Rebased onto current net.

Changes since v2 [2]:
 - Carried forward; the rejection is limited to
   RDMA_CM_EVENT_CONNECT_REQUEST so that rdma_cm does not destroy
   connection ids RDS still owns.

[1] https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/
[2] https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
[3] https://lore.kernel.org/netdev/20260928044507.335883-1-achender@kernel.org/

Thank you,
Allison


Allison Henderson (1):
  net/rds: don't let the rdma_cm destroy an id RDS still owns on route
    failure

Aohan Mei (1):
  net: rds: fix uninitialized trans dereference in CM event handler

 net/rds/rdma_transport.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

-- 
2.25.1

