From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Bug: Discover more than 1 iSER gives -- isert: isert_handle_wc: wr...
 status {9,1} vend_err {8a,d7) -- & -- conn error (1011)
Date: Tue, 28 Jul 2015 02:25:22 +0000
Message-ID: <CA+X5Wn7GmZ9fYbm14YAr59rnCwD-eDoz+xVxsu3F0YK1o4dsew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Two up to date arch systems.  Kernel 4.1.2 (Arch -2).

2 Mellanox MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE]
(rev a0) running mlx4_core driver v2.2-1 (Feb, 2014.)  Both on most
recent firmware for PSID MT_04A0110002, FW Version 2.9.1000.  Systems
directly connected, no switches.  InfiniBand otherwise works great,
through VERY extensive testing.

Running OpenFabrics most recent releases of everything (release
versions, not git versions.)

Open-iscsi 2.0_873-6.

targetcli-fb 2.1.fb41-1, python-rtslib-fb 2.1.fb57-1, and
python-configshell-fb 1.1.fb18-1.



I can't discover more than 1 iSER device working at a time.  Using
IPoIB lets me discover as many as I want.

At the very end is a workaround - not a fix.


I start with 3 disks working through iSCSI over IPoIB, with
targetcli's (-fb version) ls looking like:

o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- block .............................................. [Storage Objects: 3]
  | | o- sda4 ........................ [/dev/sda4 (4.4TiB) write-thru activated]
  | | o- sdb4 ........................ [/dev/sdb4 (4.4TiB) write-thru activated]
  | | o- sdc4 ........................ [/dev/sdc4 (4.4TiB) write-thru activated]
  | o- fileio ............................................. [Storage Objects: 0]
  | o- pscsi .............................................. [Storage Objects: 0]
  | o- ramdisk ............................................ [Storage Objects: 0]
  | o- user ............................................... [Storage Objects: 0]
  o- iscsi ........................................................ [Targets: 3]
  | o- iqn.2003-01.org.linux-iscsi.terra.x8664:sn.2549ae938766 ....... [TPGs: 1]
  | | o- tpg1 ........................................... [no-gen-acls, no-auth]
  | |   o- acls ...................................................... [ACLs: 1]
  | |   | o- iqn.2005-03.org.open-iscsi:c04e8f17af18 .......... [Mapped LUNs: 1]
  | |   |   o- mapped_lun0 .............................. [lun0 block/sda4 (rw)]
  | |   o- luns ...................................................... [LUNs: 1]
  | |   | o- lun0 ..................................... [block/sda4 (/dev/sda4)]
  | |   o- portals ................................................ [Portals: 1]
  | |     o- 0.0.0.0:3260 ................................................. [OK]
  | o- iqn.2003-01.org.linux-iscsi.terra.x8664:sn.8518b92b052d ....... [TPGs: 1]
  | | o- tpg1 ........................................... [no-gen-acls, no-auth]
  | |   o- acls ...................................................... [ACLs: 1]
  | |   | o- iqn.2005-03.org.open-iscsi:c04e8f17af18 .......... [Mapped LUNs: 1]
  | |   |   o- mapped_lun0 .............................. [lun0 block/sdb4 (rw)]
  | |   o- luns ...................................................... [LUNs: 1]
  | |   | o- lun0 ..................................... [block/sdb4 (/dev/sdb4)]
  | |   o- portals ................................................ [Portals: 1]
  | |     o- 0.0.0.0:3260 ................................................. [OK]
  | o- iqn.2003-01.org.linux-iscsi.terra.x8664:sn.d4603198ba50 ....... [TPGs: 1]
  |   o- tpg1 ........................................... [no-gen-acls, no-auth]
  |     o- acls ...................................................... [ACLs: 1]
  |     | o- iqn.2005-03.org.open-iscsi:c04e8f17af18 .......... [Mapped LUNs: 1]
  |     |   o- mapped_lun0 .............................. [lun0 block/sdc4 (rw)]
  |     o- luns ...................................................... [LUNs: 1]
  |     | o- lun0 ..................................... [block/sdc4 (/dev/sdc4)]
  |     o- portals ................................................ [Portals: 1]
  |       o- 0.0.0.0:3260 ................................................. [OK]
  o- loopback ..................................................... [Targets: 0]
  o- sbp .......................................................... [Targets: 0]
  o- srpt ......................................................... [Targets: 0]
  o- vhost ........................................................ [Targets: 0]


On the initiator system, I clear everything.  Log out via iscsiadm -m
node -U all.  Disconnect via iscsiadm -m discovery -t sendtargets -p
IP -o delete.

On the target system, i go into each of the
iscsi/iqn/tpg1/portals/0.0.0.0:3260 directories and run "enable_iser
true".  Each time it says "iSER enable now: True".  / saveconfig and
exit.

target-cli now changes to:
  | |     o- 0.0.0.0:3260 ............................................... [iser]
...
  | |     o- 0.0.0.0:3260 ............................................... [iser]
...
  |       o- 0.0.0.0:3260 ............................................... [iser]

On the initiator system, I discover via iscsiadm -m discovery -t
sendtargets -p IP -I iser, and it says:

iscsiadm: recv's end state machine bug?
iscsiadm: Could not perform SendTargets discovery: iSCSI PDU timed out

The target's dmesg added:

[80296.332049] isert: isert_handle_wc: wr id ffff8800a78f1c18 status 9
vend_err 8a

The initiator's dmesg added:

[10868.076407] scsi host25: iSCSI Initiator over iSER
[10868.078969] iser: iser_handle_wc: wr id ffff8807f7ee4000 status 1 vend_err d7
[10868.078982]  connection7:0: detected conn error (1011)


Now, on the target machine, if I run "enable_iser false" on two of the
iqn's portals, saveconfig, and exit... Then run iscsiadm -m discovery
-t sendtargets -p IP -I iser, it gives:

192.168.2.1:3260,1 iqn.2003-01.org.linux-iscsi.terra.x8664:sn.2549ae938766

Target's dmesg has nothing new, initiator's has:

[11067.116617] scsi host27: iSCSI Initiator over iSER

On the initiator, I can log into the node, mount it, and use it just
fine.  I can even discover and log into the other two nodes, using
iSCSI over IPoIB rather than iSER for those 2, and use all 3.

But, I can't get more than 1 iSER to discover at a time.

... Not sure if this is a kernel issue, a Mellanox issue, an
OpenFabrics issue, an open-iscsi issue, or a targetcli (-fb version)
issue.



I found the only difference in open-iscsi's node configuration files
is iface.iscsi_ifacename = iser, and iface.transport_name = iser.
(Rather than default and tcp.)  And, the files are called iser rather
than default.

If I discover the targets with the targets having enable_iser false,
then stop the initiator's open-iscsi.service, update all the node
config files to iser, rename them to iser, change all the targets to
enable_iser true, and start the initiator's open-iscsi.service, it
works.  (I can log in at that point, mount them, whatever.)

So, the issue is in discovery, not logging in or using.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
