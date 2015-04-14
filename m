From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 27/28] IB/Verbs: Clean up rdma_ib_or_iboe()
Date: Tue, 14 Apr 2015 11:13:03 +0200
Message-ID: <552CDA1F.4050609@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB85D.7010400@profitbricks.com> <20150413203350.GA20611@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413203350.GA20611-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/13/2015 10:33 PM, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2015 at 02:36:45PM +0200, Michael Wang wrote:
>> We have finished introducing the cap_XX(), and raw helper rdma_ib_or_iboe()
>> is no longer necessary, thus clean it up.
> 
> So, the net result is not looking too bad, but I'm confused about the
> structure of this series.
> 
> Why introduce query_transport early on?

This won't be erased until bitmask introduced, at this moment it's the basic
method for helpers to acquire port transport from device.

Sure we can still use the legacy method but IMHO this abstraction will be
more readable for internal reforming, it's like 'mapping from tech to bits'
VS 'mapping from transport and link layer to bits'.

> 
> Why is the patch series going through this progression most lines?
> 
> -       if (rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND) {
> +       if (rdma_tech_ib(device, port_num)) {

This is mostly focus on the reforming on logical.

> +       if (cap_ib_smi(device, port_num)) {

This focus on the description and semantic, won't contain logical reform
, just replace the helper.

I want this way to help us focus on the different main point during the review :-)

> 
> This would be a lot shorter and simpler to look at if the cap's were
> introduced first, then their implementation finalized.
> 
> I thought we agreed Doug's bitmask plan should be the final
> destination for this series, so this progress seems even stranger?
> 
> I would be very happy to see a patch that adds cap_ib_smi to the
> current tree and states 'This patch is tested to have no change on the
> binary compilation results'

There are too much reform there (per-dev to per-port), I guess the binary
will changed more or less anyway...

BTW, I may misunderstanding your point on "Re: [PATCH v2 03/17]":

> I would prefer to see these changes in control flow as dedicated
> patches, at the top of your patch stack.
> For this kind of work a patch should be mechanical changes only, it is
> easier to review that way.
> Same comment applies throughout.

I thought you prefer introducing cap_XX() based on the reforming...

But anyway, please let me know if this really bothered the review :-)

Regards,
Michael Wang

> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
