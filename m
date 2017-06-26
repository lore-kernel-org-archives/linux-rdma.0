From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Mon, 26 Jun 2017 22:33:16 +0800
Message-ID: <201706262212.SMz0YaLP%fengguang.wu@intel.com>
References: <20170626085313.6052-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626085313.6052-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yuval,

[auto build test ERROR on rdma/master]
[also build test ERROR on v4.12-rc7 next-20170626]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Yuval-Shaia/IB-Move-PCI-dependency-from-root-KConfig-to-HW-s-KConfigs/20170626-185305
base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
config: blackfin-allyesconfig (attached as .config)
compiler: bfin-uclinux-gcc (GCC) 6.2.0
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=blackfin 

All error/warnings (new ones prefixed by >>):

   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:0:
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:473:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(rx_msgunmap);  /* for dma_unmap_single() */
     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:496:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(tx_msgunmap);  /* for dma_unmap_single() */
     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_map_tx_pages':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1540:19: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
     __u64 *pages = tx->tx_pages;
                      ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_fmr_pool_map':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1619:19: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
     __u64 *pages = tx->tx_pages;
                      ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1620:24: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
     bool is_rx = (rd != tx->tx_rd);
                           ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1685:28: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
        n = ib_map_mr_sg(mr, tx->tx_frags,
                               ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1686:10: error: 'struct kib_tx' has no member named 'tx_nfrags'
           tx->tx_nfrags, NULL, PAGE_SIZE);
             ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1687:25: error: 'struct kib_tx' has no member named 'tx_nfrags'
        if (unlikely(n != tx->tx_nfrags)) {
                            ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1689:18: error: 'struct kib_tx' has no member named 'tx_nfrags'
                n, tx->tx_nfrags);
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^~~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1688:6: note: in expansion of macro 'CERROR'
         CERROR("Failed to map mr %d/%d elements\n",
         ^~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_destroy_tx_pool':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1987:9: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
      if (tx->tx_pages)
            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:18: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
       LIBCFS_FREE(tx->tx_pages,
                     ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_pages,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1990:19: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
            sizeof(*tx->tx_pages));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^~~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_pages,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:18: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
       LIBCFS_FREE(tx->tx_pages,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1991:9: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
      if (tx->tx_frags)
            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:18: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
       LIBCFS_FREE(tx->tx_frags,
                     ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_frags,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1994:20: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
             sizeof(*tx->tx_frags));
                       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^~~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_frags,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:18: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
       LIBCFS_FREE(tx->tx_frags,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1995:9: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
      if (tx->tx_wrq)
            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:18: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_wrq,
                     ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_wrq,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1998:19: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
            sizeof(*tx->tx_wrq));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^~~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_wrq,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:18: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_wrq,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1999:9: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
      if (tx->tx_sge)
            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:18: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_sge,
                     ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_sge,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2002:19: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
            sizeof(*tx->tx_sge));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^~~~~~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_sge,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:18: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_sge,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2003:9: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
      if (tx->tx_rd)
            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:18: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_rd,
                     ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_rd,
       ^~~~~~~~~~~
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:18: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
       LIBCFS_FREE(tx->tx_rd,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/blackfin/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_create_tx_pool':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2066:32: error: 'struct kib_tx' has no member named 'tx_pages'; did you mean 'tx_pool'?
          LNET_MAX_IOV * sizeof(*tx->tx_pages));
                                   ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
--
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:0:
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:473:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(rx_msgunmap);  /* for dma_unmap_single() */
     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:496:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(tx_msgunmap);  /* for dma_unmap_single() */
     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_tx_done':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:82:4: error: 'struct kib_tx' has no member named 'tx_nwrq'
     tx->tx_nwrq = 0;
       ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:37,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_get_idle_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:126:13: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(!tx->tx_nwrq);
                ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:126:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nwrq);
     ^~~~~~~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:134:13: error: 'struct kib_tx' has no member named 'tx_nfrags'
     LASSERT(!tx->tx_nfrags);
                ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:134:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nfrags);
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_post_rx':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:168:4: error: 'struct kib_rx' has no member named 'rx_sge'; did you mean 'rx_msg'?
     rx->rx_sge.lkey   = conn->ibc_hdev->ibh_pd->local_dma_lkey;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:169:4: error: 'struct kib_rx' has no member named 'rx_sge'; did you mean 'rx_msg'?
     rx->rx_sge.addr   = rx->rx_msgaddr;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:170:4: error: 'struct kib_rx' has no member named 'rx_sge'; did you mean 'rx_msg'?
     rx->rx_sge.length = IBLND_MSG_SIZE;
       ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:172:4: error: 'struct kib_rx' has no member named 'rx_wrq'; did you mean 'rx_nob'?
     rx->rx_wrq.next    = NULL;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:173:4: error: 'struct kib_rx' has no member named 'rx_wrq'; did you mean 'rx_nob'?
     rx->rx_wrq.sg_list = &rx->rx_sge;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:173:26: error: 'struct kib_rx' has no member named 'rx_sge'; did you mean 'rx_msg'?
     rx->rx_wrq.sg_list = &rx->rx_sge;
                             ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:174:4: error: 'struct kib_rx' has no member named 'rx_wrq'; did you mean 'rx_nob'?
     rx->rx_wrq.num_sge = 1;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:175:4: error: 'struct kib_rx' has no member named 'rx_wrq'; did you mean 'rx_nob'?
     rx->rx_wrq.wr_id   = kiblnd_ptr2wreqid(rx, IBLND_WID_RX);
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:191:43: error: 'struct kib_rx' has no member named 'rx_wrq'; did you mean 'rx_nob'?
     rc = ib_post_recv(conn->ibc_cmid->qp, &rx->rx_wrq, &bad_wrq);
                                              ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_handle_rx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:420:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq = 0;  /* overwrite PUT_REQ */
        ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_fmr_map_tx':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:575:51: error: 'struct kib_tx' has no member named 'fmr'
     rc = kiblnd_fmr_pool_map(fps, tx, rd, nob, 0, &tx->fmr);
                                                      ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:585:17: error: 'struct kib_tx' has no member named 'fmr'
     rd->rd_key = tx->fmr.fmr_key;
                    ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_unmap_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:600:28: error: 'struct kib_tx' has no member named 'fmr'
      kiblnd_fmr_pool_unmap(&tx->fmr, tx->tx_status);
                               ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:602:8: error: 'struct kib_tx' has no member named 'tx_nfrags'
     if (tx->tx_nfrags) {
           ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:11: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
              ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:25: error: 'struct kib_tx' has no member named 'tx_nfrags'
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
                            ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:40: error: 'struct kib_tx' has no member named 'tx_dmadir'; did you mean 'tx_deadline'?
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
                                           ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:605:5: error: 'struct kib_tx' has no member named 'tx_nfrags'
      tx->tx_nfrags = 0;
        ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_map_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:621:4: error: 'struct kib_tx' has no member named 'tx_dmadir'; did you mean 'tx_deadline'?
     tx->tx_dmadir = (rd != tx->tx_rd) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
       ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:621:27: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
     tx->tx_dmadir = (rd != tx->tx_rd) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
                              ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:622:4: error: 'struct kib_tx' has no member named 'tx_nfrags'
     tx->tx_nfrags = nfrags;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:624:55: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
     rd->rd_nfrags = kiblnd_dma_map_sg(hdev->ibh_ibdev, tx->tx_frags,
                                                          ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:625:10: error: 'struct kib_tx' has no member named 'tx_nfrags'
           tx->tx_nfrags, tx->tx_dmadir);
             ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:625:25: error: 'struct kib_tx' has no member named 'tx_dmadir'; did you mean 'tx_deadline'?
           tx->tx_nfrags, tx->tx_dmadir);
                            ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:629:24: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
       hdev->ibh_ibdev, &tx->tx_frags[i]);
                           ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:631:24: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
       hdev->ibh_ibdev, &tx->tx_frags[i]);
                           ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_setup_rd_iov':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:664:9: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
     sg = tx->tx_frags;
            ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:696:42: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
     return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
                                             ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_setup_rd_kiov':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:721:9: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
     sg = tx->tx_frags;
            ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:741:42: error: 'struct kib_tx' has no member named 'tx_frags'; did you mean 'tx_status'?
     return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
                                             ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:37,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_post_tx_locked':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:757:12: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(tx->tx_nwrq > 0);
               ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:757:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq > 0);
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:836:43: error: 'struct kib_tx' has no member named 'fmr'
      struct kib_fast_reg_descriptor *frd = tx->fmr.fmr_frd;
                                              ^~
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:837:31: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
      struct ib_send_wr *bad = &tx->tx_wrq[tx->tx_nwrq - 1].wr;
                                  ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:837:42: error: 'struct kib_tx' has no member named 'tx_nwrq'
      struct ib_send_wr *bad = &tx->tx_wrq[tx->tx_nwrq - 1].wr;
                                             ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:838:31: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
      struct ib_send_wr *wrq = &tx->tx_wrq[0].wr;
                                  ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:847:37: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
       frd->frd_fastreg_wr.wr.next = &tx->tx_wrq[0].wr;
                                        ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_init_tx_msg':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1020:26: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
     struct ib_sge *sge = &tx->tx_sge[tx->tx_nwrq];
                             ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1020:37: error: 'struct kib_tx' has no member named 'tx_nwrq'
     struct ib_sge *sge = &tx->tx_sge[tx->tx_nwrq];
                                        ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1021:30: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
     struct ib_rdma_wr *wrq = &tx->tx_wrq[tx->tx_nwrq];
                                 ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1021:41: error: 'struct kib_tx' has no member named 'tx_nwrq'
     struct ib_rdma_wr *wrq = &tx->tx_wrq[tx->tx_nwrq];
                                            ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:37,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1024:12: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(tx->tx_nwrq >= 0);
               ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1024:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq >= 0);
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1025:12: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(tx->tx_nwrq < IBLND_MAX_RDMA_FRAGS + 1);
               ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1025:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq < IBLND_MAX_RDMA_FRAGS + 1);
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1043:4: error: 'struct kib_tx' has no member named 'tx_nwrq'
     tx->tx_nwrq++;
       ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_init_rdma':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1051:34: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
     struct kib_rdma_desc *srcrd = tx->tx_rd;
                                     ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1052:26: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
     struct ib_sge *sge = &tx->tx_sge[0];
                             ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:37,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1060:13: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(!tx->tx_nwrq);
                ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1060:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nwrq);
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1086:9: error: 'struct kib_tx' has no member named 'tx_nwrq'
      if (tx->tx_nwrq >= IBLND_MAX_RDMA_FRAGS) {
            ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1100:12: error: 'struct kib_tx' has no member named 'tx_sge'; did you mean 'tx_msg'?
      sge = &tx->tx_sge[tx->tx_nwrq];
               ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1100:23: error: 'struct kib_tx' has no member named 'tx_nwrq'
      sge = &tx->tx_sge[tx->tx_nwrq];
                          ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1105:12: error: 'struct kib_tx' has no member named 'tx_wrq'; did you mean 'tx_msg'?
      wrq = &tx->tx_wrq[tx->tx_nwrq];
               ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1105:23: error: 'struct kib_tx' has no member named 'tx_nwrq'
      wrq = &tx->tx_wrq[tx->tx_nwrq];
                          ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1123:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq++;
        ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1129:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq = 0;
        ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:37,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_queue_tx_locked':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1144:12: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(tx->tx_nwrq > 0);       /* work items set up */
               ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1144:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq > 0);       /* work items set up */
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_launch_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1373:19: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(!tx || tx->tx_nwrq > 0);     /* work items have been set up */
                      ^
   include/linux/compiler.h:179:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^~~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1373:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx || tx->tx_nwrq > 0);     /* work items have been set up */
     ^~~~~~~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_send':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1603:39: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
       rc = kiblnd_setup_rd_iov(ni, tx, tx->tx_rd,
                                          ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1607:40: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
       rc = kiblnd_setup_rd_kiov(ni, tx, tx->tx_rd,
                                           ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_reply':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1675:38: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
      rc = kiblnd_setup_rd_iov(ni, tx, tx->tx_rd,
                                         ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1678:39: error: 'struct kib_tx' has no member named 'tx_rd'; did you mean 'tx_msg'?
      rc = kiblnd_setup_rd_kiov(ni, tx, tx->tx_rd,
                                          ^~
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_setup_rd_iov':
..

vim +/DECLARE_PCI_UNMAP_ADDR +473 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h

d7e09d039 Peng Tao         2013-05-02  457  #define IBLND_REJECT_CONN_UNCOMPAT  4 /* incompatible version peer */
d7e09d039 Peng Tao         2013-05-02  458  #define IBLND_REJECT_CONN_STALE     5 /* stale peer */
2fb44f2b0 Jeremy Filizetti 2016-03-02  459  /* peer's rdma frags doesn't match mine */
2fb44f2b0 Jeremy Filizetti 2016-03-02  460  #define IBLND_REJECT_RDMA_FRAGS	    6
2fb44f2b0 Jeremy Filizetti 2016-03-02  461  /* peer's msg queue size doesn't match mine */
2fb44f2b0 Jeremy Filizetti 2016-03-02  462  #define IBLND_REJECT_MSG_QUEUE_SIZE 7
d7e09d039 Peng Tao         2013-05-02  463  
d7e09d039 Peng Tao         2013-05-02  464  /***********************************************************************/
d7e09d039 Peng Tao         2013-05-02  465  
8d9de3f48 James Simmons    2016-06-10  466  struct kib_rx {					/* receive message */
d7e09d039 Peng Tao         2013-05-02  467  	struct list_head       rx_list;       /* queue for attention */
d7e09d039 Peng Tao         2013-05-02  468  	struct kib_conn        *rx_conn;      /* owning conn */
d0bed0352 Jeff Becker      2015-08-24  469  	int                    rx_nob; /* # bytes received (-1 while posted) */
d7e09d039 Peng Tao         2013-05-02  470  	enum ib_wc_status      rx_status;     /* completion status */
8d9de3f48 James Simmons    2016-06-10  471  	struct kib_msg		*rx_msg;	/* message buffer (host vaddr) */
d7e09d039 Peng Tao         2013-05-02  472  	__u64                  rx_msgaddr;    /* message buffer (I/O addr) */
d7e09d039 Peng Tao         2013-05-02 @473  	DECLARE_PCI_UNMAP_ADDR(rx_msgunmap);  /* for dma_unmap_single() */
d7e09d039 Peng Tao         2013-05-02  474  	struct ib_recv_wr      rx_wrq;        /* receive work item... */
d7e09d039 Peng Tao         2013-05-02  475  	struct ib_sge          rx_sge;        /* ...and its memory */
8d9de3f48 James Simmons    2016-06-10  476  };
d7e09d039 Peng Tao         2013-05-02  477  
d7e09d039 Peng Tao         2013-05-02  478  #define IBLND_POSTRX_DONT_POST    0 /* don't post */
d7e09d039 Peng Tao         2013-05-02  479  #define IBLND_POSTRX_NO_CREDIT    1 /* post: no credits */
d7e09d039 Peng Tao         2013-05-02  480  #define IBLND_POSTRX_PEER_CREDIT  2 /* post: give peer back 1 credit */
d0bed0352 Jeff Becker      2015-08-24  481  #define IBLND_POSTRX_RSRVD_CREDIT 3 /* post: give self back 1 reserved credit */

:::::: The code at line 473 was first introduced by commit
:::::: d7e09d0397e84eefbabfd9cb353221f3c6448d83 staging: add Lustre file system client support

:::::: TO: Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
:::::: CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--MGYHOYXEY6WxJCY8
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
vf0/XGZqj//QAgA=

--MGYHOYXEY6WxJCY8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
