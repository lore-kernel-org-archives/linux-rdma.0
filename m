From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Add SMP/QP0 usage explanation to
 general man page
Date: Thu, 31 May 2012 18:13:30 -0700
Message-ID: <20120531181330.e79a903f.weiny2@llnl.gov>
References: <20120531160249.f23247ea.weiny2@llnl.gov>
	<4FC80044.8010508@dev.mellanox.co.il>
	<20120531165831.7282b711.weiny2@llnl.gov>
	<4FC8157B.7040107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC8157B.7040107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 31 May 2012 21:06:03 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 5/31/2012 7:58 PM, Ira Weiny wrote:
> > On Thu, 31 May 2012 19:35:32 -0400
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >> On 5/31/2012 7:02 PM, Ira Weiny wrote:
> >>>
> >>>
> >>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> >>> ---
> >>>  doc/rst/infiniband-diags.8.in.rst |   12 ++++++++++++
> >>>  1 files changed, 12 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/doc/rst/infiniband-diags.8.in.rst b/doc/rst/infiniband-diags.8.in.rst
> >>> index 6a86ae2..9cd4524 100644
> >>> --- a/doc/rst/infiniband-diags.8.in.rst
> >>> +++ b/doc/rst/infiniband-diags.8.in.rst
> >>> @@ -23,6 +23,18 @@ may therefore work even in unconfigured subnets.  Other, higher level
> >>>  utilities, require LID routed MAD's and to some extent SA/SM access.
> >>>  
> >>>  
> >>> +THE USE OF SMP's (QP0)
> >>> +======================
> >>> +
> >>> +Many of the tools in this package rely on the use of SMP's via QP0 to acquire
> >>
> >> SMPs
> > 
> > done
> > 
> >>
> >>> +data directly from hardware.  
> >>
> >> SMA rather than hardware
> > 
> > done.
> > 
> >>
> >>> While this mode of operation is not technically
> >>> +in compliance with the InfiniBand specification, 
> >>
> >> I think this is a grey area.
> > 
> > I agree. However, I thought with SRIOV support and MKey support it was worth
> mentioning this.
> 
> For SRIOV (guests), the only diags are ibstat and ibstatus right now.
> Should there be a separate guest package with just those and their man
> pages ?

I don't think so.  Some other tools will work saquery, perfquery, etc.  I know that it can be difficult for users to understand where the use of SMPs might hang them up, but at least this may give them a clue.  Going forward it would be nice to have less dependencies on SMPs.  But I think we agree it will always be nice to query the hardware (SMA) directly.

Ira

> 
> -- Hal
> 
> > 
> > Ira
> > 
> >>
> >> -- Hal
> >>
> >>> practical experience has found
> >>> +that this level of diagnostics is valuable when working with a fabric which is
> >>> +broken or only partially configured.  For this reason many of these tools may
> >>> +require the use of an MKey or operation from Virtual Machines may be restricted
> >>> +for security reasons.
> >>> +
> >>> +
> >>>  COMMON OPTIONS
> >>>  ==============
> >>>  
> >>
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
