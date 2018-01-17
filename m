From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH v3 13/13] Add SoftiWarp to kernel build environment
 (fwd)
Date: Wed, 17 Jan 2018 17:14:30 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801171713240.20649@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <alpine.DEB.2.20.1801171713242.20649@hadrien>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

There is a lot of noise in the message below.  But the Coccinelle warning
is indicating that lines 480 and 497 are the same.

julia

---------- Forwarded message ----------
Date: Wed, 17 Jan 2018 23:51:22 +0800
From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: kbuild-JC7UmRfGjtg@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH v3 13/13] Add SoftiWarp to kernel build environment

CC: kbuild-all-JC7UmRfGjtg@public.gmane.org
In-Reply-To: <20180114223603.19961-14-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
References: <20180114223603.19961-14-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
TO: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>

Hi Bernard,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.15-rc8 next-20180117]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Bernard-Metzler/Request-for-Comments-on-SoftiWarp/20180117-214127
config: i386-allmodconfig (attached as .config)
compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

All error/warnings (new ones prefixed by >>):

   In file included from include/asm-generic/percpu.h:7:0,
                    from arch/x86/include/asm/percpu.h:543,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:81,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/ktime.h:24,
                    from include/linux/timer.h:6,
                    from include/linux/netdevice.h:28,
                    from drivers/infiniband/sw/siw/siw_main.c:41:
>> include/linux/percpu-defs.h:91:33: warning: '__pcpu_unique_use_cnt' initialized and declared 'extern'
     extern __PCPU_DUMMY_ATTRS char __pcpu_unique_##name;  \
                                    ^
   include/linux/percpu-defs.h:116:2: note: in expansion of macro 'DEFINE_PER_CPU_SECTION'
     DEFINE_PER_CPU_SECTION(type, name, "")
     ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
>> include/linux/percpu-defs.h:92:26: error: redefinition of '__pcpu_unique_use_cnt'
     __PCPU_DUMMY_ATTRS char __pcpu_unique_##name;   \
                             ^
   include/linux/percpu-defs.h:116:2: note: in expansion of macro 'DEFINE_PER_CPU_SECTION'
     DEFINE_PER_CPU_SECTION(type, name, "")
     ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
   include/linux/percpu-defs.h:91:33: note: previous definition of '__pcpu_unique_use_cnt' was here
     extern __PCPU_DUMMY_ATTRS char __pcpu_unique_##name;  \
                                    ^
   include/linux/percpu-defs.h:116:2: note: in expansion of macro 'DEFINE_PER_CPU_SECTION'
     DEFINE_PER_CPU_SECTION(type, name, "")
     ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:33: warning: 'use_cnt' initialized and declared 'extern'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
                                    ^
   include/linux/percpu-defs.h:93:44: note: in definition of macro 'DEFINE_PER_CPU_SECTION'
     extern __PCPU_ATTRS(sec) __typeof__(type) name;   \
                                               ^~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:33: error: redefinition of 'use_cnt'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
                                    ^
   include/linux/percpu-defs.h:95:19: note: in definition of macro 'DEFINE_PER_CPU_SECTION'
     __typeof__(type) name
                      ^~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
   drivers/infiniband/sw/siw/siw_main.c:274:33: note: previous definition of 'use_cnt' was here
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
                                    ^
   include/linux/percpu-defs.h:93:44: note: in definition of macro 'DEFINE_PER_CPU_SECTION'
     extern __PCPU_ATTRS(sec) __typeof__(type) name;   \
                                               ^~~~
>> drivers/infiniband/sw/siw/siw_main.c:274:8: note: in expansion of macro 'DEFINE_PER_CPU'
    static DEFINE_PER_CPU(atomic_t, use_cnt = ATOMIC_INIT(0));
           ^~~~~~~~~~~~~~
--
   drivers/infiniband/sw/siw/siw_verbs.c: In function 'siw_copy_inline_sgl':
