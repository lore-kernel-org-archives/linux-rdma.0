From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V5 02/10] RDMA/core: Add support for custom types
Date: Wed, 9 Nov 2016 11:50:03 -0700
Message-ID: <20161109185003.GC13467@obsidianresearch.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-3-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A47BD@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BDWyb10baLrDu=m_mYPB64i9OOPEPVYKtDo9zVbvMM-UA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A8000@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A8000-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 09, 2016 at 06:00:48PM +0000, Hefty, Sean wrote:

> In any case, the two approaches are not exclusive.  By forcing the
> rule language into the framework, everything is forced to deal with
> it.  By leaving it out, each ioctl provider can decide if they need
> this or not.  If you want verbs to process all ioctl's using a
> single pre-validation function that operates based on these rules
> you can.  Nothing prevents that.  But ioctl providers that want
> better performance can elect for a more straightforward validation
> model.

The pre-validation is tied into the hash expansion and will hopefully
be the raw data to support a new discoverability scheme. So, making it
optional really wrecks the whole design, I think.

Also, this is really the best way to ensure that we have consistent
checking and error reporting around attributes (eg what happens if the
kernel does not support a requested attribute, or uses the wrong size,
etc) It is very important these things use the correct errnos not the
random mismatch we see today.

I'm not seeing that it is a clear peformance loss (relative to open
coding at least), the major work is the expansion to the hash table
and doing a couple size tests along the way is not hard. Matan's
revised series should be event better on this regard as I gave alot
of feedback to speed it up at plumbers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
