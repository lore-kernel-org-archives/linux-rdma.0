From: Ming Lin <mlin@kernel.org>
Subject: iSER multi-queue configuration
Date: Fri, 29 Apr 2016 14:11:55 -0700
Message-ID: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I use mlx5 to setup iSER and have scsi mq enabled.

root@xxx:~# cat /sys/module/scsi_mod/parameters/use_blk_mq
Y

But it seems there is only 1 HW queue that maps to 48 SW queues.

root@xxx:/sys/block/sdb/mq# ls
0

root@xxx:/sys/block/sdb/mq# ls 0/
active  cpu1   cpu11  cpu13  cpu15  cpu17  cpu19  cpu20  cpu22  cpu24
cpu26  cpu28  cpu3   cpu31  cpu33  cpu35  cpu37  cpu39  cpu40  cpu42
cpu44  cpu46  cpu5  cpu7  cpu9      dispatched  pending  run
cpu0    cpu10  cpu12  cpu14  cpu16  cpu18  cpu2   cpu21  cpu23  cpu25
cpu27  cpu29  cpu30  cpu32  cpu34  cpu36  cpu38  cpu4   cpu41  cpu43
cpu45  cpu47  cpu6  cpu8  cpu_list  io_poll     queued   tags

How to configure it that I can have 48 HW queues?
That is 1 HW queue map to 1 SW queue.

Thanks.
