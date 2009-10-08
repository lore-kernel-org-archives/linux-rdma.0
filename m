From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofw] [PATCH] opensm - add OSM_CDECL to qsort compare function
	definitions
Date: Thu, 8 Oct 2009 11:59:57 -0600
Message-ID: <20091008175957.GZ5191@obsidianresearch.com>
References: <6678A2C4663F40F3AC7B364C6ACFCC9F@amr.corp.intel.com> <7E11A1A23B5A46DB8BB84556E67BF487@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E11A1A23B5A46DB8BB84556E67BF487-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 08, 2009 at 10:10:34AM -0700, Sean Hefty wrote:
> >X86 linkage requires __cdecl attribute on qsort() compare function definition;
> >matches Windows qsort() prototype.
> >Add existing OSM_CDECL to qsort() compare function defintions.
> >OSM_CDECL defined blank for Linux.
> 
> ibping also requires the use __cdecl.  So far, I've been maintaining
> that patch separately and applying it before updating the winof code
> base.  If multiple users of __cdecl are required, maybe we can find
> a common place for the definition.

I don't get it - how can an ISO C conforming compiler require a
non-standard declaration on the function argument to the ISO C
function qsort?

Has the default calling convention been changed for some reason?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
