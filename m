From: "Billich Heiner" <Heiner.Billich-QlBsmsa8rgI@public.gmane.org>
Subject: srp target - write to raw block device like /dev/sda ist fragmented into very small requests
Date: Wed, 25 Aug 2010 11:59:54 +0200
Message-ID: <AD99CE4B84C4D3468F69B0E4FB345D5805FDEB5D@MAILBOX0A.psi.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 
Hello,

we employ Infiniband SRP storage. For basic tests I just did write/read
with dd to the raw block device like /dev/sda. I tell dd to use 1M sized
blocks, but I see very small few KB sized requests only. To make this
tests of real value I would need to read and write with large 1MB sized
requests. More important I'm not sure whether this points to some
misconfiguration.

Example: 
Read 1M sized blocks from /dev/sdh - iostat shows 8*512byte average
request size, which is very small, I would expect 1M sized requests:
 
# dd if=/dev/sdh of=/dev/null bs=1M &

# iostat -xk /dev/sdh 2

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdh               0.00     0.00 8253.23  0.00 33012.94     0.00     8.00
0.90    0.11   0.11  89.95

Performance counters on the srp target show the same small request size.

Is this expected behaviour if I write or read from/to a srp block device
file? Does anything limit the request size if I access the storage via
the block device file like /dev/sdh? 

Using a mounted filesystem on top of the block devices I get perfectly
1M sized i/o requests, hence I think that the storage (DDN S2A9900) an
the settings for the block device are o.k..

We currently run Scientific Linux 5.4 with a rebuild vendor kernel
2.6.18-194.8.1.el5 and the included ofed 1.3. I know that this is no
plain vanilla kernel.org kernel and no very recent OFED version.

Kind regards,

Heiner Billich



Some more details



# ibstat
CA 'mlx4_0'
        CA type: MT26428
        Number of ports: 2
        Firmware version: 2.7.100
        Hardware version: b0
        Node GUID: 0x0002c90300088dc6
        System image GUID: 0x0002c90300088dc9
        Port 1:
                State: Active
                Physical state: LinkUp
                Rate: 40
                Base lid: 14
                LMC: 0
                SM lid: 1
                Capability mask: 0x02510868
                Port GUID: 0x0002c90300088dc7

ib_srp parameters:

mellanox_workarounds 1
srp_dev_loss_tmo 60
srp_sg_tablesize 255
topspin_workarounds 1

modinfo ib_srp
filename:
/lib/modules/2.6.18-194.8.1.el5/kernel/drivers/infiniband/ulp/srp/ib_srp
.ko
license:        Dual BSD/GPL
description:    InfiniBand SCSI RDMA Protocol initiator v0.2 (November
1, 2005)
author:         Roland Dreier
srcversion:     DCFC6574D959F8EC7B4AE72
depends:        ib_core,scsi_mod,ib_cm,ib_sa
vermagic:       2.6.18-194.8.1.el5 SMP mod_unload gcc-4.1
parm:           srp_sg_tablesize:Max number of gather/scatter entries
per I/O (default is 12, max 255) (int)
parm:           topspin_workarounds:Enable workarounds for Topspin/Cisco
SRP target bugs if != 0 (int)
parm:           mellanox_workarounds:Enable workarounds for Mellanox SRP
target bugs if != 0 (int)
parm:           srp_dev_loss_tmo:Default number of seconds that srp
transport should              insulate the lost of a remote port
(default is 60 secs (int)
module_sig:
883f3504c2cf87cab955e73ffd495d2112149509f45aa2bcee8c81463e247bd36d55c5dd
bc2634d509e2b3eb9c09799f2ea4e951c973d0fe3725ddbc
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
