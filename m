From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4 pci device table
Date: Mon, 28 Jun 2010 14:26:33 -0600
Message-ID: <20100628202633.GF4630@obsidianresearch.com>
References: <Pine.LNX.4.64.1006221025130.11239@zuben.voltaire.com> <adafx0ds5jj.fsf@roland-alpha.cisco.com> <4C289F87.8050803@voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439BA237127@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA237127-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 28, 2010 at 10:55:50PM +0300, Tziporet Koren wrote:
> On 6/28/2010 4:11 PM, Or Gerlitz wrote:
> 
> > Roland Dreier wrote:
> >> I think the current upstream location is correct.  This matches the practice of eg iw_cxgb3 as well as cxgb3i, bnx2i >> etc.  This does have the disadvantage that mlx4_en and mlx4_ib are not auto-loaded by PCI hotplug, but so it goes.
> 
> > okay. Still, its too bad that ofed ships patches that do things the 
> > other way around vs upstream. Yevgeny, if you have reasoning in place to 
> > do things the other way, why not submit upstream?

> This patch was submitted to upstream but was not accepted.  however
> without it PXE boot cannot work since only mlx4_core is loaded and
> not the Eth driver

Sigh.. Please realize that creating something which is an aggregation
of stuff that upstream has refused is an extremely bad idea?

> Any other suggestion how to solve it will be accepted.

Yes, you build the initrd properly! All distro initrd scripts have an
option to include named modules, specifically for cases like this. If
you are PXE booting over IB then you need to use those options to
include the mlx driver, ipoib driver, etc, etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
