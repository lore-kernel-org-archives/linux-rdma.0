From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/5] ib_srp: hold a mutex when adding a new target port
Date: Sat, 01 Sep 2012 07:55:05 +0000
Message-ID: <5041BF59.70307@acm.org>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com> <1346443241-24844-4-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-4-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/31/12 20:00, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org wrote:
> ------------[ cut here ]------------
> WARNING: at block/genhd.c:1466 __disk_unblock_events+0x10f/0x120()
> Pid: 17238, comm: scsi_id Not tainted 3.2.8-pserver #1
> Call Trace:
>  [<ffffffff81048dbb>] ? warn_slowpath_common+0x7b/0xc0
>  [<ffffffff813879bf>] ? __disk_unblock_events+0x10f/0x120
>  [<ffffffff81162b30>] ? __blkdev_get+0x190/0x410
>  [<ffffffff811630c0>] ? blkdev_get+0x310/0x310
>  [<ffffffff81162dfb>] ? blkdev_get+0x4b/0x310
>  [<ffffffff811630c0>] ? blkdev_get+0x310/0x310
>  [<ffffffff8112d513>] ? __dentry_open+0x263/0x370
>  [<ffffffff8113a0fe>] ? path_get+0x1e/0x30
>  [<ffffffff8113b4a0>] ? do_last+0x3e0/0x800
>  [<ffffffff8113c21b>] ? path_openat+0xdb/0x400
>  [<ffffffff8113c66d>] ? do_filp_open+0x4d/0xc0
>  [<ffffffff81148c13>] ? alloc_fd+0x43/0x130
>  [<ffffffff8112d915>] ? do_sys_open+0x105/0x1e0
>  [<ffffffff8165d512>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 4edc2747f936431c ]---

That's the "if (WARN_ON_ONCE(ev->block <= 0))" in kernel version 3.2
that you hit, isn't it ? That's not caused by ib_srp but by a race in
the genhd layer. Please have a look at commit 9f53d2fe ("block: fix
__blkdev_get and add_disk race condition").

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
