From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v4 0/4] IB/srp fixes
Date: Thu, 21 Feb 2013 18:15:45 +0100
Message-ID: <51265641.4060609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series avoids that SCSI error handling triggers an endless 
loop and also restores reporting of QP errors in the kernel log.

Changes between v4 and v3:
- Added a patch that ensures that the SCSI host gets removed in time
   when a user space process keeps queueing I/O during removal, e.g.
   an older version of multipathd.
- Added "Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.8" tag.

Changes between v3 and v2:
- As proposed by Dave, added a patch that prevents sending of a task
   management function over a closed connection.

Changes between v2 and v1:
- Track connection state properly.
- Make srp_reset_host() reset requests even if reconnecting fails
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
