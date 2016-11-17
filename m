From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: rdma-core release process questions
Date: Thu, 17 Nov 2016 04:56:45 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10AB79D5@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

We are submitting patches to the kernel space driver i40iw and to the user space plugin libi40iw, which is currently part of rdma-core. Some of the changes need to be coordinated so that they appear in both kernel space and user space in corresponding releases. We have some questions regarding the process about submitting patches to rdma-core which have dependencies on kernel patches.

1) Can user space patches target a for-next rdma-core release, if the corresponding kernel patches are queued for the next kernel? 

2) How are ABI changes handled in rdma-core?

3) Could you explain the release process for rdma-core? 

4) Is each rdma-core release going to correspond to a specific kernel version?

Thank you,
Tatyana
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
