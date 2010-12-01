From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: NFS-RDMA hangs: connection closed (-103)
Date: Wed, 01 Dec 2010 17:59:00 -0600
Message-ID: <4CF6E144.1080200@opengridcomputing.com>
References: <4CF6D69B.4030501@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF6D69B.4030501-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Spelic <spelic-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Spelic,

I have seen this problem before, but have not been able to reliably 
reproduce it. When I saw the problem, there were no transport errors and 
it appeared as if the I/O had actually completed, but that the waiter was 
not being awoken. I was not able to reliably reproduce the problem and was 
not able to determine if the problem was a latent bug in NFS in general or 
a bug in the RDMA transport in particular.

I will try your setup here, but I don't have a system like yours so I'll 
have to settle for a smaller ramdisk, however, I have a few questions:

- Does the FS matter? For example, can you use ext[2-4] on the ramdisk and 
not still reproduce
- As I mentioned earlier NFS v3 vs. NFS v4
- RAMDISK size, i.e. 2G vs. 14G

Thanks,
Tom

On 12/1/10 5:13 PM, Spelic wrote:
> Hello all
>
> First of all: I have tried to send this message to the list at least 3 
> times but it doesn't seem to get through (and I'm given no error back).
> It was very long with 2 attachments... is is because of that? What are 
> the limits of this ML?
> This time I will shorten it a bit and remove the attachments.
>
> Here is my problem:
> I am trying to use NFS over RDMA. It doesn't work: hangs very soon.
> I tried kernel 2.6.32 from ubuntu 10.04, and then I tried the most 
> recent upstream 2.6.37-rc4 compiled from source. They behave basically 
> the same regarding the NFS mount itself, only difference is that 2.6.32 
> will hang the complete operating system when nfs hangs, while 2.6.37-rc4 
> (after nfs hangs) will only hang processes which launch sync or list nfs 
> directories. Anyway the mount is hanged forever; does not resolve by 
> itself.
> IPoIB nfs mounts appear to work flawlessly, the problem is with RDMA only.
>
> Hardware: (identical client and server machines)
> 07:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx 
> HCA] (rev 20)
>         Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx HCA]
>         Flags: bus master, fast devsel, latency 0, IRQ 30
>         Memory at d8800000 (64-bit, non-prefetchable) [size=1M]
>         Memory at d8000000 (64-bit, prefetchable) [size=8M]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [48] Vital Product Data <?>
>         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/5 Enable-
>         Capabilities: [84] MSI-X: Enable+ Mask- TabSize=32
>         Capabilities: [60] Express Endpoint, MSI 00
>         Kernel driver in use: ib_mthca
>         Kernel modules: ib_mthca
>
>     Mainboard = Supermicro X7DWT with embedded infiniband.
>
> This is my test:
> on server I make a big 14GB ramdisk (exact boot option: 
> ramdisk_size=14680064), format xfs and mount like this:
>         mkfs.xfs -f -l size=128m -d agcount=16 /dev/ram0
>         mount -o nobarrier,inode64,logbufs=8,logbsize=256k /dev/ram0 
> /mnt/ram/
> On the client I mount like this (fstab):
>         10.100.0.220:/   /mnt/nfsram   nfs4    
> _netdev,auto,defaults,rdma,port=20049  0  0
>
> Then on the client I perform
>     echo begin; dd if=/dev/zero of=/mnt/nfsram/zerofile bs=1M ; echo 
> syncing now ; sync ; echo finished
>
> It hangs as soon as it reaches the end of the 14GB of space, but never 
> writes "syncing now". It seems like the "disk full" message triggers the 
> hangup reliably on NFS over RDMA over XFS over ramdisk; other 
> combinations are not so reliable for triggering the bug (e.g. ext4).
>
> However please note that this is not an XFS problem in itself: we had 
> another hangup on an ext4 filesystem on NFS on RDMA on real disks for 
> real work after a few hours (and it hadn't hit the "disk full" 
> situation); this technique with XFS on ramdisk is just more reliably 
> reproducible.
>
> Note that the hangup does not happen on NFS over IPoIB (no RDMA) over 
> XFS over ramdisk. It's really an RDMA-only bug.
> On the other machine (2.6.32) that was doing real work on real disks I 
> am now mounting over IPoIB without RDMA and in fact that one is still 
> running reliably.
>
> The dd process hangs like this: (/proc/pid/stack)
>     [<ffffffff810f8f75>] sync_page+0x45/0x60
>     [<ffffffff810f9143>] wait_on_page_bit+0x73/0x80
>     [<ffffffff810f9590>] filemap_fdatawait_range+0x110/0x1a0
>     [<ffffffff810f9720>] filemap_write_and_wait_range+0x70/0x80
>     [<ffffffff811766ba>] vfs_fsync_range+0x5a/0xa0
>     [<ffffffff8117676c>] vfs_fsync+0x1c/0x20
>     [<ffffffffa02bda1d>] nfs_file_write+0xdd/0x1f0 [nfs]
>     [<ffffffff8114d4fa>] do_sync_write+0xda/0x120
>     [<ffffffff8114d808>] vfs_write+0xc8/0x190
>     [<ffffffff8114e061>] sys_write+0x51/0x90
>     [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> The dd process is not killable with -9 . Stays alive and hanged.
>
> In the dmesg (client) you can see this line immediately, as soon as 
> transfer stops (iostat -n 1) and dd hangs up:
>      [ 3072.884988] rpcrdma: connection to 10.100.0.220:20049 closed (-103)
>
> after a while you can see this in dmesg
> [ 3242.890030] INFO: task dd:2140 blocked for more than 120 seconds.
> [ 3242.890132] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 3242.890239] dd            D ffff88040a8f0398     0  2140   2113 
> 0x00000000
> [ 3242.890243]  ffff88040891fb38 0000000000000082 ffff88040891fa98 
> ffff88040891fa98
> [ 3242.890248]  00000000000139c0 ffff88040a8f0000 ffff88040a8f0398 
> ffff88040891ffd8
> [ 3242.890251]  ffff88040a8f03a0 00000000000139c0 ffff88040891e010 
> 00000000000139c0
> [ 3242.890255] Call Trace:
> [ 3242.890264]  [<ffffffff81035509>] ? default_spin_lock_flags+0x9/0x10
> [ 3242.890269]  [<ffffffff810f8f30>] ? sync_page+0x0/0x60
> [ 3242.890273]  [<ffffffff8157b824>] io_schedule+0x44/0x60
> [ 3242.890276]  [<ffffffff810f8f75>] sync_page+0x45/0x60
> [ 3242.890279]  [<ffffffff8157c0bf>] __wait_on_bit+0x5f/0x90
> [ 3242.890281]  [<ffffffff810f9143>] wait_on_page_bit+0x73/0x80
> [ 3242.890286]  [<ffffffff81081bf0>] ? wake_bit_function+0x0/0x40
> [ 3242.890290]  [<ffffffff81103ce5>] ? pagevec_lookup_tag+0x25/0x40
> [ 3242.890293]  [<ffffffff810f9590>] filemap_fdatawait_range+0x110/0x1a0
> [ 3242.890296]  [<ffffffff810f9720>] filemap_write_and_wait_range+0x70/0x80
> [ 3242.890301]  [<ffffffff811766ba>] vfs_fsync_range+0x5a/0xa0
> [ 3242.890303]  [<ffffffff8117676c>] vfs_fsync+0x1c/0x20
> [ 3242.890319]  [<ffffffffa02bda1d>] nfs_file_write+0xdd/0x1f0 [nfs]
> [ 3242.890323]  [<ffffffff8114d4fa>] do_sync_write+0xda/0x120
> [ 3242.890328]  [<ffffffff812967c8>] ? apparmor_file_permission+0x18/0x20
> [ 3242.890333]  [<ffffffff81263323>] ? security_file_permission+0x23/0x90
> [ 3242.890335]  [<ffffffff8114d808>] vfs_write+0xc8/0x190
> [ 3242.890338]  [<ffffffff8114e061>] sys_write+0x51/0x90
> [ 3242.890343]  [<ffffffff8100c001>] ? system_call_after_swapgs+0x41/0x6c
> [ 3242.890346]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
> [ 3253.280020] nfs: server 10.100.0.220 not responding, still trying
>
>
> If I try an umount -f this happens:
>     umount2: Device or resource busy
>     umount.nfs4: /mnt/nfsram: device is busy
>     umount2: Device or resource busy
>     umount.nfs4: /mnt/nfsram: device is busy
> it stays mounted and processes are still hanged
> However if I repeat the umount -f  three times, at the third time it 
> does unmount. At that point the dd process is killed. However it's still 
> impossible to remount with RDMA, and lsmod shows:
>     xprtrdma               41048  1
> module in use with 1 reference.
>
> Only a reboot of the client allows to repeat the mount at this point.
> It is not needed to reboot the server.
>
>
> The dmesg at server side is this:
>
> for each hang at client side (with about 1 minute delay every time):
> BEGIN
>     [  464.780047] WARNING: at 
> net/sunrpc/xprtrdma/svc_rdma_transport.c:1162 
> __svc_rdma_free+0x20d/0x230 [svcrdma]()
>     [  464.780050] Hardware name: X7DWT
>     [  464.780051] Modules linked in: xfs binfmt_misc ppdev fbcon 
> tileblit font bitblit softcursor nfs radeon nfsd lockd svcrdma exportfs 
> ib_srp scsi_transport_srp fscache scsi_tgt rdma_ucm crc32c ib_ipoib 
> ib_iser nfs_acl auth_rpcgss rdma_cm ttm ib_cm iw_cm ib_sa ib_addr 
> mlx4_ib drm_kms_helper iscsi_tcp libiscsi_tcp drm libiscsi mlx4_core 
> scsi_transport_iscsi ib_mthca sunrpc ib_uverbs e1000e ib_umad ib_mad 
> ioatdma ib_core joydev i5400_edac psmouse edac_core usbhid i2c_algo_bit 
> lp shpchp dca hid parport i5k_amb serio_raw [last unloaded: xprtrdma]
>     [  464.780094] Pid: 11, comm: kworker/0:1 Not tainted 
> 2.6.37-rc4-stserver-mykernel3+ #1
>     [  464.780096] Call Trace:
>     [  464.780106]  [<ffffffff8105feef>] warn_slowpath_common+0x7f/0xc0
>     [  464.780110]  [<ffffffffa0220ff0>] ? __svc_rdma_free+0x0/0x230 
> [svcrdma]
>     [  464.780112]  [<ffffffff8105ff4a>] warn_slowpath_null+0x1a/0x20
>     [  464.780116]  [<ffffffffa02211fd>] __svc_rdma_free+0x20d/0x230 
> [svcrdma]
>     [  464.780119]  [<ffffffffa0220ff0>] ? __svc_rdma_free+0x0/0x230 
> [svcrdma]
>     [  464.780123]  [<ffffffff8107aa05>] process_one_work+0x125/0x440
>     [  464.780126]  [<ffffffff8107d1d0>] worker_thread+0x170/0x410
>     [  464.780129]  [<ffffffff8107d060>] ? worker_thread+0x0/0x410
>     [  464.780132]  [<ffffffff81081656>] kthread+0x96/0xa0
>     [  464.780137]  [<ffffffff8100ce64>] kernel_thread_helper+0x4/0x10
>     [  464.780139]  [<ffffffff810815c0>] ? kthread+0x0/0xa0
>     [  464.780142]  [<ffffffff8100ce60>] ? kernel_thread_helper+0x0/0x10
>     [  464.780144] ---[ end trace e31416a7a1dc2103 ]---
> END
>
> If at this point I restart nfs-kernel-server, this is the dmesg at 
> serverside:
>     [ 1119.778579] nfsd: last server has exited, flushing export cache
>     [ 1120.930444] svc: failed to register lockdv1 RPC service (errno 97).
>     [ 1120.930490] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 
> state recovery directory
>     [ 1120.930512] NFSD: starting 90-second grace period
> I'm not sure if the svc line is meaningful...
>
> I have the dmesgs of the client and server since boot if you are 
> interested, lsmod, and other stuff. I have removed them to see if the 
> message gets through to the list now...
>
> Thanks for your help
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
