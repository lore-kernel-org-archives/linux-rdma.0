From: Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Writing RDMA applications on Linux
Date: Wed, 29 Aug 2012 10:27:44 +0200
Message-ID: <CAJycT5qy8zdPF0f0AjafrH+657-GAPjx8vLvUdNJuPr=KTRsgg@mail.gmail.com>
References: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8ACB1@ORSMSX101.amr.corp.intel.com>
	<CAJycT5rDA0E3q7uobZnQsDUQVpEn__UnuA61KkVrAyPFS+o9fg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B686@ORSMSX101.amr.corp.intel.com>
	<CAJycT5oNX5x32xnFg3eWqVyJEdFOT0R=psKB7PM+0Y7gZ-f+rg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B861@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8B861-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 29, 2012 at 12:51 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I'm not sure if I have to say sorry for the noise or not but it seems
>> that the issue was just an NUMA issue!
>
> that's good news
>
>> May be rsocket has to do a memory affinity on the node with the IB
>> board attached on
>> before to allocate his own memory?
>
> Do you know what code is necessary for doing this?

It's something I have never done before, apart doing a cpu affinity of
the current process/thread
to a particular core, it should not be hard to see what numactl does.
However before doing
this, that for me has the taste of an hack we should find out why
ib_write_bw is not affected by
cpu/memory affinity.

Gaetano

-- 
cpp-today.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
