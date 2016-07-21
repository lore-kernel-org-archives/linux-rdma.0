From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 0/5] Reduce RDMA RW API SGE limit
Date: Thu, 21 Jul 2016 13:02:39 -0700
Message-ID: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The five patches in this series modify the RDMA RW API slightly. This is 
needed to avoid that the SRP and iSER target drivers submit RDMA 
requests with an SGE list that exceeds the queue pair limits. The 
ib_srpt changes in this series have been tested but the ib_isert changes 
not yet.

The changes compared to v3 of this patch series are:
* Split the single QP SGE limit into separate READ and WRITE SGE limits.
* Added a comment in ib_srpt.h that explains where the SGE limit comes
   from.

Changes compared to v2:
* For RDMA READs, limit SGE back to dev->attrs.max_sge_rd for iWARP.

Changes compared to v1:
* max_send_sge is now stored in struct ib_qp. This greatly simplifies
    this patch series.
* An unneeded initialization that I had added to rdma_rw_init_one_mr()
    has been left out again.
* Corrected "Fixes" tag in the patch description where needed.

The individual patches in this series are:

0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
0002-IB-core-RDMA-RW-API-Do-not-exceed-QP-SGE-send-limit.patch
0003-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
0004-IB-srpt-Simplify-srpt_queue_response.patch
0005-IB-isert-Remove-an-unused-member-variable.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
