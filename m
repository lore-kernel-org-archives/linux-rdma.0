From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/3] Three SRP driver patches for kernel 4.5
Date: Thu, 31 Dec 2015 09:54:35 +0100
Message-ID: <5684ED4B.2010303@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

This series of three patches fixes new issues that exist in the
git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/k.o/for-4.5 
branch. It would be appreciated if these patches could be included in 
the kernel 4.5 RDMA pull request.

0001-irq_poll-Fix-irq_poll_sched.patch
0002-IB-srpt-Fix-the-RDMA-completion-handlers.patch
0003-IB-srpt-Fix-a-race-condition-related-to-SRP-login.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