>> drivers/infiniband/sw/siw/siw_verbs.c:806:22: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     sqe->sge[0].laddr = (u64)kbuf;
                         ^
   drivers/infiniband/sw/siw/siw_verbs.c: In function 'siw_post_send':
   drivers/infiniband/sw/siw/siw_verbs.c:974:19: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       sqe->base_mr = (uint64_t)reg_wr(wr)->mr;
                      ^
   In file included from include/linux/printk.h:329:0,
                    from include/linux/kernel.h:14,
                    from arch/x86/include/asm/percpu.h:45,
                    from arch/x86/include/asm/current.h:6,
                    from include/linux/sched.h:12,
                    from include/linux/uaccess.h:5,
                    from drivers/infiniband/sw/siw/siw_verbs.c:41:
   drivers/infiniband/sw/siw/siw_verbs.c: In function 'siw_map_mr_sg':
>> drivers/infiniband/sw/siw/siw_verbs.c:1582:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       OBJ_ID(&mr->mem), i, pble->size, (void *)pble->addr,
                                        ^
   include/linux/dynamic_debug.h:136:9: note: in definition of macro 'dynamic_dev_dbg'
          ##__VA_ARGS__);  \
            ^~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_debug.h:64:2: note: in expansion of macro 'dev_dbg'
     dev_dbg(&(ddev)->base_dev.dev, "cpu%2d %s: " fmt, smp_processor_id(),\
     ^~~~~~~
>> drivers/infiniband/sw/siw/siw_verbs.c:1580:3: note: in expansion of macro 'siw_dbg'
      siw_dbg(mr->mem.hdr.sdev,
      ^~~~~~~
--
   drivers/infiniband/sw/siw/siw_qp.c: In function 'siw_activate_tx':
>> drivers/infiniband/sw/siw/siw_qp.c:1134:28: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       wqe->sqe.sge[0].laddr = (u64)&wqe->sqe.sge[1];
                               ^
--
   drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_try_1seg':
>> drivers/infiniband/sw/siw/siw_qp_tx.c:100:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      memcpy((void *)paddr, &wqe->sqe.sge[1], bytes);
             ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:106:11: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       memcpy((void *)paddr, (void *)sge->laddr, bytes);
              ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:106:26: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       memcpy((void *)paddr, (void *)sge->laddr, bytes);
                             ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:108:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       if (copy_from_user((void *)paddr,
                          ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:109:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
            (const void __user *)sge->laddr,
            ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:129:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        memcpy((void *)paddr, buffer + off, bytes);
               ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:134:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        memcpy((void *)paddr, buffer + off, part);
               ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:148:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        memcpy((void *)(paddr + part),
               ^
   drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_qp_prepare_tx':
>> drivers/infiniband/sw/siw/siw_qp_tx.c:218:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      data = siw_try_1seg(c_tx, (u64)crc);
                                ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:241:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      data = siw_try_1seg(c_tx, (u64)crc);
                                ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:253:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      data = siw_try_1seg(c_tx, (u64)crc);
                                ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:268:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      data = siw_try_1seg(c_tx, (u64)crc);
                                ^
   drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_tx_hdt':
   drivers/infiniband/sw/siw/siw_qp_tx.c:534:24: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       iov[seg].iov_base = (void *)(sge->laddr + sge_off);
                           ^
   drivers/infiniband/sw/siw/siw_qp_tx.c:585:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
          (void *)(sge->laddr + sge_off),
          ^
   drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_qp_sq_proc_tx':
   drivers/infiniband/sw/siw/siw_qp_tx.c:895:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
        wqe->sqe.sge[0].laddr = (u64)&wqe->sqe.sge[1];
                                ^
   drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_fastreg_mr':
   drivers/infiniband/sw/siw/siw_qp_tx.c:1002:22: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     if (&mr->base_mr != (void *)sqe->base_mr) {
                         ^
--
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/random.h:10,
                    from include/linux/net.h:22,
                    from drivers/infiniband/sw/siw/siw_qp_rx.c:42:
   drivers/infiniband/sw/siw/siw_qp_rx.c: In function 'siw_rx_umem':
>> drivers/infiniband/sw/siw/siw_qp_rx.c:139:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        (void *)dest_addr, (void *)umem->fp_addr);
        ^
   include/linux/printk.h:303:37: note: in definition of macro 'pr_warning'
     printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
                                        ^~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_qp_rx.c:137:4: note: in expansion of macro 'pr_warn'
       pr_warn("siw: %s: [QP %d]: bogus addr: %p, %p\n",
       ^~~~~~~
   drivers/infiniband/sw/siw/siw_qp_rx.c:139:24: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        (void *)dest_addr, (void *)umem->fp_addr);
                           ^
   include/linux/printk.h:303:37: note: in definition of macro 'pr_warning'
     printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
                                        ^~~~~~~~~~~
>> drivers/infiniband/sw/siw/siw_qp_rx.c:137:4: note: in expansion of macro 'pr_warn'
       pr_warn("siw: %s: [QP %d]: bogus addr: %p, %p\n",
       ^~~~~~~
   drivers/infiniband/sw/siw/siw_qp_rx.c: In function 'siw_rx_pbl':
   drivers/infiniband/sw/siw/siw_qp_rx.c:227:24: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      if (siw_rx_kva(rctx, (void *)buf_addr, bytes) == bytes) {
                           ^
   drivers/infiniband/sw/siw/siw_qp_rx.c: In function 'siw_proc_send':
   drivers/infiniband/sw/siw/siw_qp_rx.c:558:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
         (void *)(sge->laddr + rctx->sge_off),
         ^
   drivers/infiniband/sw/siw/siw_qp_rx.c: In function 'siw_proc_write':
   drivers/infiniband/sw/siw/siw_qp_rx.c:663:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
        (void *)(rctx->ddp_to + rctx->fpdu_part_rcvd),
        ^
   drivers/infiniband/sw/siw/siw_qp_rx.c: In function 'siw_proc_rresp':
   drivers/infiniband/sw/siw/siw_qp_rx.c:902:25: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      rv = siw_rx_kva(rctx, (void *)(sge->laddr + wqe->processed),
                            ^

coccinelle warnings: (new ones prefixed by >>)

>> drivers/infiniband/sw/siw/siw_main.c:480:5-39: duplicated argument to & or |
   drivers/infiniband/sw/siw/siw_main.c:481:5-41: duplicated argument to & or |

# https://github.com/0day-ci/linux/commit/fbff92c1c5256bd7ea26165e6b36c9b4717ee41d
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout fbff92c1c5256bd7ea26165e6b36c9b4717ee41d
vim +480 drivers/infiniband/sw/siw/siw_main.c

9023f7c8 Bernard Metzler 2018-01-14  415
9023f7c8 Bernard Metzler 2018-01-14  416  static struct siw_device *siw_device_create(struct net_device *netdev)
9023f7c8 Bernard Metzler 2018-01-14  417  {
9023f7c8 Bernard Metzler 2018-01-14  418  	struct siw_device *sdev;
9023f7c8 Bernard Metzler 2018-01-14  419  	struct ib_device *base_dev;
9023f7c8 Bernard Metzler 2018-01-14  420  	struct device *parent = netdev->dev.parent;
9023f7c8 Bernard Metzler 2018-01-14  421
9023f7c8 Bernard Metzler 2018-01-14  422  	sdev = (struct siw_device *)ib_alloc_device(sizeof(*sdev));
9023f7c8 Bernard Metzler 2018-01-14  423  	if (!sdev)
9023f7c8 Bernard Metzler 2018-01-14  424  		goto out;
9023f7c8 Bernard Metzler 2018-01-14  425
9023f7c8 Bernard Metzler 2018-01-14  426  	base_dev = &sdev->base_dev;
9023f7c8 Bernard Metzler 2018-01-14  427
9023f7c8 Bernard Metzler 2018-01-14  428  	if (!parent) {
9023f7c8 Bernard Metzler 2018-01-14  429  		/*
9023f7c8 Bernard Metzler 2018-01-14  430  		 * The loopback device has no parent device,
9023f7c8 Bernard Metzler 2018-01-14  431  		 * so it appears as a top-level device. To support
9023f7c8 Bernard Metzler 2018-01-14  432  		 * loopback device connectivity, take this device
9023f7c8 Bernard Metzler 2018-01-14  433  		 * as the parent device. Skip all other devices
9023f7c8 Bernard Metzler 2018-01-14  434  		 * w/o parent device.
9023f7c8 Bernard Metzler 2018-01-14  435  		 */
9023f7c8 Bernard Metzler 2018-01-14  436  		if (netdev->type != ARPHRD_LOOPBACK) {
9023f7c8 Bernard Metzler 2018-01-14  437  			pr_warn("siw: device %s skipped (no parent dev)\n",
9023f7c8 Bernard Metzler 2018-01-14  438  				netdev->name);
9023f7c8 Bernard Metzler 2018-01-14  439  			ib_dealloc_device(base_dev);
9023f7c8 Bernard Metzler 2018-01-14  440  			sdev = NULL;
9023f7c8 Bernard Metzler 2018-01-14  441  			goto out;
9023f7c8 Bernard Metzler 2018-01-14  442  		}
9023f7c8 Bernard Metzler 2018-01-14  443  		parent = &netdev->dev;
9023f7c8 Bernard Metzler 2018-01-14  444  	}
9023f7c8 Bernard Metzler 2018-01-14  445  	base_dev->iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
9023f7c8 Bernard Metzler 2018-01-14  446  	if (!base_dev->iwcm) {
9023f7c8 Bernard Metzler 2018-01-14  447  		ib_dealloc_device(base_dev);
9023f7c8 Bernard Metzler 2018-01-14  448  		sdev = NULL;
9023f7c8 Bernard Metzler 2018-01-14  449  		goto out;
9023f7c8 Bernard Metzler 2018-01-14  450  	}
9023f7c8 Bernard Metzler 2018-01-14  451
9023f7c8 Bernard Metzler 2018-01-14  452  	sdev->netdev = netdev;
9023f7c8 Bernard Metzler 2018-01-14  453  	list_add_tail(&sdev->list, &siw_devlist);
9023f7c8 Bernard Metzler 2018-01-14  454
9023f7c8 Bernard Metzler 2018-01-14  455  	strcpy(base_dev->name, SIW_IBDEV_PREFIX);
9023f7c8 Bernard Metzler 2018-01-14  456  	strlcpy(base_dev->name + strlen(SIW_IBDEV_PREFIX), netdev->name,
9023f7c8 Bernard Metzler 2018-01-14  457  		IB_DEVICE_NAME_MAX - strlen(SIW_IBDEV_PREFIX));
9023f7c8 Bernard Metzler 2018-01-14  458
9023f7c8 Bernard Metzler 2018-01-14  459  	memset(&base_dev->node_guid, 0, sizeof(base_dev->node_guid));
9023f7c8 Bernard Metzler 2018-01-14  460
9023f7c8 Bernard Metzler 2018-01-14  461  	if (netdev->type != ARPHRD_LOOPBACK) {
9023f7c8 Bernard Metzler 2018-01-14  462  		memcpy(&base_dev->node_guid, netdev->dev_addr, 6);
9023f7c8 Bernard Metzler 2018-01-14  463  	} else {
9023f7c8 Bernard Metzler 2018-01-14  464  		/*
9023f7c8 Bernard Metzler 2018-01-14  465  		 * The loopback device does not have a HW address,
9023f7c8 Bernard Metzler 2018-01-14  466  		 * but connection mangagement lib expects gid != 0
9023f7c8 Bernard Metzler 2018-01-14  467  		 */
9023f7c8 Bernard Metzler 2018-01-14  468  		size_t gidlen = min_t(size_t, strlen(base_dev->name), 6);
9023f7c8 Bernard Metzler 2018-01-14  469
9023f7c8 Bernard Metzler 2018-01-14  470  		memcpy(&base_dev->node_guid, base_dev->name, gidlen);
9023f7c8 Bernard Metzler 2018-01-14  471  	}
9023f7c8 Bernard Metzler 2018-01-14  472  	base_dev->owner = THIS_MODULE;
9023f7c8 Bernard Metzler 2018-01-14  473
9023f7c8 Bernard Metzler 2018-01-14  474  	base_dev->uverbs_cmd_mask =
9023f7c8 Bernard Metzler 2018-01-14  475  	    (1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
9023f7c8 Bernard Metzler 2018-01-14  476  	    (1ull << IB_USER_VERBS_CMD_QUERY_DEVICE) |
9023f7c8 Bernard Metzler 2018-01-14  477  	    (1ull << IB_USER_VERBS_CMD_QUERY_PORT) |
9023f7c8 Bernard Metzler 2018-01-14  478  	    (1ull << IB_USER_VERBS_CMD_ALLOC_PD) |
9023f7c8 Bernard Metzler 2018-01-14  479  	    (1ull << IB_USER_VERBS_CMD_DEALLOC_PD) |
9023f7c8 Bernard Metzler 2018-01-14 @480  	    (1ull << IB_USER_VERBS_CMD_REG_MR) |
9023f7c8 Bernard Metzler 2018-01-14  481  	    (1ull << IB_USER_VERBS_CMD_DEREG_MR) |
9023f7c8 Bernard Metzler 2018-01-14  482  	    (1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
9023f7c8 Bernard Metzler 2018-01-14  483  	    (1ull << IB_USER_VERBS_CMD_CREATE_CQ) |
9023f7c8 Bernard Metzler 2018-01-14  484  	    (1ull << IB_USER_VERBS_CMD_POLL_CQ) |
9023f7c8 Bernard Metzler 2018-01-14  485  	    (1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ) |
9023f7c8 Bernard Metzler 2018-01-14  486  	    (1ull << IB_USER_VERBS_CMD_DESTROY_CQ) |
9023f7c8 Bernard Metzler 2018-01-14  487  	    (1ull << IB_USER_VERBS_CMD_CREATE_QP) |
9023f7c8 Bernard Metzler 2018-01-14  488  	    (1ull << IB_USER_VERBS_CMD_QUERY_QP) |
9023f7c8 Bernard Metzler 2018-01-14  489  	    (1ull << IB_USER_VERBS_CMD_MODIFY_QP) |
9023f7c8 Bernard Metzler 2018-01-14  490  	    (1ull << IB_USER_VERBS_CMD_DESTROY_QP) |
9023f7c8 Bernard Metzler 2018-01-14  491  	    (1ull << IB_USER_VERBS_CMD_POST_SEND) |
9023f7c8 Bernard Metzler 2018-01-14  492  	    (1ull << IB_USER_VERBS_CMD_POST_RECV) |
9023f7c8 Bernard Metzler 2018-01-14  493  	    (1ull << IB_USER_VERBS_CMD_CREATE_SRQ) |
9023f7c8 Bernard Metzler 2018-01-14  494  	    (1ull << IB_USER_VERBS_CMD_MODIFY_SRQ) |
9023f7c8 Bernard Metzler 2018-01-14  495  	    (1ull << IB_USER_VERBS_CMD_QUERY_SRQ) |
9023f7c8 Bernard Metzler 2018-01-14  496  	    (1ull << IB_USER_VERBS_CMD_DESTROY_SRQ) |
9023f7c8 Bernard Metzler 2018-01-14  497  	    (1ull << IB_USER_VERBS_CMD_REG_MR) |
9023f7c8 Bernard Metzler 2018-01-14  498  	    (1ull << IB_USER_VERBS_CMD_DEREG_MR) |
9023f7c8 Bernard Metzler 2018-01-14  499  	    (1ull << IB_USER_VERBS_CMD_POST_SRQ_RECV);
9023f7c8 Bernard Metzler 2018-01-14  500
9023f7c8 Bernard Metzler 2018-01-14  501  	base_dev->node_type = RDMA_NODE_RNIC;
9023f7c8 Bernard Metzler 2018-01-14  502  	memcpy(base_dev->node_desc, SIW_NODE_DESC_COMMON,
9023f7c8 Bernard Metzler 2018-01-14  503  	       sizeof(SIW_NODE_DESC_COMMON));
9023f7c8 Bernard Metzler 2018-01-14  504
9023f7c8 Bernard Metzler 2018-01-14  505  	/*
9023f7c8 Bernard Metzler 2018-01-14  506  	 * Current model (one-to-one device association):
9023f7c8 Bernard Metzler 2018-01-14  507  	 * One Softiwarp device per net_device or, equivalently,
9023f7c8 Bernard Metzler 2018-01-14  508  	 * per physical port.
9023f7c8 Bernard Metzler 2018-01-14  509  	 */
9023f7c8 Bernard Metzler 2018-01-14  510  	base_dev->phys_port_cnt = 1;
9023f7c8 Bernard Metzler 2018-01-14  511
9023f7c8 Bernard Metzler 2018-01-14  512  	base_dev->dev.parent = parent;
9023f7c8 Bernard Metzler 2018-01-14  513  	base_dev->dev.dma_ops = &dma_virt_ops;
9023f7c8 Bernard Metzler 2018-01-14  514
9023f7c8 Bernard Metzler 2018-01-14  515  	base_dev->num_comp_vectors = num_possible_cpus();
9023f7c8 Bernard Metzler 2018-01-14  516  	base_dev->query_device = siw_query_device;
9023f7c8 Bernard Metzler 2018-01-14  517  	base_dev->query_port = siw_query_port;
9023f7c8 Bernard Metzler 2018-01-14  518  	base_dev->get_port_immutable = siw_get_port_immutable;
9023f7c8 Bernard Metzler 2018-01-14  519  	base_dev->query_qp = siw_query_qp;
9023f7c8 Bernard Metzler 2018-01-14  520  	base_dev->modify_port = siw_modify_port;
9023f7c8 Bernard Metzler 2018-01-14  521  	base_dev->query_pkey = siw_query_pkey;
9023f7c8 Bernard Metzler 2018-01-14  522  	base_dev->query_gid = siw_query_gid;
9023f7c8 Bernard Metzler 2018-01-14  523  	base_dev->alloc_ucontext = siw_alloc_ucontext;
9023f7c8 Bernard Metzler 2018-01-14  524  	base_dev->dealloc_ucontext = siw_dealloc_ucontext;
9023f7c8 Bernard Metzler 2018-01-14  525  	base_dev->mmap = siw_mmap;
9023f7c8 Bernard Metzler 2018-01-14  526  	base_dev->alloc_pd = siw_alloc_pd;
9023f7c8 Bernard Metzler 2018-01-14  527  	base_dev->dealloc_pd = siw_dealloc_pd;
9023f7c8 Bernard Metzler 2018-01-14  528  	base_dev->create_ah = siw_create_ah;
9023f7c8 Bernard Metzler 2018-01-14  529  	base_dev->destroy_ah = siw_destroy_ah;
9023f7c8 Bernard Metzler 2018-01-14  530  	base_dev->create_qp = siw_create_qp;
9023f7c8 Bernard Metzler 2018-01-14  531  	base_dev->modify_qp = siw_verbs_modify_qp;
9023f7c8 Bernard Metzler 2018-01-14  532  	base_dev->destroy_qp = siw_destroy_qp;
9023f7c8 Bernard Metzler 2018-01-14  533  	base_dev->create_cq = siw_create_cq;
9023f7c8 Bernard Metzler 2018-01-14  534  	base_dev->destroy_cq = siw_destroy_cq;
9023f7c8 Bernard Metzler 2018-01-14  535  	base_dev->resize_cq = NULL;
9023f7c8 Bernard Metzler 2018-01-14  536  	base_dev->poll_cq = siw_poll_cq;
9023f7c8 Bernard Metzler 2018-01-14  537  	base_dev->get_dma_mr = siw_get_dma_mr;
9023f7c8 Bernard Metzler 2018-01-14  538  	base_dev->reg_user_mr = siw_reg_user_mr;
9023f7c8 Bernard Metzler 2018-01-14  539  	base_dev->dereg_mr = siw_dereg_mr;
9023f7c8 Bernard Metzler 2018-01-14  540  	base_dev->alloc_mr = siw_alloc_mr;
9023f7c8 Bernard Metzler 2018-01-14  541  	base_dev->map_mr_sg = siw_map_mr_sg;
9023f7c8 Bernard Metzler 2018-01-14  542  	base_dev->dealloc_mw = NULL;
9023f7c8 Bernard Metzler 2018-01-14  543
9023f7c8 Bernard Metzler 2018-01-14  544  	base_dev->create_srq = siw_create_srq;
9023f7c8 Bernard Metzler 2018-01-14  545  	base_dev->modify_srq = siw_modify_srq;
9023f7c8 Bernard Metzler 2018-01-14  546  	base_dev->query_srq = siw_query_srq;
9023f7c8 Bernard Metzler 2018-01-14  547  	base_dev->destroy_srq = siw_destroy_srq;
9023f7c8 Bernard Metzler 2018-01-14  548  	base_dev->post_srq_recv = siw_post_srq_recv;
9023f7c8 Bernard Metzler 2018-01-14  549
9023f7c8 Bernard Metzler 2018-01-14  550  	base_dev->attach_mcast = NULL;
9023f7c8 Bernard Metzler 2018-01-14  551  	base_dev->detach_mcast = NULL;
9023f7c8 Bernard Metzler 2018-01-14  552  	base_dev->process_mad = siw_no_mad;
9023f7c8 Bernard Metzler 2018-01-14  553
9023f7c8 Bernard Metzler 2018-01-14  554  	base_dev->req_notify_cq = siw_req_notify_cq;
9023f7c8 Bernard Metzler 2018-01-14  555  	base_dev->post_send = siw_post_send;
9023f7c8 Bernard Metzler 2018-01-14  556  	base_dev->post_recv = siw_post_receive;
9023f7c8 Bernard Metzler 2018-01-14  557
9023f7c8 Bernard Metzler 2018-01-14  558  	base_dev->drain_sq = siw_verbs_sq_flush;
9023f7c8 Bernard Metzler 2018-01-14  559  	base_dev->drain_rq = siw_verbs_rq_flush;
9023f7c8 Bernard Metzler 2018-01-14  560
9023f7c8 Bernard Metzler 2018-01-14  561  	base_dev->iwcm->connect = siw_connect;
9023f7c8 Bernard Metzler 2018-01-14  562  	base_dev->iwcm->accept = siw_accept;
9023f7c8 Bernard Metzler 2018-01-14  563  	base_dev->iwcm->reject = siw_reject;
9023f7c8 Bernard Metzler 2018-01-14  564  	base_dev->iwcm->create_listen = siw_create_listen;
9023f7c8 Bernard Metzler 2018-01-14  565  	base_dev->iwcm->destroy_listen = siw_destroy_listen;
9023f7c8 Bernard Metzler 2018-01-14  566  	base_dev->iwcm->add_ref = siw_qp_get_ref;
9023f7c8 Bernard Metzler 2018-01-14  567  	base_dev->iwcm->rem_ref = siw_qp_put_ref;
9023f7c8 Bernard Metzler 2018-01-14  568  	base_dev->iwcm->get_qp = siw_get_base_qp;
9023f7c8 Bernard Metzler 2018-01-14  569
9023f7c8 Bernard Metzler 2018-01-14  570  	sdev->attrs.version = VERSION_ID_SOFTIWARP;
9023f7c8 Bernard Metzler 2018-01-14  571  	sdev->attrs.vendor_id = SIW_VENDOR_ID;
9023f7c8 Bernard Metzler 2018-01-14  572  	sdev->attrs.sw_version = VERSION_ID_SOFTIWARP;
9023f7c8 Bernard Metzler 2018-01-14  573  	sdev->attrs.max_qp = SIW_MAX_QP;
9023f7c8 Bernard Metzler 2018-01-14  574  	sdev->attrs.max_qp_wr = SIW_MAX_QP_WR;
9023f7c8 Bernard Metzler 2018-01-14  575  	sdev->attrs.max_ord = SIW_MAX_ORD_QP;
9023f7c8 Bernard Metzler 2018-01-14  576  	sdev->attrs.max_ird = SIW_MAX_IRD_QP;
9023f7c8 Bernard Metzler 2018-01-14  577  	sdev->attrs.cap_flags = IB_DEVICE_MEM_MGT_EXTENSIONS;
9023f7c8 Bernard Metzler 2018-01-14  578  	sdev->attrs.max_sge = SIW_MAX_SGE;
9023f7c8 Bernard Metzler 2018-01-14  579  	sdev->attrs.max_sge_rd = SIW_MAX_SGE_RD;
9023f7c8 Bernard Metzler 2018-01-14  580  	sdev->attrs.max_cq = SIW_MAX_CQ;
9023f7c8 Bernard Metzler 2018-01-14  581  	sdev->attrs.max_cqe = SIW_MAX_CQE;
9023f7c8 Bernard Metzler 2018-01-14  582  	sdev->attrs.max_mr = SIW_MAX_MR;
9023f7c8 Bernard Metzler 2018-01-14  583  	sdev->attrs.max_mr_size = rlimit(RLIMIT_MEMLOCK);
9023f7c8 Bernard Metzler 2018-01-14  584  	sdev->attrs.max_pd = SIW_MAX_PD;
9023f7c8 Bernard Metzler 2018-01-14  585  	sdev->attrs.max_mw = SIW_MAX_MW;
9023f7c8 Bernard Metzler 2018-01-14  586  	sdev->attrs.max_fmr = SIW_MAX_FMR;
9023f7c8 Bernard Metzler 2018-01-14  587  	sdev->attrs.max_srq = SIW_MAX_SRQ;
9023f7c8 Bernard Metzler 2018-01-14  588  	sdev->attrs.max_srq_wr = SIW_MAX_SRQ_WR;
9023f7c8 Bernard Metzler 2018-01-14  589  	sdev->attrs.max_srq_sge = SIW_MAX_SGE;
9023f7c8 Bernard Metzler 2018-01-14  590
9023f7c8 Bernard Metzler 2018-01-14  591  	siw_idr_init(sdev);
9023f7c8 Bernard Metzler 2018-01-14  592  	INIT_LIST_HEAD(&sdev->cep_list);
9023f7c8 Bernard Metzler 2018-01-14  593  	INIT_LIST_HEAD(&sdev->qp_list);
9023f7c8 Bernard Metzler 2018-01-14  594  	INIT_LIST_HEAD(&sdev->mr_list);
9023f7c8 Bernard Metzler 2018-01-14  595
9023f7c8 Bernard Metzler 2018-01-14  596  	atomic_set(&sdev->num_ctx, 0);
9023f7c8 Bernard Metzler 2018-01-14  597  	atomic_set(&sdev->num_srq, 0);
9023f7c8 Bernard Metzler 2018-01-14  598  	atomic_set(&sdev->num_qp, 0);
9023f7c8 Bernard Metzler 2018-01-14  599  	atomic_set(&sdev->num_cq, 0);
9023f7c8 Bernard Metzler 2018-01-14  600  	atomic_set(&sdev->num_mr, 0);
9023f7c8 Bernard Metzler 2018-01-14  601  	atomic_set(&sdev->num_pd, 0);
9023f7c8 Bernard Metzler 2018-01-14  602  	atomic_set(&sdev->num_cep, 0);
9023f7c8 Bernard Metzler 2018-01-14  603
9023f7c8 Bernard Metzler 2018-01-14  604  	sdev->numa_node = dev_to_node(parent);
9023f7c8 Bernard Metzler 2018-01-14  605
9023f7c8 Bernard Metzler 2018-01-14  606  	sdev->is_registered = 0;
9023f7c8 Bernard Metzler 2018-01-14  607  out:
9023f7c8 Bernard Metzler 2018-01-14  608  	if (sdev)
9023f7c8 Bernard Metzler 2018-01-14  609  		dev_hold(netdev);
9023f7c8 Bernard Metzler 2018-01-14  610
9023f7c8 Bernard Metzler 2018-01-14  611  	return sdev;
9023f7c8 Bernard Metzler 2018-01-14  612  }
9023f7c8 Bernard Metzler 2018-01-14  613

:::::: The code at line 480 was first introduced by commit
:::::: 9023f7c84571f865bdd45b48e768046ddd8f93b0 Attach/detach SoftiWarp to/from network and RDMA subsystem

:::::: TO: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
:::::: CC: 0day robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
