From: Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH v3 0/2] fix ib_device_cap_flags bit curruption
Date: Mon,  6 Jun 2016 19:34:38 +0300
Message-ID: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: robert@leblancnet.us, matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This patch set fixes a bit corruption caused by expanding ib_device_cap_flags
enum to 64 bits, that caused a sign extension.
After many discussions regarding the solution, we decided on minimal fix in the
first stage.
Later on, we'll align all the caps enum to BIT/BIT_ULL macros as GKH recommended.
The addition in this vesion is the alignment of the casting method.


Max Gurtovoy (2):
  IB/core: Fix bit curruption in ib_device_cap_flags structure
  IB/core: Align casting method of ib_device_cap_flags enumerations to
    ULL

 include/rdma/ib_verbs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
