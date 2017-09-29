From: Marty Schlining <mschlining-LfVdkaOWEx8@public.gmane.org>
Subject: Kernel 4.13.3 and 4.13.4 Infiniband SRP Issue
Date: Fri, 29 Sep 2017 19:26:57 +0000
Message-ID: <902F8B1CC123894F81C798F1BE4018A2017CE9E6DB@LAX-EX-MB1.datadirect.datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

I've run into an issue with kernel 4.13.4 when using SRP. I am unable to generate a SCSI read or write command larger than 4MB to a LUN using sgp_dd to the SCSI Generic device (sg). Any idea what's going on here? Is there a new setting I need to be concerned with? max_hw_sectors_kb is set high enough to generate 8M and 16M commands.

Thanks,
Marty Schlining

[root@node162 ~]# uname -r
4.13.3

[root@node162 ~]# opensm &
[1] 1787
[root@node162 ~]# -------------------------------------------------
OpenSM 3.3.19
Reading Cached Option File: /etc/rdma/opensm.conf
Command Line Arguments:
Log File: /var/log/opensm.log
-------------------------------------------------
OpenSM 3.3.19

Using default GUID 0xf4521403008c3711
Entering DISCOVERING state

Entering MASTER state

[root@node162 ~]# cat /root/srp_daemon_queue_size_default.conf
a max_sect=65535

[root@node162 ~]# modprobe -r ib_srpt
[root@node162 ~]# modprobe -r ib_srp
[root@node162 ~]# modprobe ib_srp cmd_sg_entries=255 allow_ext_sg=1 indirect_sg_entries=2048

[root@node162 ~]# srp_daemon -o -e -n -f /root/srp_daemon_queue_size_default.conf
[root@node162 ~]# lsscsi
[0:2:0:0]    disk    DELL     PERC H310        2.12  /dev/sda
[6:0:0:0]    cd/dvd  PLDS     DVD+-RW DU-8A5LH BD51  /dev/sr0
[11:0:0:0]   disk    DDN      SFA14K           110c  /dev/sdb
[12:0:0:0]   storage DDN      SFA14K           110c  -
[12:0:0:3]   disk    DDN      SFA14K           110c  /dev/sdc
[13:0:0:0]   storage DDN      SFA14K           110c  -
[13:0:0:2]   disk    DDN      SFA14K           110c  /dev/sdd
[14:0:0:0]   storage DDN      SFA14K           110c  -
[14:0:0:1]   disk    DDN      SFA14K           110c  /dev/sde
[14:0:0:4]   disk    DDN      SFA14K           110c  /dev/sdf
[root@node162 ~]# lsscsi -g
[0:2:0:0]    disk    DELL     PERC H310        2.12  /dev/sda   /dev/sg0
[6:0:0:0]    cd/dvd  PLDS     DVD+-RW DU-8A5LH BD51  /dev/sr0   /dev/sg1
[11:0:0:0]   disk    DDN      SFA14K           110c  /dev/sdb   /dev/sg2
[12:0:0:0]   storage DDN      SFA14K           110c  -          /dev/sg3
[12:0:0:3]   disk    DDN      SFA14K           110c  /dev/sdc   /dev/sg4
[13:0:0:0]   storage DDN      SFA14K           110c  -          /dev/sg5
[13:0:0:2]   disk    DDN      SFA14K           110c  /dev/sdd   /dev/sg6
[14:0:0:0]   storage DDN      SFA14K           110c  -          /dev/sg7
[14:0:0:1]   disk    DDN      SFA14K           110c  /dev/sde   /dev/sg8
[14:0:0:4]   disk    DDN      SFA14K           110c  /dev/sdf   /dev/sg9
[root@node162 ~]# lsscsi -Hl
[0]    megaraid_sas
  cmd_per_lun=256  host_busy=0    sg_tablesize=60   unchecked_isa_dma=0
[1]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[2]    qla2xxx
  cmd_per_lun=3    host_busy=0    sg_tablesize=1024 unchecked_isa_dma=0
[3]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[4]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[5]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[6]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[7]    ahci
  cmd_per_lun=0    host_busy=0    sg_tablesize=168  unchecked_isa_dma=0
[8]    qla2xxx
  cmd_per_lun=3    host_busy=0    sg_tablesize=1024 unchecked_isa_dma=0
[9]    qla2xxx
  cmd_per_lun=3    host_busy=0    sg_tablesize=1024 unchecked_isa_dma=0
[10]    qla2xxx
  cmd_per_lun=3    host_busy=0    sg_tablesize=1024 unchecked_isa_dma=0
[11]    ib_srp
  cmd_per_lun=62   host_busy=0    sg_tablesize=2048 unchecked_isa_dma=0
[12]    ib_srp
  cmd_per_lun=62   host_busy=0    sg_tablesize=2048 unchecked_isa_dma=0
[13]    ib_srp
  cmd_per_lun=62   host_busy=0    sg_tablesize=2048 unchecked_isa_dma=0
