From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 1 Jun 2015 08:58:43 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506010852360.26845@east.gentwo.org>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com> <1433098827.114391.179.camel@redhat.com> <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com> <1433157904.114391.188.camel@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433157904.114391.188.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 1 Jun 2015, Doug Ledford wrote:

> What's the point?  If it's raw, it's raw.  It's not coordinated between
> adapters.  Whether it's in ns or ps or flipflops doesn't matter, it's a
> flat number that has no reference to anything else, so the only thing
> that matters is < another version of itself or not.

It can be coordinated between different adapter through the use of time
software that can work with cycles and frequencies to scale the value of
the cycles to realtime. Software like that is available in ptpd,
timekeeper etc. Each NIC basically has its own clock and the timekeeping
software would have to track the scaling and the aberration factor over
time in order to come up with accurate absolute time values derived from
the cycle counters of these NICs. Since we are dealing here with values
that need to be accurate to within less than 100ns this is not trivial and
one can easily get a ns value that is absolutely useless.

Since it is not trivial its better kept out of the timestamp support in
the RDMA API. If the app developer wants a trivial conversion then they
can opencode a simple multiplication by the frequency. At that point it
should be clear though that this raw time value is of limited use given
its inaccuracy  and the dependence on the NIC clock.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
