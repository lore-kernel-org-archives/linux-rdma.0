From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] staging/rdma/hfi1,IB/rdmavt: Misc bug fixes
Date: Thu, 18 Feb 2016 16:41:33 -0500
Message-ID: <20160218214132.GA28494@phlsvsds.ph.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com> <20160218203923.GH30450@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218203923.GH30450-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 18, 2016 at 10:39:23PM +0200, Leon Romanovsky wrote:
>On Thu, Feb 18, 2016 at 11:11:48AM -0800, Dennis Dalessandro wrote:
>> These patches fix a few issues in the hfi1 driver as well as a 0-day build error
>> that was caught on my public GitHub tree.
>> 
>> Patch series applies on the recent "checkpatch fixes" series for hfi1. It can
>> also be seen on GitHub at: https://github.com/ddalessa/kernel/tree/for-4.6.
>> 
>> ---
>> 
>> Dean Luick (5):
>>       staging/rdma/hfi1: Fix xmit discard error weight
>>       staging/rdma/hfi1: Fix debugfs access race
>>       staging/rdma/hfi1: Disclose more information when i2c fails
>>       staging/rdma/hfi1: Guard i2c access against cp
>>       staging/rdma/hfi1: Fix counter read for cp
>> 
>> Easwar Hariharan (1):
>>       staging/rdma/hfi1: Cleanup comments and logs in PHY code
>> 
>> Mike Marciniszyn (2):
>>       staging/rdma/hfi1: fix 0-day syntax error
>>       IB/rdamvt: fix cross build with rdmavt
>
>For future submissions, can you be more consistent with capital letter
>at the beginning of subject line?
>
>Thanks.

Taking a quick look at the git log I don't see any particular style. Blurb 
from the first screen of a git log command...

$ git log --pretty=format:'%s' 441388a8a~1..91a25e463
drm/dp/mst: deallocate payload on port destruction
drm/dp/mst: Reverse order of MST enable and clearing VC payload table.
drm/dp/mst: move GUID storage from mgr, port to only mst branch
drm/dp/mst: change MST detection scheme
drm/dp/mst: Calculate MST PBN with 31.32 fixed point
drm: Add drm_fixp_from_fraction and drm_fixp2int_ceil
drm/mst: Add range check for max_payloads during init
drm/mst: Don't ignore the MST PBN self-test result

Should there be any preference one way or the other?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