[14]    ib_srp
  cmd_per_lun=62   host_busy=0    sg_tablesize=2048 unchecked_isa_dma=0
[root@node162 ~]#

[root@node162 ~]# tail /sys/block/sdb/queue/*
==> /sys/block/sdb/queue/add_random <==
1

==> /sys/block/sdb/queue/chunk_sectors <==
0

==> /sys/block/sdb/queue/dax <==
0

==> /sys/block/sdb/queue/discard_granularity <==
0

==> /sys/block/sdb/queue/discard_max_bytes <==
0

==> /sys/block/sdb/queue/discard_max_hw_bytes <==
0

==> /sys/block/sdb/queue/discard_zeroes_data <==
0

==> /sys/block/sdb/queue/hw_sector_size <==
4096

==> /sys/block/sdb/queue/io_poll <==
0

==> /sys/block/sdb/queue/io_poll_delay <==
0

==> /sys/block/sdb/queue/iosched <==
tail: error reading '/sys/block/sdb/queue/iosched': Is a directory

==> /sys/block/sdb/queue/iostats <==
1

==> /sys/block/sdb/queue/logical_block_size <==
4096

==> /sys/block/sdb/queue/max_discard_segments <==
1

==> /sys/block/sdb/queue/max_hw_sectors_kb <==
32767

==> /sys/block/sdb/queue/max_integrity_segments <==
0

==> /sys/block/sdb/queue/max_sectors_kb <==
2048

==> /sys/block/sdb/queue/max_segments <==
2048

==> /sys/block/sdb/queue/max_segment_size <==
1073741824

==> /sys/block/sdb/queue/minimum_io_size <==
2097152

==> /sys/block/sdb/queue/nomerges <==
0

==> /sys/block/sdb/queue/nr_requests <==
128

==> /sys/block/sdb/queue/optimal_io_size <==
2097152

==> /sys/block/sdb/queue/physical_block_size <==
4096

==> /sys/block/sdb/queue/read_ahead_kb <==
128

==> /sys/block/sdb/queue/rotational <==
1

==> /sys/block/sdb/queue/rq_affinity <==
1

==> /sys/block/sdb/queue/scheduler <==
noop [deadline] cfq

==> /sys/block/sdb/queue/wbt_lat_usec <==
tail: error reading '/sys/block/sdb/queue/wbt_lat_usec': Invalid argument

==> /sys/block/sdb/queue/write_cache <==
write back

==> /sys/block/sdb/queue/write_same_max_bytes <==
268431360

==> /sys/block/sdb/queue/write_zeroes_max_bytes <==
268431360

==> /sys/block/sdb/queue/zoned <==
none

4M Read
[root@node162 ~]# /root/sg3_utils-1.42/src/sgp_dd if=/dev/sg2 of=/dev/null bs=4096 bpt=1024 time=1 count=1000000
time to transfer data was 2.249565 secs, 1820.80 MB/sec
1000000+0 records in
1000000+0 records out

8M Read
[root@node162 ~]# /root/sg3_utils-1.42/src/sgp_dd if=/dev/sg2 of=/dev/null bs=4096 bpt=2048 time=1 count=1000000
starting io on sg device, error: Invalid argument
sgp_dd: inputting to sg failed, blk=0
time to transfer data was 0.002484 secs
>>>> Some error occurred, remaining blocks=1000000
  remaining block count=1000000
0+0 records in
0+0 records out

4M+4k Read
[root@node162 ~]# /root/sg3_utils-1.42/src/sgp_dd if=/dev/sg2 of=/dev/null bs=4096 bpt=1025 time=1 count=1000000
starting io on sg device, error: Invalid argument
sgp_dd: inputting to sg failed, blk=0
time to transfer data was 0.002076 secs
>>>> Some error occurred, remaining blocks=1000000
  remaining block count=1000000
0+0 records in
0+0 records out
[root@node162 ~]#

SCSI writes to the sg device also have exactly the same issue.

8M write
[root@node162 ~]# /root/sg3_utils-1.42/src/sgp_dd verbose=9 if=/dev/zero of=/dev/sg2 bs=4096 bpt=2048 time=1 count=1000000
sgp_dd: if=/dev/zero skip=0 of=/dev/sg2 seek=0 count=1000000
Start of loop, count=1000000, in_num_sect=0, out_num_sect=0
Starting worker thread k=0
sg_start_io: SCSI WRITE, blk=0 num_blks=2048
Write(10) [2a 00 00 00 00 00 00 08 00 00 ]
starting io on sg device, error: Invalid argument
sgp_dd: outputting from sg failed, blk=0
Starting worker thread k=1
Starting worker thread k=2
Starting worker thread k=3
Worker thread k=0 terminated
Worker thread k=1 terminated
Worker thread k=2 terminated
Worker thread k=3 terminated
time to transfer data was 0.004417 secs
>>>> Some error occurred, remaining blocks=997952
  remaining block count=1000000
2048+0 records in
0+0 records out

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
