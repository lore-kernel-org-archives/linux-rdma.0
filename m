From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma alloc_session_cb
 init
Date: Tue, 5 Apr 2016 03:11:51 +0800
Message-ID: <201604050303.V0jVrIjf%fengguang.wu@intel.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
Cc: kbuild-all@01.org, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

Hi Nicholas,

[auto build test WARNING on v4.6-rc2]
[also build test WARNING on next-20160404]
[cannot apply to rdma/master]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Nicholas-A-Bellinger/ib_srpt-Add-missing-ioctx-buf-dma-alloc_session_cb-init/20160405-023227


coccinelle warnings: (new ones prefixed by >>)

>> drivers/infiniband/ulp/srpt/ib_srpt.c:1987:3-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
