From: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Subject: registering lots of memory from user space
Date: Thu, 17 Nov 2011 10:05:25 -0600
Message-ID: <OF1DFE280B.A14EBEF1-ON8825794B.00562030-8625794B.0058636B@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm hitting an ENOMEM from ibv_reg_mr() when trying to register in excess 
of ~ 26 Gb on a host with 96 Gb of RAM.  I've also noticed that once I 
register memory it seems to get demoted from hugepages.

Hardware is ConnectX-2:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.7.710
        node_guid:                      f04d:a290:9779:10d8
        sys_image_guid:                 f04d:a290:9779:10db
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xB0
        board_id:                       DEL08F0120009
        phys_port_cnt:                  2

Software stack is from RHEL 6:

Name        : libibverbs                   Relocations: (not relocatable)
Version     : 1.1.4                             Vendor: Red Hat, Inc.
Release     : 2.el6                         Build Date: Tue 03 Aug 2010 
10:00:52 PM PDT
Install Date: Thu 07 Apr 2011 06:30:05 PM PDT      Build Host: 
x86-012.build.bos.redhat.com
Group       : System Environment/Libraries   Source RPM: 
libibverbs-1.1.4-2.el6.src.rpm
Size        : 100643                           License: GPLv2 or BSD
Signature   : RSA/8, Mon 16 Aug 2010 10:58:04 AM PDT, Key ID 
199e2f91fd431d51
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
URL         : http://openfabrics.org/
Summary     : A library for direct userspace use of RDMA 
(InfiniBand/iWARP) hardware

Name        : libmlx4                      Relocations: (not relocatable)
Version     : 1.0.1                             Vendor: Red Hat, Inc.
Release     : 7.el6                         Build Date: Wed 11 Aug 2010 
07:11:27 AM PDT
Install Date: Thu 07 Apr 2011 06:30:05 PM PDT      Build Host: 
x86-003.build.bos.redhat.com
Group       : System Environment/Libraries   Source RPM: 
libmlx4-1.0.1-7.el6.src.rpm
Size        : 49259                            License: GPLv2 or BSD
Signature   : RSA/8, Mon 16 Aug 2010 11:00:57 AM PDT, Key ID 
199e2f91fd431d51
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
URL         : http://openfabrics.org/
Summary     : Mellanox ConnectX InfiniBand HCA Userspace Driver

Prior to starting my memory registration I see:

cat /proc/meminfo
MemTotal:       99056596 kB
MemFree:        31254656 kB
Buffers:          166204 kB
Cached:          1908904 kB
SwapCached:            0 kB
Active:           945464 kB
Inactive:        1193504 kB
Active(anon):      82432 kB
Inactive(anon):      256 kB
Active(file):     863032 kB
Inactive(file):  1193248 kB
Unevictable:        6460 kB
Mlocked:            6460 kB
SwapTotal:      102399992 kB
SwapFree:       102399992 kB
Dirty:              6968 kB
Writeback:             0 kB
AnonPages:         85104 kB
Mapped:            35392 kB
Shmem:               412 kB
Slab:            2089728 kB
SReclaimable:     136928 kB
SUnreclaim:      1952800 kB
KernelStack:        4840 kB
PageTables:        11800 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    120471008 kB
Committed_AS:     737836 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      526096 kB
VmallocChunk:   34308048264 kB
HardwareCorrupted:     0 kB
AnonHugePages:     14336 kB
HugePages_Total:   30720
HugePages_Free:    27027
HugePages_Rsvd:     9235
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7588 kB
DirectMap2M:    100642816 kB

After most of my registration has succeeded:

cat /proc/meminfo
MemTotal:       99056596 kB
MemFree:        31100164 kB
Buffers:          166204 kB
Cached:          1938844 kB
SwapCached:            0 kB
Active:           945436 kB
Inactive:        1193508 kB
Active(anon):      82404 kB
Inactive(anon):      256 kB
Active(file):     863032 kB
Inactive(file):  1193252 kB
Unevictable:        6460 kB
Mlocked:            6460 kB
SwapTotal:      102399992 kB
SwapFree:       102399992 kB
Dirty:                20 kB
Writeback:             0 kB
AnonPages:         85088 kB
Mapped:            37128 kB
Shmem:               412 kB
Slab:            2212852 kB
SReclaimable:     136900 kB
SUnreclaim:      2075952 kB
KernelStack:        4840 kB
PageTables:        11784 kB
NFS_Unstable:         44 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    120471008 kB
Committed_AS:     738144 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      526096 kB
VmallocChunk:   34308048264 kB
HardwareCorrupted:     0 kB
AnonHugePages:     14336 kB
HugePages_Total:   30720
HugePages_Free:    19543
HugePages_Rsvd:     1751
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7588 kB
DirectMap2M:    100642816 kB

My application look appears as follows:

Registered 983040000 bytes at address 0x7fca362d8000
Registered 983040000 bytes at address 0x7fca70c58000
Registered 983040000 bytes at address 0x7fcaab5d8000
Registered 983040000 bytes at address 0x7fcae5f58000
Registered 983040000 bytes at address 0x7fcb208d8000
Registered 983040000 bytes at address 0x7fcb5b258000
Registered 983040000 bytes at address 0x7fcb95bd8000
Registered 983040000 bytes at address 0x7fcbd0558000
Registered 983040000 bytes at address 0x7fcc0aed8000
Registered 983040000 bytes at address 0x7fcc45858000
Registered 983040000 bytes at address 0x7fcc801d8000
Registered 983040000 bytes at address 0x7fccbab58000
Registered 983040000 bytes at address 0x7fccf54d8000
Registered 983040000 bytes at address 0x7fcd2fe58000
Registered 983040000 bytes at address 0x7fcd6a7d8000
Registered 983040000 bytes at address 0x7fcda5158000
Registered 1054272 bytes at address 0x7fce1adf59c0
Registered 1054272 bytes at address 0x7fce1adf59c0
Registered 1054720 bytes at address 0x7fce1aef7800
Registered 1054720 bytes at address 0x7fce1aff9000
Registered 1054720 bytes at address 0x7fce1b0fa800
Registered 1054720 bytes at address 0x7fce1b1fc000
Registered 1054720 bytes at address 0x7fce1b2fd800
Registered 2147483648 bytes at address 0x7fc7d0000000
Registered 2147483648 bytes at address 0x7fc750000000
Registered 2147483648 bytes at address 0x7fc6d0000000
Registered 2147483648 bytes at address 0x7fc650000000
Registered 2147483648 bytes at address 0x7fc5d0000000
Registered 2147483648 bytes at address 0x7fc550000000
Failed to register 2147483648 bytes at address 0x7fc4d00000, errno: 12

Any suggestions on how to get past this limit?

Thanks,
Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
