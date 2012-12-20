From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/3] IB/SRP patches for kernel 3.8
Date: Thu, 20 Dec 2012 14:38:54 +0200
Message-ID: <50D306DE.7080505@mellanox.com>
References: <50D1CD49.5080607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D1CD49.5080607-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/12/2012 16:20, Bart Van Assche wrote:
> This patch series avoids that SCSI error handling triggers an endless 
> loop and also restores reporting of QP errors in the kernel log.
>
> Changes between v3 and v2:
> - As proposed by Dave, added a patch that prevents sending of a task
>   management function over a closed connection.
>
> Changes between v2 and v1:
> - Track connection state properly.
> - Make srp_reset_host() reset requests even if reconnecting fails
>

Bart,

I tried the patches now, took these three commits from 
git://github.com/bvanassche/linux.git
branch 3.8-ib-srp-fixes which I assume are the ones you posted here and 
applied them on Roland's for-next branch

commit 62862c0f93d47853b8d321fe5dcdd5d789e92d08
IB/srp: Avoid endless SCSI error handling loop

commit d73006faf751df4fc2fff7514f6fc6a74c41fd35
IB/srp: Avoid sending a task management function needlessly

commit befde6a2ceca6b894fb183ff96d175d6c380546b
IB/srp: Track connection state properly


Basically, I connected to an SRP target, later took down the initiator 
IB port, and then attempted to issue some IO over the SRP lun (no 
multipathing). What happens is that things are seemed to be detected 
properly, reconnection goes in a loop, but the SCSI host  (host6) isn't 
deleted, I can't unload the module since there's non-zero ref count. 
Only when I bring back
the port, I see

scsi host6: ib_srp: reconnect succeeded
sd 6:0:0:1: [sdc] Synchronizing SCSI cache
... etc on all the luns of that host

and only then the SCSI host is finally removed, the module ref count 
goes to zero and I canunload the module. Maybe another patch is needed 
here? I think few days ago you had a patch on your tree named "Save and 
restore host_scribble during error handling", is it possible we need 
this here for happy removal of the scsi host?

Or.

