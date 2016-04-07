From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/11] IB/hfi1: Additional fixes for 4.6
Date: Thu, 7 Apr 2016 16:24:04 -0400
Message-ID: <20160407202403.GA7211@phlsvsds.ph.intel.com>
References: <20160315174916.613.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315174916.613.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2016 at 10:54:00AM -0700, Dennis Dalessandro wrote:
>These are some more fixes we've identified that we would like to make it into
>4.6 if possible. Two of these are related to the pinned page cache series which
>is undergoing discussion if that series does not go these two from Mitko below
>would not apply.

Doug,

You can drop this series. I'll resubmit since these target the files in the 
infiniband/hfi1 directory rather than staging/rdma/hfi1.

I have some additional patches as well. Perhaps it is more than we want in 
an RC. I'm going to reorder things and submit two patch sets. One that fixes 
critical bugs, and should most likely go in RC. The other we would certainly 
like to be in an RC but fix less critical issues.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
