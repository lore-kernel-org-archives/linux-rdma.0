From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Mon, 2 Oct 2017 20:47:08 -0400
Message-ID: <68a08a10-5b8d-4fd7-ad06-8add423bd3cd@intel.com>
References: <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
 <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
 <20170929145950.GC2965@mtr-leonro.local>
 <20170929152707.GA34521@knc-06.sc.intel.com>
 <20171002042323.GG2031@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002042323.GG2031-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/2/2017 12:23 AM, Leon Romanovsky wrote:
> Upstream is not a development playground and you should submit your code once
> you think that it is ready. So we are assuming that VNIC is working and
> you are interested to debug your EM and such code doesn't belong to the kernel.

This patch aside, I do have to take some issue with this statement. 
While upstream is not a "playground" we should be submitting code early. 
I keep harping on iterative development, show your work. Granted that 
doesn't mean write broken code and toss it over the fence to kernel.org, 
but pieces that can be broken up and tested on their own are best.

> If you still insist on 2.a, the solution should be in your company: add
> debugfs locally, write tests, find and fix bugs and submit them to
> upstream.

Now back to this patch series. debugfs vs NetLink, I don't think it 
really matters if the rationale for having the patch in the first place 
is wrong. In other words you would have still opposed this even if it 
were NetLink I assume? We are discussing internally but for now I think 
this series can be dropped.

> There is no need to add "one-time" interface to clean the code.

That I would agree to.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
