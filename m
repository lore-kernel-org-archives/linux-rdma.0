From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 0/5] More SRP target patches for kernel v4.15
Date: Fri, 3 Nov 2017 16:20:51 -0700
Message-ID: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

Recently Mike Marciniszyn discovered that ib_srpt non-SRQ mode does not work
on Intel adapters and also that switching dynamically between non-SRQ and SRQ
mode does not work. This patch series addresses these two issues. Please
consider this patch series for kernel v4.15.

Thanks,

Bart.

Bart Van Assche (4):
  IB/srpt: Introduce helper functions for SRQ allocation and freeing
  IB/srpt: Introduce srpt_disconnect_ch_sync()
  IB/srpt: Wait until channel release has finished during module unload
  IB/srpt: Ensure that modifying the use_srq configfs attribute works

Mike Marciniszyn (1):
  IB/srpt: Post receive work requests after qp transition to INIT state

 drivers/infiniband/ulp/srpt/ib_srpt.c | 229 +++++++++++++++++++++-------------
 1 file changed, 143 insertions(+), 86 deletions(-)

-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
