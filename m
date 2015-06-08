From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 8 Jun 2015 16:40:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8@ORSMSX109.amr.corp.intel.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506060318570.29860-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > If I were adding timestamps, I would probably define a new completion
> > structure with 2 u64 time stamp fields (start and end times), and figure
> > out when start occurred, end occurred, and the timing metric later.  :)
> 
> Not sure why you would need the start. The app knows when it submitted a
> send request and incoming packets can be readily timed with taps if
> necessary. If you want the start on inbound packets then you have the
> challenge that the adapter needs to figure out when the first bit of the
> message actually arrived and the timestamp information needs to be pushed
> through all the way through the pipeline. Completion is easily done.

You're assuming that the only start time of interest is when a send operation has been posted.  Jason asked what I would do with libfabric.  That interface supports triggered operations.  It has also been designed such that a rendezvous (that has to be one of the most difficult words in the English language to spell correctly, even with spell check) protocol could be implemented by the provider.  On the receive side, it may be of interest to report the start and ending time for larger transfers, primarily for debugging purposes.

I have no idea how the time stamps are expected to be used, so why limit it?  An app could just as easily create their own time stamp when reading a work completion, especially when the data is going into an anonymous receive buffer.  That would seem to work for your use case.

> > I would assume that these are non-wrapping values.
> 
> Its fine what we have now as far as I can tell.
> 
> I am not sure why it is necessary to make this more complicated than it is
> now. We need a simple means to obtain the completion time and that is what
> the current implementation provides. There is even another vendor
> (chelsio) who has a similar implementation.

And I thought Chelsio they mentioned that they have 2 time stamps.

I have no problem with a bare metal interface exposing this.  But pretending that it's generic and that this is the one and only way that this could be implemented doesn't make it so.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
