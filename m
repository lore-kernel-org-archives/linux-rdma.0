Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10327FB1C;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016479; cv=none; b=d8A8JKMpC2MNwxjXsYOaf4N5FeR5LdnpDBrYP1fdAi9VTCg50Umkl9NGd8d85wzM3yU4KNUkvNW3qTSkix1CHsyNT0c4zWRGDc6cwE0DgNscIrVeAcP31RegYC3UB2cnc65cvV6fY93Y6ELtx0D3/lrAHJMmfbsUDzPWZUFGDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016479; c=relaxed/simple;
	bh=pmO235+sOiP0U982ZnFLaKOB723M7EJvhoJ2eSf6MuU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LfAq+bNlem4UVgjkbCT8SmPM9NVBrYZ3/c8Z2c7Hq3ksKD5eEv3ZXK2+WHONFwYEyYECm6pi5J9dZ/sFOZcMEupDS8xMyuZR9m4849X6qBFerhR50IVrUoCcGX9d+A3wxa1kChqfvYi7qzngh6mNg31/yMfrIx0KysgtnvN0VMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tS/lgKFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tS/lgKFU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E0F0C2BCC7;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016479;
	bh=pmO235+sOiP0U982ZnFLaKOB723M7EJvhoJ2eSf6MuU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=tS/lgKFUV/bkU7syacqwOl7hWcRl10b8t90Qq+D4Uomop0JQnEiehyZ0T+IhNA5F9
	 or356MSwLx3Coe6Pb6W/HlZlHhnGXIxcNgemFv4pjcjvw9tfyOCPV9iM5635x0jBi8
	 +vhiwW690FofpQHDqWcgP/j8u5FhbSuEXhKdK6BGLnWLLh/IppFpanlzMR3WsfhFMH
	 KRo5mxpgR3Yxv3ZraS/q3jojCWBVNCzpJb3ihAWUW/Crc8IKHTBhtWbTZsgCMzvqKZ
	 eh6ApExqkqfMfQ5Cumxb3x95/ol8Y/E/I2YF4UOEeo8kt8YR9LIfT1fp5d71zC5taB
	 TlCey6tasokNw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18617CC6B2D;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Subject: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
Date: Wed, 14 Oct 2026 15:21:09 -0700
Message-Id: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQqDMBAFf0X23AVdamn6K6UHTZ7tFhrLJoog/
 ntTPQ7DzEoJpkh0q1YyzJp0jAWaU0X+1cUnWENhkloutRPHEzJrz340cLgK3LkZWrRCpfgaBl3
 2250sfDqOWDI9DpWm/g2f/zfath9o6aOHegAAAA==
X-Change-ID: 20260929-uet-ib-core-d82e941f5e52
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=5120;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=pmO235+sOiP0U982ZnFLaKOB723M7EJvhoJ2eSf6MuU=;
 b=2j9T//Lxu1ZXKUViHBaBUNaBvHlbFtD1QtbApUyy+slaG1871meEFMzOJg0WNpE0jn5ub3jo8
 9dJPIy9CyNWAoU2Pdm3qTFsS6U8JKaqlT9vXVAioAGdWSysE6Z6mwah
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
 drivers/infiniband/core/uverbs.h                  |  16 +
 drivers/infiniband/core/uverbs_cmd.c              | 261 ++++----
 drivers/infiniband/core/uverbs_main.c             |   5 +
 drivers/infiniband/core/uverbs_std_types.c        |  73 ++-
 drivers/infiniband/core/uverbs_std_types_device.c |  73 ++-
 drivers/infiniband/core/uverbs_std_types_job.c    | 763 ++++++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_mr.c     | 222 ++++++-
 drivers/infiniband/core/uverbs_std_types_qp.c     | 340 +++++++++-
 drivers/infiniband/core/uverbs_uapi.c             |   2 +
 drivers/infiniband/core/verbs.c                   | 109 +++-
 include/rdma/ib_verbs.h                           | 242 ++++++-
 include/rdma/restrack.h                           |   8 +
 include/rdma/uverbs_ioctl.h                       |   4 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h            | 120 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 100 +++
 include/uapi/rdma/ib_user_verbs.h                 |  25 +
 25 files changed, 2270 insertions(+), 161 deletions(-)
---
base-commit: d37e98844afea39a9614cac0de837701263c90f7
change-id: 20260929-uet-ib-core-d82e941f5e52

Best regards,
--  
Eric Davis <eric.davis@broadcom.com>


