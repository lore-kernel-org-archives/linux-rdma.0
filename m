From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Wed, 7 Oct 2009 15:45:59 -0600
Message-ID: <20091007214559.GU5191@obsidianresearch.com>
References: <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com> <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com> <20091006231720.GR5191@obsidianresearch.com> <3F7D26D4BA1C46F18F2F87BDD7EB7F36@amr.corp.intel.com> <20091007052639.GB18578@obsidianresearch.com> <20ADF14BE2B24B459DC3921F69449E61@amr.corp.intel.com> <20091007203257.GT5191@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF12C180FFD1@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF12C180FFD1-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 07, 2009 at 02:20:29PM -0700, Hefty, Sean wrote:
> >You are trying to make the smallest change possible to work around a
> >performance problem caused by ineffecient abstractions by completely
> >breaking the abstraction.
> 
> The performance problem being addressed here is not caused by an
> inefficient abstraction.  It's caused by having a single,
> centralized SM incapable of scaling to the cluster sizes that
> customers want to use.

The SM scaling is a side effect of the IP RDMA CM design. Since the IP
RDMA CM design and abstraction require the ARP and PR queries - it is
the root inefficiency - the SM scaling is the consequence. IB GID CM
does not have this mandatory behavior, you can get your PR data from
wherever you want.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
