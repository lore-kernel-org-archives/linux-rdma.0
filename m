From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/7] IB/srp: Second series of patches for kernel v4.7
Date: Thu, 12 May 2016 10:46:41 -0700
Message-ID: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

Since the first eight patches of the patch series "[PATCH 0/11] More SRP 
patches for kernel v4.7" have already been applied I'm reposting version 
two of the reworked remaining patches. These patches are:

0001-IB-srp-Print-ib_srp-prefix-once.patch
0002-IB-srp-Fix-a-memory-descriptor-leak-in-an-error-path.patch
0003-IB-srp-Fix-srp_create_target-error-handling.patch
0004-IB-core-Enhance-ib_map_mr_sg.patch
0005-IB-srp-Swap-two-code-blocks-in-srp_add_one.patch
0006-IB-srp-Prevent-mapping-failures.patch
0007-IB-srp-Do-not-register-memory-if-never_register-has-.patch

The changes compared to v1 of this patch series are:
* Fixed a bug in patch 4/7, the patch that modifies ib_map_mr_sg().
* Added code that checks how many data has been mapped in patch 6/7.
   This code can be enabled and disabled dynamically via the dynamic
   debug mechanism.
* Added a seventh patch that introduces the never_register parameter.

This patch series is based on Christoph's RDMA read/write API rework 
patch series.

A git tree with these patches is available at 
https://github.com/bvanassche/linux/commits/srp-initiator-for-next.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
