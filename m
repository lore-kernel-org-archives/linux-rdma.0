From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv2 2/3] IB/core: added support to use rdma cgroup controller
Date: Sat, 30 Jan 2016 20:29:49 +0530
Message-ID: <CAG53R5X7qdzKy-A4-zCEhTGH6dnbtLEMQzkZGkXdtLwi1FRQhA@mail.gmail.com>
References: <1454154087-27375-3-git-send-email-pandit.parav@gmail.com>
	<201601302114.pjMDNo5j%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <201601302114.pjMDNo5j%fengguang.wu@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

I am able to reproduce it.
Spinning v3 for the fix which will be actually in patch_1.

Parav

On Sat, Jan 30, 2016 at 7:27 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Parav,
>
> [auto build test ERROR on cgroup/for-next]
> [cannot apply to v4.5-rc1 next-20160129]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Parav-Pandit/rdma-controller-support/20160130-194534
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> config: m68k-sun3_defconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m68k
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/rdma/ib_verbs.h:58:0,
>                     from include/rdma/ib_addr.h:47,
>                     from include/rdma/rdma_cm.h:39,
>                     from net/rds/rds.h:7,
>                     from net/rds/af_rds.c:41:
>>> include/linux/cgroup_rdma.h:19:29: error: field 'css' has incomplete type
>      struct cgroup_subsys_state css;
>                                 ^
>
> vim +/css +19 include/linux/cgroup_rdma.h
>
> f74be9d0 Parav Pandit 2016-01-30  13    RDMACG_RESOURCE_POOL_VERB,
> f74be9d0 Parav Pandit 2016-01-30  14    RDMACG_RESOURCE_POOL_HW,
> f74be9d0 Parav Pandit 2016-01-30  15    RDMACG_RESOURCE_POOL_TYPE_MAX,
> f74be9d0 Parav Pandit 2016-01-30  16  };
> f74be9d0 Parav Pandit 2016-01-30  17
> f74be9d0 Parav Pandit 2016-01-30  18  struct rdma_cgroup {
> f74be9d0 Parav Pandit 2016-01-30 @19    struct cgroup_subsys_state      css;
> f74be9d0 Parav Pandit 2016-01-30  20
> f74be9d0 Parav Pandit 2016-01-30  21    spinlock_t      cg_list_lock;   /* protects cgroup resource pool list */
> f74be9d0 Parav Pandit 2016-01-30  22    struct list_head rpool_head;    /* head to keep track of all resource
>
> :::::: The code at line 19 was first introduced by commit
> :::::: f74be9d0a094f209c9b8127317d9ce8d2f5dafea rdmacg: Added rdma cgroup controller.
>
> :::::: TO: Parav Pandit <pandit.parav@gmail.com>
> :::::: CC: 0day robot <fengguang.wu@intel.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
