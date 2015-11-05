From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: Convert dd_dev_info() to hfi1_cdbg() in process startup
Date: Thu, 5 Nov 2015 09:51:20 -0500
Message-ID: <20151105145119.GA16285@phlsvsds.ph.intel.com>
References: <1446696897-25892-1-git-send-email-jubin.john@intel.com> <20151105075836.GS18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151105075836.GS18797@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 10:58:36AM +0300, Dan Carpenter wrote:
>On Wed, Nov 04, 2015 at 11:14:57PM -0500, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> Replacing dd_dev_info() for hfi1_cdbg() to avoid generating syslog
>> output for every context that is open by PSM.
>> 
>
>Just delete it...  People get scared about deleting debug code but you
>can add it back if there is really a bug.
>
>/me chants, "delete.  delete.  delete."

I would tend to agree with that, but in this case we want to keep a way to 
get this information without making code changes. We just don't want it to 
spew to the console/syslog all the time. Instead we are using the trace 
mechanism which lets the user selectively turn on the messages when needed.

Perhaps we should expand on the commit message to make this more clear?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
