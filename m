From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Tue, 24 Oct 2017 15:49:57 -0400
Message-ID: <bc6c518a-3c68-0edf-8089-390e78d674e4@intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
 <20171023183848.GC16127@mtr-leonro.local>
 <d09970ea-2531-4d8e-0b4f-85533ff8487a@intel.com>
 <20171023193102.GE16127@mtr-leonro.local>
 <b1ec461a-9c04-ff16-2a2a-4f21dfbfbcb1@intel.com>
 <20171024145628.GA28224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024145628.GA28224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/24/2017 10:56 AM, Jason Gunthorpe wrote:
> On Tue, Oct 24, 2017 at 10:02:23AM -0400, Dennis Dalessandro wrote:
> 
>> Right, which doesn't say not to put it in a .c file. So I think the location
>> is OK for this. However, whether it even needs to be an inline function at
>> all in the first place is certainly a valid question. Let me chat with
>> Sebastian and double check, if it doesn't really need to be inlined we'll
>> send a v2.
> 
> The general thinking is that the compiler is much better at deciding
> if something should be inlined or not. For the case of 'static' the
> compiler will always inline it if it makes sense. 'static inline'
> disables that heuristic and forces the compiler to always inline..
> 

After talking with Sebastian, this doesn't need to be inlined after all. 
I will send a v2.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
