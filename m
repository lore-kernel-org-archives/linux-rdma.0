From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: kernull NULL pointer observed on initiator side after 'nvmetcli
 clear' on target side
Date: Mon, 6 Mar 2017 13:25:39 +0200
Message-ID: <644fc4ab-df6b-a337-1431-bad881ef56ee@grimberg.me>
References: <1053522223.31446389.1488721184925.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1053522223.31446389.1488721184925.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hi experts
>
> If I offline one CPU on initiator side and nvmetcli clear on target side, it will cause kernel NULL pointer on initiator side, could you help check it, thanks
>
> Steps to reproduce:
> 1. setup nvmet target with null-blk device:
> #modprobe nvmet
> #modprobe nvmet-rdma
> #modprobe null_blk nr_devices=1
> #nvmetcli restore rdma.json
>
> 2. connect the target on initiator side and offline one cpu:
> #modprobe nvme-rdma
> #nvme connect-all -t rdma -a 172.31.2.3 -s 1023
> #echo 0 > /sys/devices/system/cpu/cpu1/online
>
> 3. nvmetcli clear on target side
> #nvmetcli clear
>
> Kernel log:
>
> [  125.039340] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.2.3:1023
> [  125.160587] nvme nvme0: creating 16 I/O queues.
> [  125.602244] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.2.3:1023
> [  140.930343] Broke affinity for irq 16
> [  140.950295] Broke affinity for irq 28
> [  140.969957] Broke affinity for irq 70
> [  140.986584] Broke affinity for irq 90
> [  141.003160] Broke affinity for irq 93
> [  141.019779] Broke affinity for irq 97
> [  141.036341] Broke affinity for irq 100
> [  141.053782] Broke affinity for irq 104
> [  141.072860] smpboot: CPU 1 is now offline
> [  154.768104] nvme nvme0: reconnecting in 10 seconds
> [  165.349689] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  165.387783] IP: blk_mq_reinit_tagset+0x35/0x80

Looks like blk_mq_reinit_tagset is not aware that tags can go away with
cpu hotplug...

Does this fix your issue:
--
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index e48bc2c72615..9d97bfc4d465 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -295,6 +295,9 @@ int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
         for (i = 0; i < set->nr_hw_queues; i++) {
                 struct blk_mq_tags *tags = set->tags[i];

+               if (!tags)
+                       continue;
+
                 for (j = 0; j < tags->nr_tags; j++) {
                         if (!tags->static_rqs[j])
                                 continue;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
