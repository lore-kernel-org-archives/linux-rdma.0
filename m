From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Sat, 9 Jan 2010 20:25:08 +0100
Message-ID: <e2e108261001091125q73a59936t1e5eb5103da58de@mail.gmail.com>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 7, 2010 at 1:16 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 3) In my iSCSI (tgt) results using the HCA as a 10G interface (not
> IPoIB, but mlnx4_en), comparing this to the results of using the same
> HCA as IB under SRP, I get much better results with SRP when
> benchmarking the raw device, as you'd expect. =A0This is w/ a drive t=
hat
> does under 1GB/s. =A0When I use MD to mirror that SRP or iSCSI device=
 w/
> an identical local device, and benchmark the raw MD device, iSCSI get=
s
> superior write performance and about equal read performance. =A0Does
> iSCSI/TGT have some special hook into MD devices that IB/SRP isn't
> privy to?

Regarding the write test: were the targets configured for write back
or for write through ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
