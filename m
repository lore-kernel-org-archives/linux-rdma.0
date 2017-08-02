From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/2] IB: add const to bin_attribute structures
Date: Wed,  2 Aug 2017 15:31:28 +0530
Message-ID: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Declare bin_attribute structures as const. 
Done using Coccinelle.

Bhumika Goyal (2):
  IB/qib: add const to bin_attribute structures
  IB/hfi1: add const to bin_attribute structures

 drivers/infiniband/hw/hfi1/sysfs.c    | 4 ++--
 drivers/infiniband/hw/qib/qib_sysfs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.9.1
