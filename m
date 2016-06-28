From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/5] Make RDMA RW API SGE limit configurable
Date: Tue, 28 Jun 2016 13:23:35 +0200
Message-ID: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The five patches in this series modify the RDMA RW API slightly. This is 
needed to avoid that the SRP and iSER target drivers submit RDMA 
requests with an SGE list that exceeds the queue pair limits. The 
ib_srpt changes in this series have been tested but the ib_isert changes 
not yet. The individual patches in this series are:

0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
0002-IB-core-Add-max_sge-argument-to-rdma_rw_ctx_init.patch
0003-IB-isert-Limit-the-number-of-SG-elements-per-work-re.patch
0004-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
0005-IB-srpt-Simplify-srpt_queue_response.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
