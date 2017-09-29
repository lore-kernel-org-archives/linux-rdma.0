From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Fri, 29 Sep 2017 08:27:08 -0700
Message-ID: <20170929152707.GA34521@knc-06.sc.intel.com>
References: <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
 <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
 <20170929145950.GC2965@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929145950.GC2965-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 29, 2017 at 05:59:50PM +0300, Leon Romanovsky wrote:
>On Fri, Sep 29, 2017 at 10:46:51AM -0400, Dennis Dalessandro wrote:
>>
>> All of this vnic stuff is a work in progress and we are incrementally
>> pushing things out. Iterative development, involving the community and all.
>
>Can we get OPA-VNIC specification? Can we get OPA specification?
>
>The Documentation/infiniband/opa_vnic.txt is not enough to really
>implement anything on top of that or communicate with that.
>
>For example, what are the values and relations for routing control? How
>is entropy calculated?
>

You are putting a wrong interpretation to this patch.
EM provides the encapsulation configuration as in the opa_vnic documentation.
EM will be opensourced when it is ready (VNIC is development in progress).

As mentioned, this patch is a simple *debug* hook to that encapsulation 
configuration and no more.
That is why it is put under DEBUGFS.

I do see valid reason in Jason's and your earlier comments that it should a 
formal support to the admins.
But this patch was not mainly for that. I don't expect DEBUGFS to be turned on 
in all deployments.
I understand the question whether or not this patch should be in the kernel 
tree.
But it is a useful debug hook for debugging/triaging issues (similar to NIC 
having debug hook read/write some register), and convenient to have it 
available in the kernel than maintaining it separately.

Niranjana

>Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
