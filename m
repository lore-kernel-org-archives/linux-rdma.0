From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 00/10] i40iw: Fixes and optimizations
Date: Fri, 9 Dec 2016 18:33:30 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10AC5AA2@fmsmsx104.amr.corp.intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I am sorry I missed to specify rdma-core in the patch description for the V2 series.
All ten patches in the series are rdma-core V2 patches.

Thank you,
Tatyana

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tatyana Nikolova
Sent: Friday, December 09, 2016 11:55 AM
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: [PATCH V2 00/10] i40iw: Fixes and optimizations

The patch series includes fixes, optimizations and clean up to the user space i40iw.

V2 Changes:

Use do/while(0) in i40iw_debug macro.

Mustafa Ismail (4):
  i40iw: Optimize setting fragments
  i40iw: Remove unnecessary parameter
  i40iw: Optimize inline data copy
  i40iw: Remove unnecessary check for moving CQ head

Shiraz Saleem (6):
  i40iw: Fix incorrect assignment of SQ head
  i40iw: Return correct error codes for destroy QP and CQ
  i40iw: Do not destroy QP/CQ if lock is held
  i40iw: Control debug error prints using env variable
  i40iw: Use 2M huge pages for CQ/QP memory if available
  i40iw: Remove SQ size constraint

 providers/i40iw/i40iw_d.h      |   6 +-
 providers/i40iw/i40iw_uk.c     |  62 ++++++++------------
 providers/i40iw/i40iw_umain.c  |  21 ++++++-  providers/i40iw/i40iw_umain.h  |  11 ++++
 providers/i40iw/i40iw_user.h   |   2 +-
 providers/i40iw/i40iw_uverbs.c | 128 ++++++++++++++++++++++++++++++-----------
 6 files changed, 153 insertions(+), 77 deletions(-)

--
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
