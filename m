From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 22/27] IB/hfi1: Add receive fault injection feature
Date: Tue, 28 Feb 2017 12:55:30 -0500
Message-ID: <91e05e83-b225-45ce-a975-00282f15caa2@intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
 <20170208132800.16442.94549.stgit@scvm10.sc.intel.com>
 <20170212174205.GI14015@mtr-leonro.local>
 <1487109065.86943.86.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487109065.86943.86.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/14/2017 04:51 PM, Doug Ledford wrote:
> On Sun, 2017-02-12 at 19:42 +0200, Leon Romanovsky wrote:
>> On Wed, Feb 08, 2017 at 05:28:01AM -0800, Dennis Dalessandro wrote:
>>
>> First no need to set default to "n", it is already default.
>> Second, we got NAK from Doug while we proposed to add new Kconfig to
>> our
>> driver (mlx5) to improve debug.
>>
>> Doug,
>> I would like to know if your statement do not add new Kconfigs to IB
>> is
>> still relevant.
>
> As much as is possible, yes.  Kconfig bloat is something I very much
> want to avoid.  I would be more willing to have a single, global
> CONFIG_INFINIBAND_DEBUG option that turned on debugging stack wide than
> I would for individual drivers to each have their own debug configs.

Been talking among ourselves here and for this patch and the other one 
we can just rely on the standard CONFIG_FAULT_INJECTION. I will resubmit 
those with my next set of patches.

In the future though it may be nice rather than having a single debug 
variable, but a small set of them that are used stack wide. So no mlx or 
hfi1, etc specific ones, but just for instance a general reference 
counting flag for mrs and qps. If we come up with some small sane list 
that we can all agree on would that be acceptable? Yeah we are growing 
the kconfig but it's at least controlled and thought out.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
