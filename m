Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283262;
	b=QL2FARuGLfj2pGhrc+eu3MWZ7UJKaGQUSyetAzHxrkUrhn/iETfnXdytBqB8yFw1Sik8
	 tvTdC5aWHx5I+oZ2zpsIlFTEjQmkf1WeA3S1OlVqfSjBBhUM0Wu56r1nu37PEe7/+iXw6
	 GWSMxf8G0AOSKUljshLHgWEEIWBF1F0ONtPBh49q2bRy6uD6fqzaDz+eeYN4H7PPAqMbk
	 z6Q9WxrDiyW6bYbkcIo660Wcr2sgeAsMJvIzOR3HsstHO+3PkqnIBKi17lBY5J/q9pZgr
	 2iFSCwcNaFQveIiPysFgSLyyzag3iEacKeNhzhlCEwc6YcYW6+dlfCMdD/EG7DfqWxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283262;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=dext99DhQ5pPpK2soAG6KBKVRiYmbzDXHsXCNPlWSVM=;
	b=1/AjktMrhSwJTEiVAQcO67SRnlMn1xFHfDKTeOkrSDbDGreGIPettWTZOEg+Dpdby3Qn
	 GStjvL+gZ8cx761c04raQ5zYCqPMRaEcXJvpHADE5A9XLz6NLvR5kJwS4HwcCgPUYLpYp
	 T1xjd69o3xCFRhbIV/n/8rHkEojn+wZVPwP2vlxJJBn1VVFp0it6gPXsoBEVIMJ2WANOO
	 bt25Z+WZjN6krKKU0xhVJUKOJyAs2j5m6UcVTtex7lAmU1kUvJxGPatjAkAw04+rN7Oz1
	 oVr0GJxOkmbZZxtogPGq1ShUTg273kQWb9VnXxSIqYKDFthiR8fnIMxzcMIFx7VyJPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+SforIt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53C60A2620;
	Tue, 10 Nov 2026 04:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+SforIt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283262;
	b=3bqlyGuHOsBX9LQUbjvB5MCi0/DtuskJQbnf+9DfqBRUon2qjypzoVu/pTFvPri+IVbv
	 sRaGZGKliiqXUHbNMyrmRtdXIA81lXiXxv0+OSs+WzwVD9zP6Pk80BWyXOz8TGqYARXPb
	 vwpbIWAQbAfvCM8DTh8yW7INqqJkcAsNoIQ2QSfiHDjfmjLKj6MGokOZI4/G6/5/RtB6S
	 3nDNsVnNccwzzITkpz4bO3xgSvufJR0PLPzBetbz5L5TWza1JnPEvJhpBgC3EGOP1OzYV
	 Wpf1ka15mLLUuMMPECpI3VRqJUbW79e++J/3HKej4HVwm2fkNTiOERUjgp5g2Gwzaog==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283262;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=dext99DhQ5pPpK2soAG6KBKVRiYmbzDXHsXCNPlWSVM=;
	b=2q/B1QM2jUjI1D8FK7taOsYRmx8Cc8l/ZrmCy21vcF5iaxuyJj9ZbMWHj2dozXWgAiNn
	 85QC2eC65crJN0eyuDjYNDV4+N3UvpSEep/prusA9ny82mDtmgqyZU5J1gg36rHSsrLTR
	 wpwm+7DfSR+iEcjZ572FHib04oGjzsB/Xdn/0ZaAJ+SCHneQxx1o61jC5gul1sxU7Ojj+
	 RKsYRAAaiZ9lu/+XHrFV28qObfRSV/O4S/5KM4Vb0K3U9Aomauu+BdUZZZ99f9eV3yRbP
	 pgfw76sGCYkKJ95x0OoDK4cZOadGg7bZdD8+Zlbhz4JTciNTqiUa9nkFrHacuLVIHEQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D455A1F008BC;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283262;
	bh=dext99DhQ5pPpK2soAG6KBKVRiYmbzDXHsXCNPlWSVM=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=g+SforItj/MeVfO7r9FqTvg9oACsMODbRJxBn3U1/ve5r+pLUqM2X/PGyQycsCbgW
	 gs4PqQBGcq/k3IKuavcM4sRu6D9WHafIho+e5QlAvnGFkQAnmIp90FdiIBH0j8Q0Mb
	 UxBP41zYyR7M+R3IAmG2NrZgkZJjicfKhIMi2yRvQc5DwO9LlBMQg5lYufzEIXHKVc
	 tKTe4S9ETJc4z0tYPb+p9eGVPyk+Em5/0h+WF+GNlaooilVW5lfyznBH5P3Z5QizRq
	 P6OGCiyuRQcjKUP0LMnrADhTtO/HwMlaYzbd+LForZSy+HyDK2MD1vrr+poJpUNZwv
	 V3qsPikN14vVg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 645F0487FC;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Subject: [PATCH rdma-next v3 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Date: Mon, 09 Nov 2026 20:00:33 -0800
Message-Id: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/12Oyw7CIBREf6VhLQZo6cOV/2Fc8Li1mLQYoKSm6
 b9LcWNd3MVk7pmZFXlwBjy6FCtyEI03dkqiPBVIDWJ6ADY6acQIq0nHOjxDwEZiZR1g3TLoKtp
 z4Awl4uWgN0tOuyGnR4EnWAK6fy0/yyeosKftz4Pxwbp3bo40I3sJJbQ6lESKCRYE6uTRhtLyK
 p0VWtnxnC6HR/aLHzdGlvBW6ppXPeNlQ/7wbds+RqdE2gUBAAA=
X-Change-ID: 20260929-uet-ib-core-d82e941f5e52
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=7525;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=v2vFOCGwTaibfD9nPQ/j1Li91pHRGlxcnQhqS3KBOxg=;
 b=u0ZjwTrLIK+Q16JmG110eIOJQRfSvFfPcLu+JnYP0W3hyuhem08UqqKsDZ6fet6mLS3CWtTSP
 02X0xtaAqlBCv5TLeGz+rVzjV+kXa8w2WImBQP3vL2PUThWU4HMm8ob
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

Ultra Ethernet defines a reliable unconnected transport. A queue pair
sends to any peer in its job without a connection, incoming traffic is
demultiplexed on a JobID rather than on a connection, and what a device
orders is far weaker than IB or RoCE and varies between devices. None of
that has a home in the current uverbs ABI.

This series adds the generic half. The objects, methods, and attributes
any UET device implements. No driver is part of it, though two already
exist against this ABI. A reference device model that implements all of
it, and HPE's Slingshot driver implementing a large subset. That is the
argument for ib_core carrying this. What is device specific should come
from private interfaces per vendor.

Patch 1 widens the uverbs object key. The three new core objects would
otherwise leave drivers fewer object keys than mlx5 alone uses.

Patches 2-4 expose the transport. The two UET encapsulations as GID
types, the capabilities and limits a device advertises, and IB_QPT_RU
with its 32-bit queue pair number.

Patch 5 widens address handles, which an unconnected peer needs since
it is named by both a network address and a queue pair number.

Patch 6 adds a query for what a queue pair type actually orders.

Patch 7 adds jobs and job keys, the objects an unconnected transport
demultiplexes and authorizes on. A job can be exported to a file
descriptor, so an unprivileged process can join one set up for it.

Patches 8-10 let a queue pair be created ready to send, since a
transport with nothing to negotiate gains nothing from the modify
sequence. Patch 8 is a no-functional-change refactor pulling the
attribute copy out of modify_qp. Patch 9 lets create take those
attributes. Patch 10 adds the attributes a reliable unconnected
transport needs.

Patches 11-13 cover memory registration with a job binding, a chosen
key, derived regions, 64-bit keys for devices whose keys do not fit
in 32 bits, and attaching a region to one queue pair so the network
reaches it only over that QP.

New attributes are optional, so existing userspace is unaffected and a
device without a feature reports it absent rather than failing. The
attributes that restrict access are sent mandatory by userspace, so a
kernel that does not know one refuses the request rather than creating
an object with less protection than was asked for.

Tested against a reference device implementing the ABI, and against rxe
to confirm nothing already upstream regressed. The userspace half is a
matching rdma-core series.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
Changes in v3:
- Rebase on rdma for-next
- Never default RDMA-CM to a UET GID type (2)
- Refuse an RU QP whose number another QP on the device already has,
  until restrack keys RU QPs by more than their number (4)
- Call uverbs_finalize_uobj_create() in AH_EX_CREATE (5), JOB_ALLOC
  and JOB_IMPORT (7)
- Refuse reserved bits in a remote QPN (5, 7)
- Report only the semantics fields and bits uverbs defines, and refuse
  the driver QP type (6)
- Keep a job's address entries on its port, and refuse an import once
  the exporting context is gone (7)
- Release a queried address entry's sgid_attr when the query fails (7)
- Keep the early attr_mask check in ex_modify_qp (8)
- Refuse an RU QP on a device without RU support before any attribute
  is read, and test only the QP type in the create helpers (9, 10)
- Limit a modify of an RU QP to its create attributes, and auto-bind
  its counter on create (9)
- Check and copy only the QP semantics fields comp_mask selects (10)
- Refuse an ordering whose data-ordering size is given as 0 (10)
- Keep a derived region in its parent's job, and refuse a negative
  dma-buf fd (11)
- Order the attached MR's usecnt decrement after clearing attached_qp
  on QP destroy (13)
- Order the attach and detach usecnt updates before the MR's lock is
  released (13)
- Document driver duties for job lifetime, sgid_attr, JobID uniqueness,
  derived regions, rereg of 64-bit keys, unattached regions and QPN
  assignment (3, 4, 7, 11, 12, 13)
- Link to v2: https://patch.msgid.link/20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com

Changes in v2:
- Rebase on rdma for-next
- Refuse the write post_send and post_recv commands on an RU QP (4)
- Read the extended AH attribute with uverbs_copy_from_or_zero() (5, 7)
- Export a job as a uverbs FD object, import it through a raw fd, and
  drop the job revoke on device removal (7)
- Drop the job and job key flags attributes, none was defined (7)
- Require the address table size at job allocation and check each
  index against it (7)
- Use uverbs_finalize_uobj_create() in JKEY_CREATE and
  uverbs_copy_to_struct_or_zero() in JOB_ADDR_QUERY (7)
- Drop IS_ERR() checks on mandatory handles (5, 7)
- Simplify the REG_MR optional attribute handling (11, 12)
- Reword the commit messages of patches 1 and 6
- Link to v1: https://patch.msgid.link/20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com

---
Eric Davis (13):
      RDMA/core: widen the uverbs object key
      RDMA/core: add the UET GID types
      RDMA/core: report the reliable unconnected device capabilities
      RDMA/core: add the reliable unconnected queue pair type
      RDMA/core: extended address handle attributes
      RDMA/core: query the semantics a queue pair type guarantees
      RDMA/core: job and job key objects
      RDMA/uverbs: factor out the queue pair attribute copy
      RDMA/core: create a queue pair ready to send
      RDMA/core: queue pair attributes for unconnected transports
      RDMA/core: extended memory registration
      RDMA/core: 64-bit memory keys
      RDMA/core: attach a memory region to a queue pair

 drivers/infiniband/core/Makefile                  |   3 +-
 drivers/infiniband/core/cache.c                   |  12 +-
 drivers/infiniband/core/cma.c                     |   9 +-
 drivers/infiniband/core/device.c                  |  16 +-
 drivers/infiniband/core/nldev.c                   |  10 +
 drivers/infiniband/core/rdma_core.h               |   2 +
 drivers/infiniband/core/restrack.c                |  19 +-
 drivers/infiniband/core/roce_gid_mgmt.c           |   6 +-
 drivers/infiniband/core/user_mad.c                |   4 +-
 drivers/infiniband/core/uverbs.h                  |  35 ++
 drivers/infiniband/core/uverbs_cmd.c              | 266 +++++----
 drivers/infiniband/core/uverbs_std_types.c        |  74 ++-
 drivers/infiniband/core/uverbs_std_types_device.c |  90 ++-
 drivers/infiniband/core/uverbs_std_types_job.c    | 644 ++++++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_mr.c     | 226 +++++++-
 drivers/infiniband/core/uverbs_std_types_qp.c     | 363 +++++++++++-
 drivers/infiniband/core/uverbs_uapi.c             |   2 +
 drivers/infiniband/core/verbs.c                   | 130 ++++-
 include/rdma/ib_verbs.h                           | 245 +++++++-
 include/rdma/restrack.h                           |   8 +
 include/rdma/uverbs_ioctl.h                       |   6 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h            | 115 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 107 ++++
 include/uapi/rdma/ib_user_verbs.h                 |  27 +
 24 files changed, 2264 insertions(+), 155 deletions(-)
---
base-commit: e50525a486300e5ff8014c9985b8477b2fca0368
change-id: 20260929-uet-ib-core-d82e941f5e52

Best regards,
--  
Eric Davis <eric.davis@broadcom.com>


