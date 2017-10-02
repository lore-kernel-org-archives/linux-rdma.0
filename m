From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Mon, 2 Oct 2017 14:51:43 +0200
Message-ID: <729c512f-55ff-25e4-6dd9-8b4dcc31bb8d@grimberg.me>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
 <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
 <e44f4640-44b2-4692-ca57-08f9ebf4da2c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e44f4640-44b2-4692-ca57-08f9ebf4da2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

>>> Panic after connection with below commits, detailed log here: 
>>> https://pastebin.com/7z0XSGSd
>>> 31fdf18     nvme-rdma: reuse configure/destroy_admin_queue
>>> 3f02fff       nvme-rdma: don't free tagset on resets
>>> 18398af    nvme-rdma: disable the controller on resets
>>> b28a308   nvme-rdma: move tagset allocation to a dedicated routine
>>>
>>> good    34b6c23 nvme: Add admin_tagset pointer to nvme_ctrl
>>
>> Is that a reproducible panic? I'm not seeing this at all.
>>
> 
> Yes, I can reproduce every time. And the target side kernel version is 
> 4.14.0-rc1 during the panic occurred.
> 
>> Can you run gdb on nvme-rdma.ko
>> $ l *(nvme_rdma_create_ctrl+0x37d)
>>
> [root@rdma-virt-01 linux ((31fdf18...))]$ gdb 
> /usr/lib/modules/4.13.0-rc7.31fdf18+/kernel/drivers/nvme/host/nvme-rdma.ko
> GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-100.el7
> Copyright (C) 2013 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later 
> <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from 
> /usr/lib/modules/4.13.0-rc7.31fdf18+/kernel/drivers/nvme/host/nvme-rdma.ko...done. 
> 
> (gdb) l *(nvme_rdma_create_ctrl+0x37d)
> 0x297d is in nvme_rdma_create_ctrl (drivers/nvme/host/rdma.c:656).
> 651        struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
> 652        struct blk_mq_tag_set *set = admin ?
> 653                &ctrl->admin_tag_set : &ctrl->tag_set;
> 654
> 655        blk_mq_free_tag_set(set);
> 656        nvme_rdma_dev_put(ctrl->device);
> 657    }
> 658
> 659    static struct blk_mq_tag_set *nvme_rdma_alloc_tagset(struct 
> nvme_ctrl *nctrl,
> 660            bool admin)
> (gdb)

Lets take this one step at a time, starting with this issue.

First, there is a reason why a simple create_ctrl fails, can we isolate
exactly which call fails? Was something else going on that might have
made the simple create_ctrl fail?

We don't see any "rdma_resolve_addr failed" or "failed to connect queue"
messages but we do see "creating I/O queues" which means that we either
failed at IO tagset allocation or initializing connect_q.

We have a missing error code assignment so can you try the following patch:
--
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 58983000964b..98dd51e630bd 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -765,8 +765,10 @@ static int nvme_rdma_configure_admin_queue(struct 
nvme_rdma_ctrl *ctrl,

         if (new) {
                 ctrl->ctrl.admin_tagset = 
nvme_rdma_alloc_tagset(&ctrl->ctrl, true);
-               if (IS_ERR(ctrl->ctrl.admin_tagset))
+               if (IS_ERR(ctrl->ctrl.admin_tagset)) {
+                       error = PTR_ERR(ctrl->ctrl.admin_tagset);
                         goto out_free_queue;
+               }

                 ctrl->ctrl.admin_q = 
blk_mq_init_queue(&ctrl->admin_tag_set);
                 if (IS_ERR(ctrl->ctrl.admin_q)) {
@@ -846,8 +848,10 @@ static int nvme_rdma_configure_io_queues(struct 
nvme_rdma_ctrl *ctrl, bool new)

         if (new) {
                 ctrl->ctrl.tagset = nvme_rdma_alloc_tagset(&ctrl->ctrl, 
false);
-               if (IS_ERR(ctrl->ctrl.tagset))
+               if (IS_ERR(ctrl->ctrl.tagset)) {
+                       ret = PTR_ERR(ctrl->ctrl.tagset);
                         goto out_free_io_queues;
+               }

                 ctrl->ctrl.connect_q = blk_mq_init_queue(&ctrl->tag_set);
                 if (IS_ERR(ctrl->ctrl.connect_q)) {
--

Also, can you add the following debug messages to find out what failed?
--
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 58983000964b..e46475100eea 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -676,6 +676,12 @@ static void nvme_rdma_free_tagset(struct nvme_ctrl 
*nctrl, bool admin)
         struct blk_mq_tag_set *set = admin ?
                         &ctrl->admin_tag_set : &ctrl->tag_set;

+       if (set == &ctrl->tag_set) {
+               pr_err("%s: freeing IO tagset\n", __func__);
+       } else {
+               pr_err("%s: freeing ADMIN tagset\n", __func__);
+       }
+
         blk_mq_free_tag_set(set);
         nvme_rdma_dev_put(ctrl->device);
  }
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
