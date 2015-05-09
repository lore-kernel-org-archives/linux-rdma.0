From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/core: Fix unaligned accesses
Date: Fri, 08 May 2015 22:08:54 -0600
Message-ID: <554D8856.5050201@oracle.com>
References: <1430660906-215424-1-git-send-email-david.ahern@oracle.com>	 <554D0FBC.9090408@oracle.com> <1431141243.2407.481.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431141243.2407.481.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/8/15 9:14 PM, Doug Ledford wrote:
> On Fri, 2015-05-08 at 13:34 -0600, David Ahern wrote:
>> >ping? I have addressed all of the comments; anything else holding up a
>> >commit?
> Please check Linus' latest kernel, this patch should be present.
>
> For that matter, check my pull request, this patch was listed there.
>
> Although I admit that there were reviewed by tags not added to it now
> that I checked.  People reviewed v1/v2/v3 before you put out v4, but
> that didn't get captured by patchworks and I forgot to add it.  Sorry
> about that to the reviewers:-(
>

Ok. Every maintainer has a slightly different process; just want to 
check this off on my end.

Thanks,
David
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
