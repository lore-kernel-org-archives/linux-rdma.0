From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Fri, 29 May 2015 14:21:46 -0500
Message-ID: <5568BC4A.3070502@opengridcomputing.com>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com> <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org> <20150528204749.GA12780@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FE1F36@ORSMSX109.amr.corp.intel.com> <alpine.DEB.2.11.1505290846480.8178@east.gentwo.org> <1828884A29C6694DAF28B7E6B8A82373A8FE2069@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE2069-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/29/2015 11:52 AM, Hefty, Sean wrote:
>> What is the issue here? The timestamp is created when the processing is
>> finished by the nic and the completion entry becomes available.
> The timestamp is generated when a work completion entry is written.  If there's a clear use case for this, it hasn't been described.  The use case you mentioned only works if there is a 1:1 relationship between a packet and a work completion.  That is not what is being defined here.
>
>> It is exactly defined like any other cycle counters in hardware and it is
>> exposed using an API that allows multiple vendors to use these cycle
>> counters without regard to a particular vendors implementation.
> I disagree.  This is associated with a specific implementation.  It assumes that the counter is part of a CQ entry, and that the counter is written when the completion is written.  There's nothing that requires other vendors to follow that model, nor is it clear that this is a generic or useful enough operation that other vendors would want to follow this model.  Why not have the time stamp record the start of the transaction?  The end?  Have two stamps, once for the first packet, and one for the last?  Limit this to single packet operations only?

FWIW: cxgb4 hardware includes a hw timestamp in its CQE as well. It is 
used by SW for CQ overflow detection and debug timing analysis...

>>> The use case given by Christoph only speaks of packet level time stamps.
>> O=
>>> ne could argue that such a use case would place the stamp near the
>> packet (=
>>> similar to the GRH), rather than embedded into a work completion.  This
>> wou=
>>> ld allow time stamps even in the absence of a work completion.
>>>
>>> IMO, vendors already have ways to expose vendor specific features to
>> user s=
>>> pace.  I would mark this as vendor specific and keep it out of the core.
>> How exactly would that work? How can we attach vendor specific extension
>> to a completion structure?
> I'm just stating that there is at other ways of exposing this sort of feature.  A time stamp could just as easily be written with the data, similar to the grh.  One of the points of defining the verbs extensions was exactly so that a vendor could export their own functionality.
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
