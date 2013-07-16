From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Tue, 16 Jul 2013 08:47:47 -0600
Message-ID: <20130716144747.GA7304@obsidianresearch.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
 <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
 <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com>
 <20130708172621.GA3852@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805AAB74-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 16, 2013 at 08:04:08AM +0000, Hefty, Sean wrote:
> > > Jeff's patch doesn't break old binaries, old binaries, running with
> > > normal IB MTUs work fine. The structure layouts all stay the same,
> > > etc.
> > 
> > 
> > FWIW, I did a simple test to confirm this.  I installed a stock git HEAD
> > libibverbs into $HOME/libibverbs-HEAD and a libibverbs with the MTU patch in
> > $HOME/libibverbs-mtu-patch.  The mlx4 driver was installed into both trees (I
> > used some fairly old Mellanox HCAs+Dell servers for this test).
> 
> This creates a bit of pain for anyone (like, hypothetically, say,
> for example, me) who wants to release source that supports both the
> older and newer version of libibverbs.

But it is so minor. An autoconf test for the ibv_mtu_to_num function
in the headers. If it is not defined then define your own in your
private headers. All the other source remains the same, the only
change is you must call the conversion functions.

A source change is completely unvaoidable. Supporting the new MTU
values requires updated source.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
