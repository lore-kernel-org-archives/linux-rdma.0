From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential I/O
	coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Wed, 6 Jan 2010 17:16:31 -0700
Message-ID: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In shifting through a great deal of benchmark data collected from two
identical machines (including the attached drive array), I see the
following SRP anomalies:

1) I'm seeing small block random writes (32KB and smaller) get better
performance over SRP than they do as a local drive.  I'm guessing this
is async behavior: once the written data is on the wire, it's deemed
complete, and setting a sync flag would disable this.  Is this
correct?  If not, any ideas why SRP random writes would be faster than
the same writes locally?

2) I'm seeing very poor sequential vs. random I/O performance (both
read and write) at small block sizes (random performs well, sequential
performance is poor).  I'm using direct I/O and the noop scheduler on
the initiator, so there should be no coalescing.  Coalescing on these
drives is not a good thing to do, as they are ultra low latency, and
much faster if the OS doesn't try to coalesce.  Could anything in the
IB/SRP/SCST stack be trying to coalesce sequential data?  If not, any
other ideas on why I might see this?

3) In my iSCSI (tgt) results using the HCA as a 10G interface (not
IPoIB, but mlnx4_en), comparing this to the results of using the same
HCA as IB under SRP, I get much better results with SRP when
benchmarking the raw device, as you'd expect.  This is w/ a drive that
does under 1GB/s.  When I use MD to mirror that SRP or iSCSI device w/
an identical local device, and benchmark the raw MD device, iSCSI gets
superior write performance and about equal read performance.  Does
iSCSI/TGT have some special hook into MD devices that IB/SRP isn't
privy to?

Any ideas or clues would be helpful.

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
