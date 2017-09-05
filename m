From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH resend] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Tue, 5 Sep 2017 11:38:45 +0800
Message-ID: <201709051113.QveSrpHM%fengguang.wu@intel.com>
References: <20170904092611.19892-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170904092611.19892-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yuval,

[auto build test ERROR on rdma/master]
[also build test ERROR on v4.13 next-20170904]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Yuval-Shaia/IB-Move-PCI-dependency-from-root-KConfig-to-HW-s-KConfigs/20170905-024550
base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
config: openrisc-allmodconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 5.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All errors (new ones prefixed by >>):

   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:0:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:473:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(rx_msgunmap);  /* for dma_unmap_single() */
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:496:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(tx_msgunmap);  /* for dma_unmap_single() */
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_map_tx_pages':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1540:19: error: 'struct kib_tx' has no member named 'tx_pages'
     __u64 *pages = tx->tx_pages;
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_fmr_pool_map':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1619:19: error: 'struct kib_tx' has no member named 'tx_pages'
     __u64 *pages = tx->tx_pages;
                      ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1620:24: error: 'struct kib_tx' has no member named 'tx_rd'
     bool is_rx = (rd != tx->tx_rd);
                           ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1685:28: error: 'struct kib_tx' has no member named 'tx_frags'
        n = ib_map_mr_sg(mr, tx->tx_frags,
                               ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1686:10: error: 'struct kib_tx' has no member named 'tx_nfrags'
           tx->tx_nfrags, NULL, PAGE_SIZE);
             ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1687:25: error: 'struct kib_tx' has no member named 'tx_nfrags'
        if (unlikely(n != tx->tx_nfrags)) {
                            ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
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
                                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1688:6: note: in expansion of macro 'CERROR'
         CERROR("Failed to map mr %d/%d elements\n",
         ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_destroy_tx_pool':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1987:9: error: 'struct kib_tx' has no member named 'tx_pages'
      if (tx->tx_pages)
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:18: error: 'struct kib_tx' has no member named 'tx_pages'
       LIBCFS_FREE(tx->tx_pages,
                     ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_pages,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1990:19: error: 'struct kib_tx' has no member named 'tx_pages'
            sizeof(*tx->tx_pages));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_pages,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1988:18: error: 'struct kib_tx' has no member named 'tx_pages'
       LIBCFS_FREE(tx->tx_pages,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1991:9: error: 'struct kib_tx' has no member named 'tx_frags'
      if (tx->tx_frags)
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:18: error: 'struct kib_tx' has no member named 'tx_frags'
       LIBCFS_FREE(tx->tx_frags,
                     ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_frags,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1994:20: error: 'struct kib_tx' has no member named 'tx_frags'
             sizeof(*tx->tx_frags));
                       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_frags,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1992:18: error: 'struct kib_tx' has no member named 'tx_frags'
       LIBCFS_FREE(tx->tx_frags,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1995:9: error: 'struct kib_tx' has no member named 'tx_wrq'
      if (tx->tx_wrq)
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:18: error: 'struct kib_tx' has no member named 'tx_wrq'
       LIBCFS_FREE(tx->tx_wrq,
                     ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_wrq,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1998:19: error: 'struct kib_tx' has no member named 'tx_wrq'
            sizeof(*tx->tx_wrq));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_wrq,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1996:18: error: 'struct kib_tx' has no member named 'tx_wrq'
       LIBCFS_FREE(tx->tx_wrq,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:1999:9: error: 'struct kib_tx' has no member named 'tx_sge'
      if (tx->tx_sge)
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:18: error: 'struct kib_tx' has no member named 'tx_sge'
       LIBCFS_FREE(tx->tx_sge,
                     ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_sge,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:77:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2002:19: error: 'struct kib_tx' has no member named 'tx_sge'
            sizeof(*tx->tx_sge));
                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:222:41: note: in definition of macro '__CDEBUG'
      libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__); \
                                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_debug.h:236:29: note: in expansion of macro 'CDEBUG_LIMIT'
    #define CERROR(format, ...) CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                                ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:148:3: note: in expansion of macro 'CERROR'
      CERROR("LIBCFS: free NULL '" #ptr "' (%d bytes) at "    \
      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_sge,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2000:18: error: 'struct kib_tx' has no member named 'tx_sge'
       LIBCFS_FREE(tx->tx_sge,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2003:9: error: 'struct kib_tx' has no member named 'tx_rd'
      if (tx->tx_rd)
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:18: error: 'struct kib_tx' has no member named 'tx_rd'
       LIBCFS_FREE(tx->tx_rd,
                     ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:4: note: in expansion of macro 'LIBCFS_FREE'
       LIBCFS_FREE(tx->tx_rd,
       ^
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs.h:79:0,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:66,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:39:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2004:18: error: 'struct kib_tx' has no member named 'tx_rd'
       LIBCFS_FREE(tx->tx_rd,
                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:152:9: note: in definition of macro 'LIBCFS_FREE'
     kvfree(ptr);       \
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/asm-generic/div64.h:23,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:37:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_create_tx_pool':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2066:32: error: 'struct kib_tx' has no member named 'tx_pages'
          LNET_MAX_IOV * sizeof(*tx->tx_pages));
                                   ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:91:2: note: in expansion of macro 'LASSERT'
     LASSERT(!in_interrupt() || ((size) <= LIBCFS_VMALLOC_SIZE && \
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:134:2: note: in expansion of macro 'LIBCFS_ALLOC_PRE'
     LIBCFS_ALLOC_PRE((size), (mask));        \
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:143:2: note: in expansion of macro 'LIBCFS_CPT_ALLOC_GFP'
--
   In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:37:0:
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:473:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(rx_msgunmap);  /* for dma_unmap_single() */
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:496:2: error: expected specifier-qualifier-list before 'DECLARE_PCI_UNMAP_ADDR'
     DECLARE_PCI_UNMAP_ADDR(tx_msgunmap);  /* for dma_unmap_single() */
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_tx_done':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:82:4: error: 'struct kib_tx' has no member named 'tx_nwrq'
     tx->tx_nwrq = 0;
       ^
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
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:126:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nwrq);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:134:13: error: 'struct kib_tx' has no member named 'tx_nfrags'
     LASSERT(!tx->tx_nfrags);
                ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:134:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nfrags);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_post_rx':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:168:4: error: 'struct kib_rx' has no member named 'rx_sge'
     rx->rx_sge.lkey   = conn->ibc_hdev->ibh_pd->local_dma_lkey;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:169:4: error: 'struct kib_rx' has no member named 'rx_sge'
     rx->rx_sge.addr   = rx->rx_msgaddr;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:170:4: error: 'struct kib_rx' has no member named 'rx_sge'
     rx->rx_sge.length = IBLND_MSG_SIZE;
       ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:172:4: error: 'struct kib_rx' has no member named 'rx_wrq'
     rx->rx_wrq.next    = NULL;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:173:4: error: 'struct kib_rx' has no member named 'rx_wrq'
     rx->rx_wrq.sg_list = &rx->rx_sge;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:173:26: error: 'struct kib_rx' has no member named 'rx_sge'
     rx->rx_wrq.sg_list = &rx->rx_sge;
                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:174:4: error: 'struct kib_rx' has no member named 'rx_wrq'
     rx->rx_wrq.num_sge = 1;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:175:4: error: 'struct kib_rx' has no member named 'rx_wrq'
     rx->rx_wrq.wr_id   = kiblnd_ptr2wreqid(rx, IBLND_WID_RX);
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:191:43: error: 'struct kib_rx' has no member named 'rx_wrq'
     rc = ib_post_recv(conn->ibc_cmid->qp, &rx->rx_wrq, &bad_wrq);
                                              ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_handle_rx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:420:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq = 0;  /* overwrite PUT_REQ */
        ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_fmr_map_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:575:51: error: 'struct kib_tx' has no member named 'fmr'
     rc = kiblnd_fmr_pool_map(fps, tx, rd, nob, 0, &tx->fmr);
                                                      ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:585:17: error: 'struct kib_tx' has no member named 'fmr'
     rd->rd_key = tx->fmr.fmr_key;
                    ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_unmap_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:600:28: error: 'struct kib_tx' has no member named 'fmr'
      kiblnd_fmr_pool_unmap(&tx->fmr, tx->tx_status);
                               ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:602:8: error: 'struct kib_tx' has no member named 'tx_nfrags'
     if (tx->tx_nfrags) {
           ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:11: error: 'struct kib_tx' has no member named 'tx_frags'
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
              ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:25: error: 'struct kib_tx' has no member named 'tx_nfrags'
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
                            ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:604:40: error: 'struct kib_tx' has no member named 'tx_dmadir'
            tx->tx_frags, tx->tx_nfrags, tx->tx_dmadir);
                                           ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:605:5: error: 'struct kib_tx' has no member named 'tx_nfrags'
      tx->tx_nfrags = 0;
        ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_map_tx':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:621:4: error: 'struct kib_tx' has no member named 'tx_dmadir'
     tx->tx_dmadir = (rd != tx->tx_rd) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
       ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:621:27: error: 'struct kib_tx' has no member named 'tx_rd'
     tx->tx_dmadir = (rd != tx->tx_rd) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
                              ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:622:4: error: 'struct kib_tx' has no member named 'tx_nfrags'
     tx->tx_nfrags = nfrags;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:624:55: error: 'struct kib_tx' has no member named 'tx_frags'
     rd->rd_nfrags = kiblnd_dma_map_sg(hdev->ibh_ibdev, tx->tx_frags,
                                                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:625:10: error: 'struct kib_tx' has no member named 'tx_nfrags'
           tx->tx_nfrags, tx->tx_dmadir);
             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:625:25: error: 'struct kib_tx' has no member named 'tx_dmadir'
           tx->tx_nfrags, tx->tx_dmadir);
                            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:629:24: error: 'struct kib_tx' has no member named 'tx_frags'
       hdev->ibh_ibdev, &tx->tx_frags[i]);
                           ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:631:24: error: 'struct kib_tx' has no member named 'tx_frags'
       hdev->ibh_ibdev, &tx->tx_frags[i]);
                           ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_setup_rd_iov':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:664:9: error: 'struct kib_tx' has no member named 'tx_frags'
     sg = tx->tx_frags;
            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:696:42: error: 'struct kib_tx' has no member named 'tx_frags'
     return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_setup_rd_kiov':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:721:9: error: 'struct kib_tx' has no member named 'tx_frags'
     sg = tx->tx_frags;
            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:741:42: error: 'struct kib_tx' has no member named 'tx_frags'
     return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
                                             ^
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
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:757:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq > 0);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:836:43: error: 'struct kib_tx' has no member named 'fmr'
      struct kib_fast_reg_descriptor *frd = tx->fmr.fmr_frd;
                                              ^
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:837:31: error: 'struct kib_tx' has no member named 'tx_wrq'
      struct ib_send_wr *bad = &tx->tx_wrq[tx->tx_nwrq - 1].wr;
                                  ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:837:42: error: 'struct kib_tx' has no member named 'tx_nwrq'
      struct ib_send_wr *bad = &tx->tx_wrq[tx->tx_nwrq - 1].wr;
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:838:31: error: 'struct kib_tx' has no member named 'tx_wrq'
      struct ib_send_wr *wrq = &tx->tx_wrq[0].wr;
                                  ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:847:37: error: 'struct kib_tx' has no member named 'tx_wrq'
       frd->frd_fastreg_wr.wr.next = &tx->tx_wrq[0].wr;
                                        ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_init_tx_msg':
>> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1020:26: error: 'struct kib_tx' has no member named 'tx_sge'
     struct ib_sge *sge = &tx->tx_sge[tx->tx_nwrq];
                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1020:37: error: 'struct kib_tx' has no member named 'tx_nwrq'
     struct ib_sge *sge = &tx->tx_sge[tx->tx_nwrq];
                                        ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1021:30: error: 'struct kib_tx' has no member named 'tx_wrq'
     struct ib_rdma_wr *wrq = &tx->tx_wrq[tx->tx_nwrq];
                                 ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1021:41: error: 'struct kib_tx' has no member named 'tx_nwrq'
     struct ib_rdma_wr *wrq = &tx->tx_wrq[tx->tx_nwrq];
                                            ^
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
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1024:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq >= 0);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1025:12: error: 'struct kib_tx' has no member named 'tx_nwrq'
     LASSERT(tx->tx_nwrq < IBLND_MAX_RDMA_FRAGS + 1);
               ^
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1025:2: note: in expansion of macro 'LASSERT'
     LASSERT(tx->tx_nwrq < IBLND_MAX_RDMA_FRAGS + 1);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1043:4: error: 'struct kib_tx' has no member named 'tx_nwrq'
     tx->tx_nwrq++;
       ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function 'kiblnd_init_rdma':
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1051:34: error: 'struct kib_tx' has no member named 'tx_rd'
     struct kib_rdma_desc *srcrd = tx->tx_rd;
                                     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1052:26: error: 'struct kib_tx' has no member named 'tx_sge'
     struct ib_sge *sge = &tx->tx_sge[0];
                             ^
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
   include/linux/compiler.h:175:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/../../../include/linux/libcfs/libcfs_private.h:63:23: note: in expansion of macro 'LASSERTF'
    #define LASSERT(cond) LASSERTF(cond, "\n")
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1060:2: note: in expansion of macro 'LASSERT'
     LASSERT(!tx->tx_nwrq);
     ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1086:9: error: 'struct kib_tx' has no member named 'tx_nwrq'
      if (tx->tx_nwrq >= IBLND_MAX_RDMA_FRAGS) {
            ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1100:12: error: 'struct kib_tx' has no member named 'tx_sge'
      sge = &tx->tx_sge[tx->tx_nwrq];
               ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1100:23: error: 'struct kib_tx' has no member named 'tx_nwrq'
      sge = &tx->tx_sge[tx->tx_nwrq];
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1105:12: error: 'struct kib_tx' has no member named 'tx_wrq'
      wrq = &tx->tx_wrq[tx->tx_nwrq];
               ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1105:23: error: 'struct kib_tx' has no member named 'tx_nwrq'
      wrq = &tx->tx_wrq[tx->tx_nwrq];
                          ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1123:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq++;
        ^
   drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1129:5: error: 'struct kib_tx' has no member named 'tx_nwrq'
      tx->tx_nwrq = 0;
        ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,

vim +1540 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c

d7e09d039 Peng Tao           2013-05-02  1536  
80e05b34f Dmitry Eremin      2016-05-05  1537  static int
8d9de3f48 James Simmons      2016-06-10  1538  kiblnd_map_tx_pages(struct kib_tx *tx, struct kib_rdma_desc *rd)
80e05b34f Dmitry Eremin      2016-05-05  1539  {
80e05b34f Dmitry Eremin      2016-05-05 @1540  	__u64 *pages = tx->tx_pages;
8d9de3f48 James Simmons      2016-06-10  1541  	struct kib_hca_dev *hdev;
80e05b34f Dmitry Eremin      2016-05-05  1542  	int npages;
80e05b34f Dmitry Eremin      2016-05-05  1543  	int size;
80e05b34f Dmitry Eremin      2016-05-05  1544  	int i;
80e05b34f Dmitry Eremin      2016-05-05  1545  
80e05b34f Dmitry Eremin      2016-05-05  1546  	hdev = tx->tx_pool->tpo_hdev;
80e05b34f Dmitry Eremin      2016-05-05  1547  
80e05b34f Dmitry Eremin      2016-05-05  1548  	for (i = 0, npages = 0; i < rd->rd_nfrags; i++) {
80e05b34f Dmitry Eremin      2016-05-05  1549  		for (size = 0; size <  rd->rd_frags[i].rf_nob;
80e05b34f Dmitry Eremin      2016-05-05  1550  		     size += hdev->ibh_page_size) {
80e05b34f Dmitry Eremin      2016-05-05  1551  			pages[npages++] = (rd->rd_frags[i].rf_addr &
80e05b34f Dmitry Eremin      2016-05-05  1552  					   hdev->ibh_page_mask) + size;
80e05b34f Dmitry Eremin      2016-05-05  1553  		}
80e05b34f Dmitry Eremin      2016-05-05  1554  	}
80e05b34f Dmitry Eremin      2016-05-05  1555  
80e05b34f Dmitry Eremin      2016-05-05  1556  	return npages;
80e05b34f Dmitry Eremin      2016-05-05  1557  }
80e05b34f Dmitry Eremin      2016-05-05  1558  
8d9de3f48 James Simmons      2016-06-10  1559  void kiblnd_fmr_pool_unmap(struct kib_fmr *fmr, int status)
d7e09d039 Peng Tao           2013-05-02  1560  {
d7e09d039 Peng Tao           2013-05-02  1561  	LIST_HEAD(zombies);
8d9de3f48 James Simmons      2016-06-10  1562  	struct kib_fmr_pool *fpo = fmr->fmr_pool;
8d9de3f48 James Simmons      2016-06-10  1563  	struct kib_fmr_poolset *fps;
a649ad1d7 Greg Kroah-Hartman 2014-07-12  1564  	unsigned long now = cfs_time_current();
8d9de3f48 James Simmons      2016-06-10  1565  	struct kib_fmr_pool *tmp;
d7e09d039 Peng Tao           2013-05-02  1566  	int rc;
d7e09d039 Peng Tao           2013-05-02  1567  
1f199a0c4 Dmitry Eremin      2016-05-05  1568  	if (!fpo)
1f199a0c4 Dmitry Eremin      2016-05-05  1569  		return;
1f199a0c4 Dmitry Eremin      2016-05-05  1570  
1f199a0c4 Dmitry Eremin      2016-05-05  1571  	fps = fpo->fpo_owner;
80e05b34f Dmitry Eremin      2016-05-05  1572  	if (fpo->fpo_is_fmr) {
1f199a0c4 Dmitry Eremin      2016-05-05  1573  		if (fmr->fmr_pfmr) {
d7e09d039 Peng Tao           2013-05-02  1574  			rc = ib_fmr_pool_unmap(fmr->fmr_pfmr);
5fd88337d James Simmons      2016-02-12  1575  			LASSERT(!rc);
1f199a0c4 Dmitry Eremin      2016-05-05  1576  			fmr->fmr_pfmr = NULL;
1f199a0c4 Dmitry Eremin      2016-05-05  1577  		}
d7e09d039 Peng Tao           2013-05-02  1578  
5fd88337d James Simmons      2016-02-12  1579  		if (status) {
87f4f6f53 Dmitry Eremin      2016-05-05  1580  			rc = ib_flush_fmr_pool(fpo->fmr.fpo_fmr_pool);
5fd88337d James Simmons      2016-02-12  1581  			LASSERT(!rc);
d7e09d039 Peng Tao           2013-05-02  1582  		}
80e05b34f Dmitry Eremin      2016-05-05  1583  	} else {
80e05b34f Dmitry Eremin      2016-05-05  1584  		struct kib_fast_reg_descriptor *frd = fmr->fmr_frd;
d7e09d039 Peng Tao           2013-05-02  1585  
80e05b34f Dmitry Eremin      2016-05-05  1586  		if (frd) {
80e05b34f Dmitry Eremin      2016-05-05  1587  			frd->frd_valid = false;
80e05b34f Dmitry Eremin      2016-05-05  1588  			spin_lock(&fps->fps_lock);
80e05b34f Dmitry Eremin      2016-05-05  1589  			list_add_tail(&frd->frd_list, &fpo->fast_reg.fpo_pool_list);
80e05b34f Dmitry Eremin      2016-05-05  1590  			spin_unlock(&fps->fps_lock);
80e05b34f Dmitry Eremin      2016-05-05  1591  			fmr->fmr_frd = NULL;
80e05b34f Dmitry Eremin      2016-05-05  1592  		}
80e05b34f Dmitry Eremin      2016-05-05  1593  	}
d7e09d039 Peng Tao           2013-05-02  1594  	fmr->fmr_pool = NULL;
d7e09d039 Peng Tao           2013-05-02  1595  
d7e09d039 Peng Tao           2013-05-02  1596  	spin_lock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1597  	fpo->fpo_map_count--;  /* decref the pool */
d7e09d039 Peng Tao           2013-05-02  1598  
d7e09d039 Peng Tao           2013-05-02  1599  	list_for_each_entry_safe(fpo, tmp, &fps->fps_pool_list, fpo_list) {
d7e09d039 Peng Tao           2013-05-02  1600  		/* the first pool is persistent */
d7e09d039 Peng Tao           2013-05-02  1601  		if (fps->fps_pool_list.next == &fpo->fpo_list)
d7e09d039 Peng Tao           2013-05-02  1602  			continue;
d7e09d039 Peng Tao           2013-05-02  1603  
d7e09d039 Peng Tao           2013-05-02  1604  		if (kiblnd_fmr_pool_is_idle(fpo, now)) {
d7e09d039 Peng Tao           2013-05-02  1605  			list_move(&fpo->fpo_list, &zombies);
d7e09d039 Peng Tao           2013-05-02  1606  			fps->fps_version++;
d7e09d039 Peng Tao           2013-05-02  1607  		}
d7e09d039 Peng Tao           2013-05-02  1608  	}
d7e09d039 Peng Tao           2013-05-02  1609  	spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1610  
d7e09d039 Peng Tao           2013-05-02  1611  	if (!list_empty(&zombies))
d7e09d039 Peng Tao           2013-05-02  1612  		kiblnd_destroy_fmr_pool_list(&zombies);
d7e09d039 Peng Tao           2013-05-02  1613  }
d7e09d039 Peng Tao           2013-05-02  1614  
8d9de3f48 James Simmons      2016-06-10  1615  int kiblnd_fmr_pool_map(struct kib_fmr_poolset *fps, struct kib_tx *tx,
8d9de3f48 James Simmons      2016-06-10  1616  			struct kib_rdma_desc *rd, __u32 nob, __u64 iov,
8d9de3f48 James Simmons      2016-06-10  1617  			struct kib_fmr *fmr)
d7e09d039 Peng Tao           2013-05-02  1618  {
80e05b34f Dmitry Eremin      2016-05-05 @1619  	__u64 *pages = tx->tx_pages;
80e05b34f Dmitry Eremin      2016-05-05 @1620  	bool is_rx = (rd != tx->tx_rd);
0efe6171d Nicholas Hanley    2016-11-07  1621  	bool tx_pages_mapped = false;
8d9de3f48 James Simmons      2016-06-10  1622  	struct kib_fmr_pool *fpo;
80e05b34f Dmitry Eremin      2016-05-05  1623  	int npages = 0;
d7e09d039 Peng Tao           2013-05-02  1624  	__u64 version;
d7e09d039 Peng Tao           2013-05-02  1625  	int rc;
d7e09d039 Peng Tao           2013-05-02  1626  
d7e09d039 Peng Tao           2013-05-02  1627   again:
d7e09d039 Peng Tao           2013-05-02  1628  	spin_lock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1629  	version = fps->fps_version;
d7e09d039 Peng Tao           2013-05-02  1630  	list_for_each_entry(fpo, &fps->fps_pool_list, fpo_list) {
d7e09d039 Peng Tao           2013-05-02  1631  		fpo->fpo_deadline = cfs_time_shift(IBLND_POOL_DEADLINE);
d7e09d039 Peng Tao           2013-05-02  1632  		fpo->fpo_map_count++;
80e05b34f Dmitry Eremin      2016-05-05  1633  
80e05b34f Dmitry Eremin      2016-05-05  1634  		if (fpo->fpo_is_fmr) {
80e05b34f Dmitry Eremin      2016-05-05  1635  			struct ib_pool_fmr *pfmr;
80e05b34f Dmitry Eremin      2016-05-05  1636  
d7e09d039 Peng Tao           2013-05-02  1637  			spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1638  
80e05b34f Dmitry Eremin      2016-05-05  1639  			if (!tx_pages_mapped) {
80e05b34f Dmitry Eremin      2016-05-05  1640  				npages = kiblnd_map_tx_pages(tx, rd);
80e05b34f Dmitry Eremin      2016-05-05  1641  				tx_pages_mapped = 1;
80e05b34f Dmitry Eremin      2016-05-05  1642  			}
80e05b34f Dmitry Eremin      2016-05-05  1643  
87f4f6f53 Dmitry Eremin      2016-05-05  1644  			pfmr = ib_fmr_pool_map_phys(fpo->fmr.fpo_fmr_pool,
d7e09d039 Peng Tao           2013-05-02  1645  						    pages, npages, iov);
d7e09d039 Peng Tao           2013-05-02  1646  			if (likely(!IS_ERR(pfmr))) {
c1b2e0b51 Dmitry Eremin      2016-05-05  1647  				fmr->fmr_key = is_rx ? pfmr->fmr->rkey :
c1b2e0b51 Dmitry Eremin      2016-05-05  1648  						       pfmr->fmr->lkey;
80e05b34f Dmitry Eremin      2016-05-05  1649  				fmr->fmr_frd = NULL;
d7e09d039 Peng Tao           2013-05-02  1650  				fmr->fmr_pfmr = pfmr;
c1b2e0b51 Dmitry Eremin      2016-05-05  1651  				fmr->fmr_pool = fpo;
d7e09d039 Peng Tao           2013-05-02  1652  				return 0;
d7e09d039 Peng Tao           2013-05-02  1653  			}
c1b2e0b51 Dmitry Eremin      2016-05-05  1654  			rc = PTR_ERR(pfmr);
80e05b34f Dmitry Eremin      2016-05-05  1655  		} else {
80e05b34f Dmitry Eremin      2016-05-05  1656  			if (!list_empty(&fpo->fast_reg.fpo_pool_list)) {
80e05b34f Dmitry Eremin      2016-05-05  1657  				struct kib_fast_reg_descriptor *frd;
80e05b34f Dmitry Eremin      2016-05-05  1658  				struct ib_reg_wr *wr;
80e05b34f Dmitry Eremin      2016-05-05  1659  				struct ib_mr *mr;
80e05b34f Dmitry Eremin      2016-05-05  1660  				int n;
80e05b34f Dmitry Eremin      2016-05-05  1661  
80e05b34f Dmitry Eremin      2016-05-05  1662  				frd = list_first_entry(&fpo->fast_reg.fpo_pool_list,
80e05b34f Dmitry Eremin      2016-05-05  1663  						       struct kib_fast_reg_descriptor,
80e05b34f Dmitry Eremin      2016-05-05  1664  						       frd_list);
80e05b34f Dmitry Eremin      2016-05-05  1665  				list_del(&frd->frd_list);
80e05b34f Dmitry Eremin      2016-05-05  1666  				spin_unlock(&fps->fps_lock);
80e05b34f Dmitry Eremin      2016-05-05  1667  
80e05b34f Dmitry Eremin      2016-05-05  1668  				mr = frd->frd_mr;
80e05b34f Dmitry Eremin      2016-05-05  1669  
80e05b34f Dmitry Eremin      2016-05-05  1670  				if (!frd->frd_valid) {
80e05b34f Dmitry Eremin      2016-05-05  1671  					__u32 key = is_rx ? mr->rkey : mr->lkey;
80e05b34f Dmitry Eremin      2016-05-05  1672  					struct ib_send_wr *inv_wr;
80e05b34f Dmitry Eremin      2016-05-05  1673  
80e05b34f Dmitry Eremin      2016-05-05  1674  					inv_wr = &frd->frd_inv_wr;
80e05b34f Dmitry Eremin      2016-05-05  1675  					memset(inv_wr, 0, sizeof(*inv_wr));
80e05b34f Dmitry Eremin      2016-05-05  1676  					inv_wr->opcode = IB_WR_LOCAL_INV;
80e05b34f Dmitry Eremin      2016-05-05  1677  					inv_wr->wr_id = IBLND_WID_MR;
80e05b34f Dmitry Eremin      2016-05-05  1678  					inv_wr->ex.invalidate_rkey = key;
80e05b34f Dmitry Eremin      2016-05-05  1679  
80e05b34f Dmitry Eremin      2016-05-05  1680  					/* Bump the key */
80e05b34f Dmitry Eremin      2016-05-05  1681  					key = ib_inc_rkey(key);
80e05b34f Dmitry Eremin      2016-05-05  1682  					ib_update_fast_reg_key(mr, key);
80e05b34f Dmitry Eremin      2016-05-05  1683  				}
80e05b34f Dmitry Eremin      2016-05-05  1684  
80e05b34f Dmitry Eremin      2016-05-05 @1685  				n = ib_map_mr_sg(mr, tx->tx_frags,
2f37dd131 Linus Torvalds     2016-05-20  1686  						 tx->tx_nfrags, NULL, PAGE_SIZE);
80e05b34f Dmitry Eremin      2016-05-05  1687  				if (unlikely(n != tx->tx_nfrags)) {
80e05b34f Dmitry Eremin      2016-05-05  1688  					CERROR("Failed to map mr %d/%d elements\n",
80e05b34f Dmitry Eremin      2016-05-05  1689  					       n, tx->tx_nfrags);
80e05b34f Dmitry Eremin      2016-05-05  1690  					return n < 0 ? n : -EINVAL;
80e05b34f Dmitry Eremin      2016-05-05  1691  				}
80e05b34f Dmitry Eremin      2016-05-05  1692  
80e05b34f Dmitry Eremin      2016-05-05  1693  				mr->iova = iov;
80e05b34f Dmitry Eremin      2016-05-05  1694  
80e05b34f Dmitry Eremin      2016-05-05  1695  				/* Prepare FastReg WR */
80e05b34f Dmitry Eremin      2016-05-05  1696  				wr = &frd->frd_fastreg_wr;
80e05b34f Dmitry Eremin      2016-05-05  1697  				memset(wr, 0, sizeof(*wr));
80e05b34f Dmitry Eremin      2016-05-05  1698  				wr->wr.opcode = IB_WR_REG_MR;
80e05b34f Dmitry Eremin      2016-05-05  1699  				wr->wr.wr_id = IBLND_WID_MR;
80e05b34f Dmitry Eremin      2016-05-05  1700  				wr->wr.num_sge = 0;
80e05b34f Dmitry Eremin      2016-05-05  1701  				wr->wr.send_flags = 0;
80e05b34f Dmitry Eremin      2016-05-05  1702  				wr->mr = mr;
80e05b34f Dmitry Eremin      2016-05-05  1703  				wr->key = is_rx ? mr->rkey : mr->lkey;
80e05b34f Dmitry Eremin      2016-05-05  1704  				wr->access = (IB_ACCESS_LOCAL_WRITE |
80e05b34f Dmitry Eremin      2016-05-05  1705  					      IB_ACCESS_REMOTE_WRITE);
80e05b34f Dmitry Eremin      2016-05-05  1706  
80e05b34f Dmitry Eremin      2016-05-05  1707  				fmr->fmr_key = is_rx ? mr->rkey : mr->lkey;
80e05b34f Dmitry Eremin      2016-05-05  1708  				fmr->fmr_frd = frd;
80e05b34f Dmitry Eremin      2016-05-05  1709  				fmr->fmr_pfmr = NULL;
80e05b34f Dmitry Eremin      2016-05-05  1710  				fmr->fmr_pool = fpo;
80e05b34f Dmitry Eremin      2016-05-05  1711  				return 0;
80e05b34f Dmitry Eremin      2016-05-05  1712  			}
80e05b34f Dmitry Eremin      2016-05-05  1713  			spin_unlock(&fps->fps_lock);
80e05b34f Dmitry Eremin      2016-05-05  1714  			rc = -EBUSY;
80e05b34f Dmitry Eremin      2016-05-05  1715  		}
d7e09d039 Peng Tao           2013-05-02  1716  
d7e09d039 Peng Tao           2013-05-02  1717  		spin_lock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1718  		fpo->fpo_map_count--;
c1b2e0b51 Dmitry Eremin      2016-05-05  1719  		if (rc != -EAGAIN) {
d7e09d039 Peng Tao           2013-05-02  1720  			spin_unlock(&fps->fps_lock);
c1b2e0b51 Dmitry Eremin      2016-05-05  1721  			return rc;
d7e09d039 Peng Tao           2013-05-02  1722  		}
d7e09d039 Peng Tao           2013-05-02  1723  
d7e09d039 Peng Tao           2013-05-02  1724  		/* EAGAIN and ... */
d7e09d039 Peng Tao           2013-05-02  1725  		if (version != fps->fps_version) {
d7e09d039 Peng Tao           2013-05-02  1726  			spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1727  			goto again;
d7e09d039 Peng Tao           2013-05-02  1728  		}
d7e09d039 Peng Tao           2013-05-02  1729  	}
d7e09d039 Peng Tao           2013-05-02  1730  
d7e09d039 Peng Tao           2013-05-02  1731  	if (fps->fps_increasing) {
d7e09d039 Peng Tao           2013-05-02  1732  		spin_unlock(&fps->fps_lock);
c314c319c James Simmons      2016-02-12  1733  		CDEBUG(D_NET, "Another thread is allocating new FMR pool, waiting for her to complete\n");
d7e09d039 Peng Tao           2013-05-02  1734  		schedule();
d7e09d039 Peng Tao           2013-05-02  1735  		goto again;
d7e09d039 Peng Tao           2013-05-02  1736  	}
d7e09d039 Peng Tao           2013-05-02  1737  
699503bca Greg Kroah-Hartman 2014-07-12  1738  	if (time_before(cfs_time_current(), fps->fps_next_retry)) {
d7e09d039 Peng Tao           2013-05-02  1739  		/* someone failed recently */
d7e09d039 Peng Tao           2013-05-02  1740  		spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1741  		return -EAGAIN;
d7e09d039 Peng Tao           2013-05-02  1742  	}
d7e09d039 Peng Tao           2013-05-02  1743  
d7e09d039 Peng Tao           2013-05-02  1744  	fps->fps_increasing = 1;
d7e09d039 Peng Tao           2013-05-02  1745  	spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1746  
d7e09d039 Peng Tao           2013-05-02  1747  	CDEBUG(D_NET, "Allocate new FMR pool\n");
d7e09d039 Peng Tao           2013-05-02  1748  	rc = kiblnd_create_fmr_pool(fps, &fpo);
d7e09d039 Peng Tao           2013-05-02  1749  	spin_lock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1750  	fps->fps_increasing = 0;
5fd88337d James Simmons      2016-02-12  1751  	if (!rc) {
d7e09d039 Peng Tao           2013-05-02  1752  		fps->fps_version++;
d7e09d039 Peng Tao           2013-05-02  1753  		list_add_tail(&fpo->fpo_list, &fps->fps_pool_list);
d7e09d039 Peng Tao           2013-05-02  1754  	} else {
d7e09d039 Peng Tao           2013-05-02  1755  		fps->fps_next_retry = cfs_time_shift(IBLND_POOL_RETRY);
d7e09d039 Peng Tao           2013-05-02  1756  	}
d7e09d039 Peng Tao           2013-05-02  1757  	spin_unlock(&fps->fps_lock);
d7e09d039 Peng Tao           2013-05-02  1758  
d7e09d039 Peng Tao           2013-05-02  1759  	goto again;
d7e09d039 Peng Tao           2013-05-02  1760  }
d7e09d039 Peng Tao           2013-05-02  1761  

:::::: The code at line 1540 was first introduced by commit
:::::: 80e05b34f882dd03e3b7eaa1923e49deae6e409e staging: lustre: o2iblnd: Add Fast Reg memory registration support

:::::: TO: Dmitry Eremin <dmitry.eremin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
:::::: CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--envbJBWh7q8WU6mo
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
cvCQAgA=

--envbJBWh7q8WU6mo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
