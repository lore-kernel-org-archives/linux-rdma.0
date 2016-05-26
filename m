From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/10] IB/hfi1: Add a retry for the first-time QSFP access
Date: Thu, 26 May 2016 13:39:49 -0400
Message-ID: <20160526173948.GD32312@phlsvsds.ph.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com> <20160524195052.19706.43009.stgit@scvm10.sc.intel.com> <6395227d-617c-bd70-2822-6b53843f8611@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6395227d-617c-bd70-2822-6b53843f8611-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 12:17:16PM -0400, Doug Ledford wrote:
>On 05/24/2016 03:50 PM, Dennis Dalessandro wrote:
>> From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> Some QSFPs do not respond within the expected time, but later
>> appear fine.  Add a limited retry on the first access.
>
>10 seconds is an awful long delay period.  Admittedly I didn't look
>through the sources to see if the refresh is already happening in the
>context of a delayed work queue or similar, so maybe you can ignore
>this, but if you're going to delay for 10 seconds, it should probably be
>done from a workqueue and not via msleep(2000); goto retry;.

Yeah the 10 seconds may be a bit long. I think we can go ahead and drop this 
from the queue for 4.7 merge window since it is winding down. 

Using a workqueue may be the right way to go but there may be some subtle 
issues there I'd like to think through so rather than rush we can wait for 
rc or 4.8 even.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
