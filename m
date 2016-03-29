From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: Adding queue drain functions
Date: Tue, 29 Mar 2016 21:18:16 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10959FC7@fmsmsx104.amr.corp.intel.com>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
 <046801d189fc$7697f890$63c7e9b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <046801d189fc$7697f890$63c7e9b0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is locking in place in nes_poll_cq() which also protects the added drain queue functionality.

Thank you,
Tatyana

-----Original Message-----
From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org] 
Sent: Tuesday, March 29, 2016 3:49 PM
To: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; leon-2ukJVAZIZ/Y@public.gmane.org
Subject: RE: [PATCH] RDMA/nes: Adding queue drain functions

> 
> Adding sq and rq drain functions, which block until all previously 
> posted wr-s in the specified queue have completed.
> A completion object is signaled to unblock the thread, when the last 
> cqe for the corresponding queue is processed.
> 
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me.  No locking needed though?

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
