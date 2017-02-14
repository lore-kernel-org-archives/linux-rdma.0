From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 11:24:59 -0700
Message-ID: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm trying to get SRP working on my ConnectX-4-LX cards to see if it
has the same problem as iSER does. When I try to connect the initiator
to the target I get that opensm is not running. I tried all the umad
devices without any luck. I found that someone had to modify the
source to get it to work with RDMACM [0] and then another thread that
specified that an option had to be passed to the ib_srpt module, but I
don't see that option in modinfo and the Readme mentioned in the
thread is not there[1]. If SRP should work, can someone help me figure
out what I'm doing wrong here.

Thank you,
Robert LeBlanc

# targetcli ls
o- / .........................................................................................................................
[...]
 o- backstores ..............................................................................................................
[...]
 | o- block ..................................................................................................
[Storage Objects: 0]
 | o- fileio .................................................................................................
[Storage Objects: 0]
 | o- pscsi ..................................................................................................
[Storage Objects: 0]
 | o- ramdisk ................................................................................................
[Storage Objects: 1]
 |   o- test1 ..............................................................................................
[(100.0GiB) activated]
 o- iscsi ............................................................................................................
[Targets: 1]
 | o- iqn.2016-12.com.betterservers
.....................................................................................
[TPGs: 1]
 |   o- tpg1 ..................................................................................................
[gen-acls, no-auth]
 |     o- acls ..........................................................................................................
[ACLs: 0]
 |     o- luns ..........................................................................................................
[LUNs: 1]
 |     | o- lun0
..................................................................................................
[ramdisk/test1]
 |     o- portals
....................................................................................................
[Portals: 1]
 |       o- 0.0.0.0:3260
...................................................................................................
[iser]
 o- loopback .........................................................................................................
[Targets: 0]
 o- srpt .............................................................................................................
[Targets: 1]
   o- ib.fe800000000000000ec47afffe89f719
...........................................................................
[no-gen-acls]
     o- acls ............................................................................................................
[ACLs: 1]
     | o- ib.fe800000000000000ec47afffe880731
....................................................................
[Mapped LUNs: 1]
     |   o- mapped_lun0
.................................................................................
[lun0 ramdisk/test1 (rw)]
     o- luns ............................................................................................................
[LUNs: 1]
       o- lun0 ....................................................................................................
[ramdisk/test1]

# ibsrpdm -c
SM LID is 0, maybe no opensm is running
Querying SRP targets failed

# modinfo ib_srpt
filename:
/lib/modules/4.10.0-rc4+/kernel/drivers/infiniband/ulp/srpt/ib_srpt.ko
license:        Dual BSD/GPL
description:    InfiniBand SCSI RDMA Protocol target v2.0.0 (2011-02-14)
author:         Vu Pham and Bart Van Assche
depends:        ib_core,ib_cm
intree:         Y
vermagic:       4.10.0-rc4+ SMP mod_unload
parm:           srp_max_req_size:Maximum size of SRP request messages
in bytes. (int)
parm:           srpt_srq_size:Shared receive queue (SRQ) size. (int)
parm:           srpt_service_guid:Using this value for ioc_guid,
id_ext, and cm_listen_id instead of using the node_guid of the first
HCA.

[0] http://www.spinics.net/lists/linux-rdma/msg09083.html
[1] https://sourceforge.net/p/scst/mailman/message/34316586/
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
