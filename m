From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH v1 0/2] Fixes on top of CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical memory access
Date: Mon, 13 Apr 2015 14:56:21 +0200
Message-ID: <cover.1428929103.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Shachar Raindel <raindel@mellanox.com>, Jack Morgenstein <jackm@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, stable@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find one patch to prevent a possible issue partially
addressed by commit 8494057ab5e4 ("IB/uverbs: Prevent integer
overflow in ib_umem_get address arithmetic") (see discussions
in [1]) and another one to add back the possibility of registering
memory mapped at 0 (which is probably not something to be allowed,
but it's probably not up to ib_umem_get() to prevent it).

Changes from v0 [2]:
- don't touch to overflow logic in first patch:
  not modifying the logic here so that the patch can be applied
  even on kernel without the overflow preventing checks,
  and second patch is going to rewrite the check.

- don't break overflow detection in second patch:
  changing less or equal to less comparison broke the overflow
  detection logic regarding to rounding done by PAGE_ALIGN,
  so fixes this by checking for overflow in addr + size,
  then by checking for overflow in PAGE_ALIGN(addr + size).

[1] "Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access"

 http://mid.gmane.org/1428497043.22575.176.camel@opteya.com
 http://marc.info/?i=1428497043.22575.176.camel@opteya.com

[2] [PATCH RESEND 0/2] Fixes on top of CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical memory access

 http://mid.gmane.org/cover.1428523125.git.ydroneaud@opteya.com
 http://marc.info/?i=cover.1428523125.git.ydroneaud@opteya.com

Yann Droneaud (2):
  IB/core: disallow registering 0-sized memory region
  IB/core: don't disallow registering region starting at 0x0

 drivers/infiniband/core/umem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.1.0
