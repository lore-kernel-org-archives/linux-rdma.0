From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Fri, 29 Sep 2017 10:46:51 -0400
Message-ID: <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170929054959.GJ2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/29/2017 1:49 AM, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 02:02:58PM -0600, Jason Gunthorpe wrote:
>> On Thu, Sep 28, 2017 at 10:37:40PM +0300, Leon Romanovsky wrote:
>>
>>>> We find it useful on an ongoing basis, more like some standard NICs
>>>> providing debugfs interface to read/write from/to some of its registers.
>>>
>>> Usually if such interface is spotted during submission, it will be requested
>>> to drop it. Ask Salil, who lately upstreamed new ETH driver and was asked
>>> to remove it.
>>
>> To be fair Salil's was dropped more or less for security reasons..
>>
>> I think debugfs to dump truely internal state that is not intended to
>> be API stable is reasonable.
> 
> Yes, it can be ripped in any point of life, despite the screaming.

We also can't count on debugfs always being available. To me that's the 
main problem with it.

>> Promise you will not be tooling on top of this, or use it as an
>> interface in your manager or something crazy like that. You must be
>> happy in all cases if your distro chooses to disable debugfs.
> 
> Honestly, I don't know if we can trust to Intel's promises.
 >
> 
> Among other promises, they wrote that OmniPath Ethernet Management part
> will be open sourced too. It seems like it wasn't at the end.
> My google searches with words "ethernet manager omni-path" revealed nothing.

I don't think we are "at the end" yet. The EM is a work in progress and 
*will* be open sourced. I don't work on that bit of code so I can't tell 
you when exactly.

All of this vnic stuff is a work in progress and we are incrementally 
pushing things out. Iterative development, involving the community and all.

>> The problem I have with reviewing all the vnic patches is that I don't
>> have a spec for vnic or anything, and I don't really know what the
>> data being dumped is..
> 
> My problem with those patches that they don't show whole picture and the
> more important you have no way to see it, if you want it.
> Right now, it is legal code-sharing and not truly open-source which I would like to see.
> 
>> eg I would have been much happier if ipoib
>> dump'd its debugfs stuff through netlink connected to neighbor objects
>> - I don't know if this is something similar...

Sounds like a good idea to me.

>> As Leon says, you should really think carefully if this needs to be
>> something that admins are going to be told to look at when vnic isn't
>> working properly, as the ipoib debufs is. In that case netlink is a
>> stable API and more suitable.

Suffice to say, I think we agree on that. Leon and I have talked 
recently and I made it clear my intention is to lessen our reliance on 
debugfs and rely more on netlink by way of rdma tool.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
