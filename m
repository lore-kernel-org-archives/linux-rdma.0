Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534871;
	b=Es302ThvkiZvwk4ChBdMjujReO20DUtxMxJfIFxrnu4RWF/++jRivPjXu3nHDYZxN7yi
	 R9GLPKlvaYlep2z/Qzh/pg1d2XJmVW9ZhO/Nr+J6CP0IW+Olrgu6BAO8pn2TpHdAjnEjy
	 lNGzeQv6ygiqpSkiUSoWUTyQMj4EzBqzTCerSwXYLCSZaLEuBpY3XIFvS6D6KuHYBJWDG
	 T0vbzA43DM0ffcCmMB3hVIi7b1szh0cjWHOKo8UC98JNbu/4Ol0hB+DdUxrBg8Uo3pi3D
	 VoWEWsAHrq7aeCPTRl4+dcDjFR2fcjCcLBYBFvyASwefaCgzrINHbHSgtu0Z9wtQccw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534871;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=uznZNsQR6edUkI5IFA/dhU9kF7BIa33cXkjQX+jJIXU=;
	b=L2IzyiuWHWUgkQMuJn2gtEG+us8WgiVOFs2Yu0oLFZFw18raMvc5lV4+/oWiDmSP1lmh
	 oz8YfHdm490EWyCID2hMYCuKwdL5Honq4TUh7k9Th8MijaGIP+l7pUC17ZOcAg3C45Tr9
	 ZIveIbIxu4Klr7R3Et/jM26RcyHgUVEAc6+MKZ8oTeSho6rxjPE1xCjS3eHIeVvi4fu+z
	 PUsEBN/FLf1UxXtUySn0a2BxqgvGV0YHpnZrtDlAqXhclZdf9ueBWIfQrBG14vxorGT5m
	 l+RK4hRMOkaZgs5aKIslVcjzpjeVZhSFsZAtCQ0LJ1Fh8+7ce4IfqFfmaFx6uBImeqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Lm+5JlWg;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6587B606A326;
	Tue, 24 Nov 2026 15:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6587B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Lm+5JlWg
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7A6120B7166;
	Tue, 24 Nov 2026 07:40:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7A6120B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534860;
	bh=uznZNsQR6edUkI5IFA/dhU9kF7BIa33cXkjQX+jJIXU=;
	h=From:To:Cc:Subject:Date:From;
	b=Lm+5JlWgQPnXa11Y1v+FRNHyGvsEgFPCdoQvyS4UUQP4ZP2UuDZBfgp5R/AiKDkAO
	 rb1K+Opfi4k+Iw8SylKT9WDcneiPWD4V3x7Opew/KUHAJN8wl0FGKr5lT16hsLwSLq
	 0Po/cj2b13dI+joBZvQMotH17b16zDJ0XWbgYNks=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org,
	shacharr@microsoft.com
Subject: [PATCH net-next v12 0/5] net: mana: concurrent HWC requests
Date: Tue, 24 Nov 2026 15:40:53 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MANA hardware channel starts with room for one request. This series
lets the driver use the depth reported by the PF. It tests the new
channel before publishing it and keeps the depth-one channel when the
reported geometry cannot be used.

Changes since v11:
- Split doorbell validation into a standalone fix. Once ESTABLISH_HWC
  has submitted queue addresses, retain the HWC mappings until the PF
  acknowledges DESTROY_HWC. Bound automatic PCI reprobes after an
  unacknowledged teardown; a still-bound device can retry in place.
- Drop the v11 early returns from CQ and QP destruction. RDMA core can
  release these objects on process exit; the driver must still remove its
  callbacks and release the backing. PD, MR/MW and DM destruction can
  finish locally after a normal posted-command timeout. At that boundary
  the PF has drained old client DMA and invalidated outstanding requests.
  An unposted request or a reset notification is not such a guarantee.
- Publish a batch of requests with one SQ doorbell. Do not post the next
  batch until the previous one finishes. Check posted deadlines before
  accepting or returning a reply so a late CREATE cannot supply a handle.
  A queued caller can detect the timeout even if the sender has not run.
- Check the full-width depth against the 4 KiB descriptor rings. Enforce
  the negotiated transmit and receive limits and remove the redundant
  RDMA minimum-size check. Restore a tested depth-one channel only after
  acknowledged teardown of the failed candidate.

Validation: targeted GCC and Clang W=1 builds and strict 80-column
checkpatch on the series. Bounded host tests cover a two-request batch,
replies before, at and after deadline, RDMA cleanup, unacknowledged HWC
teardown, depth fallback and request sizing. No new hardware, performance
or full-kernel test is claimed.

Previous revision:
https://lore.kernel.org/all/cover.1794751992.git.weh@linux.microsoft.com/

Long Li (5):
  net: mana: validate the HWC doorbell before ringing it
  net: mana: keep HWC queues until the PF acknowledges teardown
  net: mana: protect the HWC response buffer until the sender returns
  net: mana: support concurrent HWC requests
  net: mana: use the reported HWC queue depth

 drivers/infiniband/hw/mana/main.c             |   15 +-
 drivers/infiniband/hw/mana/mr.c               |    6 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |    6 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  165 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |  144 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 1081 +++++++++++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c |    4 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |   58 +-
 include/net/mana/gdma.h                       |   19 +
 include/net/mana/hw_channel.h                 |   66 +-
 include/net/mana/shm_channel.h                |   10 +-
 11 files changed, 1240 insertions(+), 334 deletions(-)


base-commit: eb6d6c80d35449c27471b1874f13066c09a8964d
