From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced
	error reporting fails
Date: Mon, 25 Oct 2010 14:41:26 -0600
Message-ID: <20101025204126.GF15514@obsidianresearch.com>
References: <20101022222937.28161.50341.stgit@chromite.mv.qlogic.com> <20101022222951.28161.23347.stgit@chromite.mv.qlogic.com> <20101022225710.GD15514@obsidianresearch.com> <adabp6ksk83.fsf@cisco.com> <1288038933.27343.392.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1288038933.27343.392.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 01:35:33PM -0700, Ralph Campbell wrote:
> On Sat, 2010-10-23 at 13:54 -0700, Roland Dreier wrote:
> > I'm lost on which initialization / cleanup fixes are the right ones to
> > take for qib.  Can someone point me to the definitive set of patches?
> 
> If Jason agrees, they are the attached.
> There are probably more error paths that need fixing
> but I think separate patches make sense for those.

Yes, there are more error paths that leak things, but this fixes up
some obvious ones and makes the driver work (and not leak) on older
PCI-E systems.

Please include the 3 patches from Ralph in this round.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
