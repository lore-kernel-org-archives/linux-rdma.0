From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/21] IB/hfi1: First round of fixes for 4.7
Date: Mon, 18 Apr 2016 09:38:43 -0400
Message-ID: <20160418133842.GA7596@phlsvsds.ph.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com> <20160418070936.GK6349@leon.nu> <20160418120754.GC17987@phlsvsds.ph.intel.com> <20160418121944.GL6349@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418121944.GL6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 03:19:44PM +0300, Leon Romanovsky wrote:
>On Mon, Apr 18, 2016 at 08:07:55AM -0400, Dennis Dalessandro wrote:
>> On Mon, Apr 18, 2016 at 10:09:36AM +0300, Leon Romanovsky wrote:
>> >On Tue, Apr 12, 2016 at 10:49:52AM -0700, Dennis Dalessandro wrote:
>> >>These patches do some clean ups and fix issues which may not be appropriate for
>> >>an RC so we are targeting these for 4.7. The current patch series applies on top
>> >>of the "Important bug fixes for 4.6 RC" patch set submitted just prior to this.
>> >>
>> >>Patches can be viewed in my GitHub repo at:
>> >>https://github.com/ddalessa/kernel/tree/for-4.7.
>> >
>> >Please follow SubmittingPatches guide - submitting fixes section.
>> >
>> 
>> Can you please be more specific with what your complaint is here? Which
>> section are you referring to? There is no "submitting fixes" section in the
>> document.
>
>
>If your patch fixes a bug in a specific commit, e.g. you found an issue
>using git-bisect, please use the 'Fixes:' tag with the first 12 characters of
>the SHA-1 ID, and the one line summary.  For example:
>
>  Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
>
>https://www.kernel.org/doc/Documentation/SubmittingPatches

When there is a specific commit that broke something, sure. I think folks 
usually add that when appropriate, it's not always the case. "Fix" is a 
general term in a lot of patches. Could be day-0 bug, or the result of 
multiple commits coming together, etc.

Regardless, is there a patch here in this series that you need more back 
story on?  Please let me know and I'll track it down.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
