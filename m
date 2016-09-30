From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Thu, 29 Sep 2016 18:08:00 -0600
Message-ID: <20160930000800.GA7570@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
 <20160929222802.GC27229@obsidianresearch.com>
 <F2C34CC4-5C7D-4382-873D-9E14B81A44B3@ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F2C34CC4-5C7D-4382-873D-9E14B81A44B3-/Yg/VP3ZvrM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 06:46:02PM -0500, Steve Wise wrote:
> > I added the comment because cxgb* was the only provider that seemed to
> > be obviously byte swapping MMIO.
> > 
> > Since htole32 is a NOP on x86 and ARM64 the driver would work fine
> > with or without it. Do you know this driver works on big endian
> > powerpc? That would help answer the question for sure.
> 
> Yes, PowerPC and arm. 

Okay great. Maybe Yishai can explain what mlx drivers are doing..

Is this better:

/* NOTE: The endianess of PCI MMIO accesses is architecture specific,
   this is known correct for BE PPC and LE x86/ARM */

Thanks again Steve,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
