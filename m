From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 12:29:31 -0600
Message-ID: <20150527182931.GA16246@obsidianresearch.com>
References: <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
 <20150526181336.GD11800@obsidianresearch.com>
 <1432672378.28905.178.camel@redhat.com>
 <20150526211114.GB4502@obsidianresearch.com>
 <1432736046.28905.215.camel@redhat.com>
 <20150527171143.GB9909@obsidianresearch.com>
 <1432749191.28905.243.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432749191.28905.243.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 01:53:11PM -0400, Doug Ledford wrote:

> > This basic idea is exactly why I think we should stick with the 20
> > byte LLADDR for ILFA_VF_MAC. It gives a route for the PF to tell the
> > VF what QPN to use for IPoIB (if we ever see HW support to implement that)
> > 
> > If we use 8 bytes then that route is closed off forever.
> 
> And that's exactly as it should be.  If we allow setting all 20 bytes
> via the VF_MAC calls, then we violate the "guests should behave like
> they are on bare metal as much as possible" rule.  As a host, we get a
> GUID and if we want to control the QPNs for IPoIB (and indeed if we
> want

No, that doesn't really work. The PF's QPN pool is shared between all
VF guests. The VF HCA does a call to the PF driver to get a free QPN
to use. The VM cannot unilaterally select a QPN without global
coordination.

In other words, if a QPN is to be forced for IPoIB then it must come
from the PF, which must get it from the orchestration software, which
must globally coordinate to ensure the QPN is available on every PF
the VM may want to run on. Similar to how the MAC must be globally
unique.

Will this ever be done? Probably not. But if it was, this interface
would be the sanest way to go.

Anyhow - as far as I'm concerned, fixing the IFLA_VF_MAC to have a
proper length nullifies my concern. If we really needed we can switch
to a 20 byte format with good compatability options in the future once
we have a proper length.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
