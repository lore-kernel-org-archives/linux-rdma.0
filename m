From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Wed, 14 Jun 2017 17:46:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB143731@ORSMSX109.amr.corp.intel.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1436F6@ORSMSX109.amr.corp.intel.com>
 <20170614173940.GA15278@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614173940.GA15278-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > >> +enum uverbs_attr_spec_flags {
> > > >> +     UVERBS_ATTR_SPEC_F_MANDATORY    = 1U << 0,
> > > >> +     /* Support extending attributes by length */
> > > >> +     UVERBS_ATTR_SPEC_F_MIN_SZ       = 1U << 1,
> > > >> +};
> > > >
> > > > Don't use named enums for bit flags.  The result of ORing flags
> ends
> > > up as a non-enum value.
> > > >
> > >
> > > Sure
> 
> Isn't this common place in the kernel now? The enum should be
> anonymous for this usage though.

I wasn't clear.  Using an anonymous enum was what I was getting at.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
