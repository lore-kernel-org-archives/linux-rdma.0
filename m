From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 11:19:59 -0600
Message-ID: <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com> <20170207171145.GB1077@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207171145.GB1077-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hm, possibly yes. ibverbs first checks the new location, if the
> provider is not there then it will fall back to a naked dlopen which
> could find providers in the system library path if there was a .driver
> file for it.
> 

Hmm, so it will load the provider libraries directly specifying the full path?
IE 'ldconfig -p' doesn't matter?

> However, starting in rdma-core 13 the distro providers will not be
> link compatible with new libibverbs and will silently fail to load.
> 
> > What do folks think about this?  Should OFED-4.8 try and uninstall rdma
> > cmds/libs regardless of where they came from?  Perhaps optionally.  Or
should
> > this just be documented so the admin is required to deal with it?  I think
if we
> > leave OFED as-is, we'll end up with lots of support issues where old libs
are
> > being loaded causing problems.
> 
> I'm not sure it is likely someone will hit this. The user would need a
> distro packaged provider that is not included in rdma-core. AFAIK no
> such thing exists...
>

Vlad already clarified that the OFED installer uninstalls distro rpms, so I
think OFED is good.

> 
> Do you know of another way to trigger wrong loading?
> 

Actually, I was assuming the load path used by libibverbs would be done based on
'ldconfig -p'.  If that is not the case, then everything is ok...I think. 

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
