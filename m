From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 12 Jun 2013 15:17:42 -0600
Message-ID: <20130612211742.GA8625@obsidianresearch.com>
References: <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com>
 <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <D554B471892C914E90E136467281724DAD695B50@MTLDAG01.mtl.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6808D7@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6808D7-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2013 at 09:10:57PM +0000, Jeff Squyres (jsquyres) wrote:

> > Another way to look at it is "specify IO access permissions" for
> > address space ranges.  This could be useful to implement a buffer
> > pool to be used for a specific MR only, yet still map/unmap memory
> > within this pool on the fly to optimize physical memory
> > utilization.  In this case, you would provide smaller ranges than
> > 2^64...

> Hmm; I'm not sure I understand.
> 
> Userspace doesn't control what virtual addresses it gets back from
> mmap/etc.  

Yes, it can, via MAP_FIXED. There are lots of fun tricks you can play
using that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
