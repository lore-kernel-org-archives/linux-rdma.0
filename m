From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 10 Jun 2015 16:04:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE6746@ORSMSX109.amr.corp.intel.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
 <20150604164759.GC27699@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F98@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506060318570.29860@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506092018190.6681@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506092018190.6681-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There are multiple problems with libfrabric related to the use cases in my
> area. Most of all the lack of multicast support. Then there is the build
> up of software bloat on top. The interest here is in low latency
> operations. Redenzvous and other new features are really not wanted if
> they increase the latency.

Multicast is only supported by one vendor that has taken a hostile position against libfabric.  Support for multicast will eventually be there, but it's definitely not a priority for me.  As an open source project, anyone is welcome to propose patches.

For native providers, libfabric will reduce latency.  That's a provider implementation issue, and native providers will be available soon.  The OFIWG selected to have a working set of interfaces that applications can begin using immediately, versus waiting until there were a large set of native providers.

This is an entirely unrelated topic for this thread.  Jason asked what I would do with libfabric.  I answered.  Your comments do nothing to change my mind on that answer.

> This is a way it was implemented

IMO, this is exactly the problem.  The entire design is being driving by the implementation.  That produces an unmaintainable API and fractures the software ecosystem, which is exactly where we are today.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
