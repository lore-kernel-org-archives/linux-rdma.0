From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Mon, 23 Oct 2017 20:24:09 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663875E111E@FMSMSX108.amr.corp.intel.com>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E0841@FMSMSX108.amr.corp.intel.com>
 <20171023081117.GE2106@mtr-leonro.local>
 <f03e51d6-4157-64b4-ec5d-9beac00ceb87@redhat.com>
 <20171023171211.GM2106@mtr-leonro.local>
 <1508780384.3325.13.camel@redhat.com>
 <20171023180336.GQ2106@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E0FE2@FMSMSX108.amr.corp.intel.com>
 <20171023182504.GB16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023182504.GB16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Monday, October 23, 2017 2:25 PM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Torvalds, Linus <torvalds@linux-
> foundation.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> misinterpreted flag
> >
> > I did repeat this once without the misconfiguration.
> >
> > The scenario was that I had that a local (ibacm client 0) did a look up, got an
> error, and the system crashed.
> >
> > I have been trying to remember what I did, but haven't repeated it a second
> time.  I will see if I can figure out how to make it happen again.
> 
> Actually, you need to cause an error from ibacm side.
> 
> Just send a fix with stable tag.
> 
> Thanks for doing that.

The patch is working its way through our internal process.  Once that is done, I will post it.

Thanks,

Mike

> 
> >
> > M
> >
> >
> >
> > > >
> > > > --
> > > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > >     GPG KeyID: B826A3330E572FDD
> > > >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> 2FDD
> > > >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