Dec 20 14:06:13 vsa33 kernel: scsi6 : SRP.T10:0002C9030010B014
Dec 20 14:06:13 vsa33 kernel: scsi 6:0:0:0: Direct-Access     SUN      COMSTAR          1.0  PQ: 0 ANSI: 5
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:0: Attached scsi generic sg1 type 0
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:0: [sdb] 409600 512-byte logical blocks: (209 MB/200 MiB)
Dec 20 14:06:13 vsa33 kernel: scsi 6:0:0:1: Direct-Access     SUN      COMSTAR          1.0  PQ: 0 ANSI: 5
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:1: Attached scsi generic sg2 type 0
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:1: [sdc] 409600 512-byte logical blocks: (209 MB/200 MiB)
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:1: [sdc] Write Protect is off
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:1: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 20 14:06:13 vsa33 kernel: scsi 6:0:0:2: Direct-Access     SUN      COMSTAR          1.0  PQ: 0 ANSI: 5
Dec 20 14:06:13 vsa33 kernel: sdc: unknown partition table
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:2: Attached scsi generic sg3 type 0
Dec 20 14:06:13 vsa33 kernel: scsi 6:0:0:3: Direct-Access     SUN      COMSTAR          1.0  PQ: 0 ANSI: 5
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:3: Attached scsi generic sg4 type 0
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:2: [sdd] 409600 512-byte logical blocks: (209 MB/200 MiB)
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:3: [sde] 104857600 512-byte logical blocks: (53.6 GB/50.0 GiB)
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:0: [sdb] Write Protect is off
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:3: [sde] Write Protect is off
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:3: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:1: [sdc] Attached SCSI disk
Dec 20 14:06:13 vsa33 kernel: sdb: unknown partition table
Dec 20 14:06:13 vsa33 kernel: sde: unknown partition table
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:2: [sdd] Write Protect is off
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:0: [sdb] Attached SCSI disk
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:3: [sde] Attached SCSI disk
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:2: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 20 14:06:13 vsa33 kernel: sdd: unknown partition table
Dec 20 14:06:13 vsa33 kernel: sd 6:0:0:2: [sdd] Attached SCSI disk
Dec 20 14:08:02 vsa33 kernel: scsi host6: ib_srp: failed send status 5
Dec 20 14:08:29 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:08:39 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:08:39 vsa33 kernel: scsi host6: SRP reset_device called
Dec 20 14:08:39 vsa33 kernel: scsi host6: ib_srp: SRP reset_host called
Dec 20 14:08:40 vsa33 kernel: scsi host6: ib_srp: Got failed path rec status -110
Dec 20 14:08:40 vsa33 kernel: scsi host6: ib_srp: Path record query failed
Dec 20 14:08:40 vsa33 kernel: scsi host6: ib_srp: reconnect failed (-110), removing target port.
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:1: Device offlined - not ready after error recovery
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:1: [sdc] Unhandled error code
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:1: [sdc]
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:1: [sdc] CDB:
Dec 20 14:08:40 vsa33 kernel: end_request: I/O error, dev sdc, sector 0
Dec 20 14:08:40 vsa33 kernel: Buffer I/O error on device sdc, logical block 0
Dec 20 14:08:40 vsa33 kernel: Buffer I/O error on device sdc, logical block 1
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:1: rejecting I/O to offline device
Dec 20 14:08:40 vsa33 kernel: Buffer I/O error on device sdc, logical block 2
Dec 20 14:08:40 vsa33 kernel: Buffer I/O error on device sdc, logical block 3
Dec 20 14:08:40 vsa33 kernel: sd 6:0:0:0: [sdb] Synchronizing SCSI cache
Dec 20 14:09:41 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:09:51 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:09:51 vsa33 kernel: scsi host6: SRP reset_device called
Dec 20 14:09:51 vsa33 kernel: scsi host6: ib_srp: SRP reset_host called
Dec 20 14:09:52 vsa33 kernel: scsi host6: ib_srp: Got failed path rec status -110
Dec 20 14:09:52 vsa33 kernel: scsi host6: ib_srp: Path record query failed
Dec 20 14:09:52 vsa33 kernel: scsi host6: ib_srp: reconnect failed (-110), removing target port.
Dec 20 14:09:52 vsa33 kernel: sd 6:0:0:0: Device offlined - not ready after error recovery
Dec 20 14:10:53 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:11:03 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:11:03 vsa33 kernel: scsi host6: SRP reset_device called
Dec 20 14:11:03 vsa33 kernel: scsi host6: ib_srp: SRP reset_host called
Dec 20 14:11:04 vsa33 kernel: scsi host6: ib_srp: Got failed path rec status -110
Dec 20 14:11:04 vsa33 kernel: scsi host6: ib_srp: Path record query failed
Dec 20 14:11:04 vsa33 kernel: scsi host6: ib_srp: reconnect failed (-110), removing target port.
Dec 20 14:11:04 vsa33 kernel: sd 6:0:0:0: Device offlined - not ready after error recovery
Dec 20 14:12:05 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:12:15 vsa33 kernel: scsi host6: SRP abort called
Dec 20 14:12:15 vsa33 kernel: scsi host6: SRP reset_device called
Dec 20 14:12:15 vsa33 kernel: scsi host6: ib_srp: SRP reset_host called
Dec 20 14:12:15 vsa33 kernel: scsi host6: ib_srp: reconnect succeeded
Dec 20 14:12:25 vsa33 kernel: sd 6:0:0:1: [sdc] Synchronizing SCSI cache
Dec 20 14:12:25 vsa33 kernel: sd 6:0:0:2: [sdd] Synchronizing SCSI cache
Dec 20 14:12:25 vsa33 kernel: sd 6:0:0:3: [sde] Synchronizing SCSI cache



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
