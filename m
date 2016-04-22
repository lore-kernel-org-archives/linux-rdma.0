From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/11] More SRP patches for kernel v4.7
Date: Fri, 22 Apr 2016 14:11:11 -0700
Message-ID: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

This patch series is what I came up with while retesting the SRP 
initiator. Please consider these patches for inclusion in kernel v4.7. 
Several of the patches in this series had already been posted in October 
2015. See also http://thread.gmane.org/gmane.linux.drivers.rdma/30216.

The individual patches in this series are:

0001-IB-srp-Fix-a-spelling-error-in-a-source-code-comment.patch
0002-IB-srp-Fix-a-comment.patch
0003-IB-srp-Document-srp_map_data-return-value.patch
0004-IB-srp-Fix-srp_map_data-error-paths.patch
0005-IB-srp-Introduce-target-mr_pool_size.patch
0006-IB-srp-Avoid-that-mapping-failure-triggers-an-infini.patch
0007-IB-srp-Move-code-out-of-a-loop.patch
0008-IB-srp-Move-common-code-into-the-caller.patch
0009-IB-srp-Fix-a-NULL-pointer-dereference.patch
0010-IB-srp-Do-not-register-memory-if-register_always-1.patch
0011-IB-srp-Prevent-mapping-failures.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
