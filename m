From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 0/2] IB/hfi1: Fixes for 4.7 rc-6
Date: Fri, 01 Jul 2016 15:56:56 -0700
Message-ID: <20160701225447.19381.90323.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dean Luick <dean.luick@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, Stable <stable@vger.kernel.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are two more patches for the 4.7 RC if possible. One Mike has marked as
stable.

These apply on the RC-5 tree and should apply to your trees without any issue. 

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Mike Marciniszyn (1):
      IB/hfi1: Correct issues with sc5 computation

Tadeusz Struk (1):
      IB/hfi1: Fix sleep inside atomic issue in init_asic_data


 drivers/infiniband/hw/hfi1/chip.c |   21 ++++++++++++++-------
 drivers/infiniband/hw/hfi1/ud.c   |   23 +++--------------------
 2 files changed, 17 insertions(+), 27 deletions(-)

--
-Denny
