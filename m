From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 09/12] iser-target: Convert to new CQ API
Date: Thu, 25 Feb 2016 10:53:45 +0200
Message-ID: <56CEC119.9000702@dev.mellanox.co.il>
References: <201602250552.AzC8mEaU%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <201602250552.AzC8mEaU%fengguang.wu@intel.com>
Sender: target-devel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: kbuild-all@01.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org


> Hi Christoph,
>
> [auto build test ERROR on target/master]
> [also build test ERROR on v4.5-rc5 next-20160224]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Sagi-Grimberg/iser-target-patches-for-4-6/20160225-012959
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
> config: s390-allmodconfig (attached as .config)
> reproduce:
>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=s390
>
> Note: the linux-review/Sagi-Grimberg/iser-target-patches-for-4-6/20160225-012959 HEAD 587105db403a346e5e1b003873f189e0d174efe5 builds fine.
>        It only hurts bisectibility.
>
> All errors (new ones prefixed by >>):
>
>     drivers/infiniband/ulp/isert/ib_isert.c: In function 'isert_beacon_done':
>>> drivers/infiniband/ulp/isert/ib_isert.c:3231:2: error: too few arguments to function 'isert_print_wc'
>       isert_print_wc(wc);
>       ^
>     drivers/infiniband/ulp/isert/ib_isert.c:1541:1: note: declared here
>      isert_print_wc(struct ib_wc *wc, const char *type)
>      ^

OK, that's my fault...

Nic, care to fold this in the patch?

--
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c 
b/drivers/infiniband/ulp/isert/ib_isert.c
index 76ff338..4269f22 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3228,7 +3228,7 @@ isert_beacon_done(struct ib_cq *cq, struct ib_wc *wc)
  {
         struct isert_conn *isert_conn = wc->qp->qp_context;

-       isert_print_wc(wc);
+       isert_print_wc(wc, "beacon");

         isert_info("conn %p completing wait_comp_err\n", isert_conn);
         complete(&isert_conn->wait_comp_err);
--

Patch 12/12 drops this anyways...
