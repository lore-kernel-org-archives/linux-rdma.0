From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-next:master 6181/6533] net/rds/message.c:336:5: sparse:
 symbol 'rds_message_zcopy_from_user' was not declared. Should it be static?
Date: Thu, 8 Mar 2018 18:56:14 +0800
Message-ID: <201803081854.WYn8kS5Y%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: kbuild-all@01.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   c6f1a8c953479b390458e36fb838d96199a5f466
commit: d40a126b16ea851f858f97b0e214d97c8355cecb [6181/6533] rds: refactor zcopy code into rds_message_zcopy_from_user
reproduce:
        # apt-get install sparse
        git checkout d40a126b16ea851f858f97b0e214d97c8355cecb
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/rds/message.c:336:5: sparse: symbol 'rds_message_zcopy_from_user' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
