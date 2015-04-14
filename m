From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [amirv:for-upstream 52/62]
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c:735:5: sparse: symbol
 'handle_neigh_state_change' was not declared. Should it be static?
Date: Tue, 14 Apr 2015 19:52:53 +0800
Message-ID: <201504141939.n2Kcfmrx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

tree:   git://flatbed.openfabrics.org/~amirv/linux.git for-upstream
head:   66a75344a2e5a8e8483cfd6ab1db1c0fbcb56fda
commit: cbaa5ae8702fea9670d77daf95f35b4d38822ad0 [52/62] IB/ipoib: Add cleanup to sendonly multicast objects [ib-next:ipoib-s1]
reproduce:
  # apt-get install sparse
  git checkout cbaa5ae8702fea9670d77daf95f35b4d38822ad0
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:735:5: sparse: symbol 'handle_neigh_state_change' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
