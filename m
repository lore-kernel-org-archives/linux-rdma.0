From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 10:11:45 -0700
Message-ID: <20170207171145.GB1077@obsidianresearch.com>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 07, 2017 at 09:07:28AM -0600, Steve Wise wrote:

> I think we have an issue with the new rdma-core packaging and OFED-4.8.  I think
> OFED-4.8 installs provider libraries in a different location than previous
> releases of the provider libs.

On Redhat, yes. OFED could build using the

-DVERBS_PROVIDER_DIR=''

To disable this new location if absolutely necessary.

> The result of this, I think, is that OFED-4.8 installed over a
> destro with its own provider libs installed will result in two
> versions of the libs installed,

Yes...

> and further, the system might end up using the distro provider libs
> with newer OFED drivers, which could be problematic.

Hm, possibly yes. ibverbs first checks the new location, if the
provider is not there then it will fall back to a naked dlopen which
could find providers in the system library path if there was a .driver
file for it.

However, starting in rdma-core 13 the distro providers will not be
link compatible with new libibverbs and will silently fail to load.

> What do folks think about this?  Should OFED-4.8 try and uninstall rdma
> cmds/libs regardless of where they came from?  Perhaps optionally.  Or should
> this just be documented so the admin is required to deal with it?  I think if we
> leave OFED as-is, we'll end up with lots of support issues where old libs are
> being loaded causing problems.

I'm not sure it is likely someone will hit this. The user would need a
distro packaged provider that is not included in rdma-core. AFAIK no
such thing exists...

Do you know of another way to trigger wrong loading?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
