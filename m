From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 9 Jun 2015 20:26:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506092018190.6681@east.gentwo.org>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com> <1433098827.114391.179.camel@redhat.com> <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com> <1433157904.114391.188.camel@redhat.com> <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com> <20150602180844.GD17776@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com> <20150604164759.GC27699@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FE4F98@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506060318570.29860@east.gentwo.org> <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8@ORSMSX109.amr.corp.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 8 Jun 2015, Hefty, Sean wrote:

> You're assuming that the only start time of interest is when a send operati=
> on has been posted.  Jason asked what I would do with libfabric.  That inte=
> rface supports triggered operations.  It has also been designed such that a=
>  rendezvous (that has to be one of the most difficult words in the English =
> language to spell correctly, even with spell check) protocol could be imple=
> mented by the provider.  On the receive side, it may be of interest to repo=
> rt the start and ending time for larger transfers, primarily for debugging =
> purposes.

There are multiple problems with libfrabric related to the use cases in my
area. Most of all the lack of multicast support. Then there is the build
up of software bloat on top. The interest here is in low latency
operations. Redenzvous and other new features are really not wanted if
they increase the latency.

> I have no idea how the time stamps are expected to be used, so why limit it=
> ?  An app could just as easily create their own time stamp when reading a w=
> ork completion, especially when the data is going into an anonymous receive=
>  buffer.  That would seem to work for your use case.

No it cannot as described earlier. The work can be completed much earlier
than when the polling thread gets around to check for it. We do that today
since there is nothing better but this means that there is a gap there.
On the send side you have no easy way to telling when the operation was
complete without the timestamp.

> I have no problem with a bare metal interface exposing this.  But pretendin=
> g that it's generic and that this is the one and only way that this could b=
> e implemented doesn't make it so.

This is a way it was implemented and its usable. Shooting for pie in the
sky does not bring us anything. Nor ideas of requirements from a new
experimental API that does not support the basic features that we need
and seems to be on its way to mess up the latencies of access to RDMA
operations.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
