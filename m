From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Mon, 23 Oct 2017 18:19:11 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663875E0FE2@FMSMSX108.amr.corp.intel.com>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E0841@FMSMSX108.amr.corp.intel.com>
 <20171023081117.GE2106@mtr-leonro.local>
 <f03e51d6-4157-64b4-ec5d-9beac00ceb87@redhat.com>
 <20171023171211.GM2106@mtr-leonro.local>
 <1508780384.3325.13.camel@redhat.com>
 <20171023180336.GQ2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023180336.GQ2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Monday, October 23, 2017 2:04 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Torvalds, Linus <torvalds@linux-
> foundation.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> misinterpreted flag
> 
> On Mon, Oct 23, 2017 at 01:39:44PM -0400, Doug Ledford wrote:
> > On Mon, 2017-10-23 at 20:12 +0300, Leon Romanovsky wrote:
> > > On Mon, Oct 23, 2017 at 10:49:24AM -0400, Doug Ledford wrote:
> > > > On 10/23/2017 4:11 AM, Leon Romanovsky wrote:
> > > Doug,
> > >
> > > It has very little related to security here. The RDMA_NL_LS netlink
> > > operations require CAP_NET_ADMIN capability set and it is checked
> > > before
> > > calling any callback.
> >
> > I disagree.  In this particular case, it wasn't a nefarious user, it
> > was a simple misconfiguration that cause the kernel to oops.  So even
> > if you have CAP_NET_ADMIN, you still don't want a user space issue to
> > oops the kernel.  If you simply don't allow it to happen, then whether
> > the CAP_NET_ADMIN program has been compromised by a black hat user is
> > irrelevant.  That seems the right way to be to me.
> 
> OK, fix exists and if you want to call it "security issue", let's call it so.
> 
> Despite the fact that root misconfigured the system, root run the program,
> root crashed the system, like all over kernel oops we are seeing in linux kernel.
> 
> Thanks

I did repeat this once without the misconfiguration.

The scenario was that I had that a local (ibacm client 0) did a look up, got an error, and the system crashed.

I have been trying to remember what I did, but haven't repeated it a second time.  I will see if I can figure out how to make it happen again.

M


 
> >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG KeyID: B826A3330E572FDD
> >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
