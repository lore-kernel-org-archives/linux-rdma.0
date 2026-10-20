Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465417;
	b=iGkk+TFm9dTo4s/qLUfNnYvdggaHEibIJju5emFdXvfplW3IXEwkypw4rArUgEfRvxC2
	 HNc+imxg2VCZD99nSQ4mzup6LGL3dviA8J02XV1M6S0V398uXSdYT9a98pm1J31W0Irx5
	 wmlMdjC0gSg4vz8zX7DKTfINXZYzExwztjhiVa+0151t8TmcBnh2YG0fzFVfdUfAwNg7A
	 hY1+keA3qAJ1jG5C/l6P8pTf1CqozrLmbI1rtmXJoW+YCrR8ocBMISUXNKKZOeFB1R/44
	 1M0GFwZyj+ah4WmlAliS8LaoJOd84n8+olgzVqfDQUve/uLdweT0vAWFiD9tJyPcLlg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465417;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=uLZoh7Uka7LALZWnh0ZGd+7xRlyTUZ4jcO/1lCjVxes=;
	b=INB/EjPz3NCwJaKhC/SdUV1AAT+al7geOYc1dsxw5nmT5NN8HPmsr+fJk3P8eZNN3DoC
	 Et7jBu9m1/S6UbnzYdoCIhGEWnq4Gq+o9fx4/UkhDuAbzApSgyfhEJgOzaqhumMHTEKVL
	 F56nPVXL4k/jp7M0YM7SK4IE3N38NnX1PL0yWWNTLB2onLA5+r97Kz3wrew3YI74TU0pH
	 DsHGQr8g5BXe+zBGdscPrELzeV0pxEASJR/hvDu5xWN3YwI9RdYyH+dKxmH3AHrBkJOIZ
	 SE7IJJ7ND73T8nkm4RwgNH6Ltm+7NFxfXLWuZDALID/xeYNWNL2oKPTVqaaEvp/PhiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="a/V99TmE";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE80606A320;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a/V99TmE
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465417;
	b=Ro9i959gJjIY8wPimzooWySPB2Z8fh2Hmf1QNeRVN0R1pquMKsm0m0JjLQGFlCyNF/Sa
	 4d5l5uJ9P1qssS6WIOsDtyHMMEjcfCA7OxoZ3f85ePYnf+IVK8meSWntbfTs/Q1xHmg4U
	 zL6wi8vpARJMmtYleWepo5X1LP92a3E5gGNlsVFI3yOhTrIb2kcIoNZSUjEln3KPC84/X
	 VVPPEQboKQtJX0wmJjSjazTm7RyQAwJ+4n7k7nkPAEBidN9am0y5jvmznGTKVoKaCBvUP
	 6fqnURJU4HRQhWlPJWCrgmKAcwhpD5H4JdoyYFrt1k49DmkZqe8AY2Nj04PLG+x7iEQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465417;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=uLZoh7Uka7LALZWnh0ZGd+7xRlyTUZ4jcO/1lCjVxes=;
	b=CLJdniKI1ObmQkTholTnCvsCXpUE9I8BVxs8j0A3LsYO5VtGwSaNUB8V5ewMZO3EL+Hk
	 470JXH98DQt4sS7dGBxg1qNsQMqFg5VtqbDr8Y72qdjnMr699KhZeRqhmYvxJjaX6lUXK
	 qKOtKDeFvpMEEA0K7iQHMuc40vihxXot05VudezlISSWyo+Wi6lyKqEPUzgp8DBgdvcVP
	 m/bq+ngtexjusui1rRrOlqTs1eRlfGf0kedPIhRSbaH5AoUweePS/olosfLyON11k5UHQ
	 MtAI4GVLMpTKvgs7q7UlOjU0mKqLPYPKYrqzMDnpFOm2aaj+RifqjUgaI+txhzwYC0A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7E3D1F000C9;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465417;
	bh=uLZoh7Uka7LALZWnh0ZGd+7xRlyTUZ4jcO/1lCjVxes=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=a/V99TmEJd2+O53AwuxZlMMG4by6MY8ZM7m1I97sGdsOFa9bwNOZUSk8+pdyro+6w
	 4OoIFANlR8ibiFeeQYFUDBImpGplshmhWaRurobgmOEhY3YDJ8DtuZXeQp/LVBAqYx
	 ecZXMhd9huxLe0ZC4g/wjM+8d2Ni3YrzwSEu9hPDEyGHYFCrjxutp7xKZlYHPs14N8
	 0NEAThIB9vMFFLbw+Tt5d4ZtHmaMXor5xskmky0D00L8KaPXOVzNQmdBZD66K8VNUy
	 whU+ZhI8HzofTwHp3aBrW3zpERF2exmfrFtU/7EAkxn/LBpwxuW8XJWy2XX6qZ8sHc
	 dT0IFpJjaETJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 149B6406F8;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Subject: [PATCH rdma-next v2 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Date: Mon, 19 Oct 2026 20:03:27 -0700
Message-Id: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1WNTQ6CMBCFr0Jm7ZhOBRRX3sOwKO0gNYGSthAM4
 e4WXLl4i5f3860Q2FsOcM9W8DzbYN2QjDxloDs1vBitSR6kkKWoZIUTR7QNaucZzU1ylVNbcCE
 hLUbPrV2Otyd40ysceIlQ/6IwNW/WcX/by50N0fnPQZ7pmOwQEpT/QWZCgUpwmTK6El0ejXfKa
 Nefk6Detu0LOVBlLcYAAAA=
X-Change-ID: 20260929-uet-ib-core-d82e941f5e52
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=6042;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=sFFlSa++fT5Z1uSmM7NvspZa9JtaPfiaBKSTJI52v7c=;
 b=cZLgx2bjV5ZmtMIG1FQdLri8EC/JgRUHb4Pn2iNONujZyaFOJ0wRbSejFLD4xpcBVmhpmPozD
 gYexouJsJtgC2XLFnEEdAzFgdqohdFYlYGzobUJ59yn7Dgyqm7ID4Ml
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

Patch 1 widens the uverbs object key. The two new core objects would
otherwise leave drivers no free object keys.

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

To: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

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
 drivers/infiniband/core/cma.c                     |   4 +
 drivers/infiniband/core/device.c                  |  16 +-
 drivers/infiniband/core/nldev.c                   |   4 +
 drivers/infiniband/core/rdma_core.h               |   2 +
 drivers/infiniband/core/restrack.c                |  17 +-
 drivers/infiniband/core/roce_gid_mgmt.c           |   6 +-
 drivers/infiniband/core/user_mad.c                |   4 +-
 drivers/infiniband/core/uverbs.h                  |  15 +
 drivers/infiniband/core/uverbs_cmd.c              | 275 ++++++----
 drivers/infiniband/core/uverbs_std_types.c        |  70 ++-
 drivers/infiniband/core/uverbs_std_types_device.c |  73 ++-
 drivers/infiniband/core/uverbs_std_types_job.c    | 628 ++++++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_mr.c     | 218 +++++++-
 drivers/infiniband/core/uverbs_std_types_qp.c     | 340 +++++++++++-
 drivers/infiniband/core/uverbs_uapi.c             |   2 +
 drivers/infiniband/core/verbs.c                   | 108 +++-
 include/rdma/ib_verbs.h                           | 239 +++++++-
 include/rdma/restrack.h                           |   8 +
 include/rdma/uverbs_ioctl.h                       |   4 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h            | 115 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 100 ++++
 include/uapi/rdma/ib_user_verbs.h                 |  25 +
 24 files changed, 2126 insertions(+), 162 deletions(-)
---
base-commit: 9dd8b9a337af844291edcd9139c927d0f7958dbe
change-id: 20260929-uet-ib-core-d82e941f5e52

Best regards,
--  
Eric Davis <eric.davis@broadcom.com>


