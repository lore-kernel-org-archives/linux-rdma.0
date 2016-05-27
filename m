From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 07:44:15 -0400
Message-ID: <20160527114414.GA27420@phlsvsds.ph.intel.com>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com> <20160527045157.GW25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160527045157.GW25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 27, 2016 at 07:51:57AM +0300, Leon Romanovsky wrote:
>On Thu, May 26, 2016 at 06:34:28PM -0400, Doug Ledford wrote:
>> Hi Linus,
>> 
>> This is the second group of code for the 4.7 merge window.  It looks
>> large, but only in one sense.  I'll get to that in a minute.  The list
>> of changes here breaks down as follows:
>> 
>> Round two of 4.7 merge window patches
>> 
>
><...>
>
>> - The big item on the list: hfi1 driver updates, plus moving the hfi1
>>   driver out of staging                             <- everything else
>
>Hi Doug and Linus,
>
>The move hfi1 from the staging is a right thing, it was there a long
>time and it is almost ready.

No, not almost, it is totally ready. We have bent over backwards to go well 
beyond what was in the TODO list. This is a clean, stable, and well 
performing driver.

>However the timing of this move puzzle me, we are in the process of ABI
>change [1, 2] as a response to security alert [3]. Moves like this with
>proprietary char device and ABI scheme different from whole RDMA stack
>will limit the ABI work without real need.

The driver sitting in staging or not has no impact on the ABI re-design.  
They are two completely separate issues.

>Will this driver be **forced** to adjust to new ABI scheme whenever it
>comes? If it is not possible, the better solution to converge on ABI change will be
>to leave this driver in staging/rdma and wait till proper solution will be accepted.

I think Doug has made it perfectly clear that hfi1 will need to adopt the 
new ABI when it is available, and we are certainly on board with that.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
