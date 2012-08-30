From: Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Writing RDMA applications on Linux
Date: Thu, 30 Aug 2012 10:59:05 +0200
Message-ID: <CAJycT5pF_ao6WqcOkRLMMm4d4hE-i8J=AuD1C-fmMHWnYxVCYA@mail.gmail.com>
References: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8ACB1@ORSMSX101.amr.corp.intel.com>
	<CAJycT5rDA0E3q7uobZnQsDUQVpEn__UnuA61KkVrAyPFS+o9fg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B686@ORSMSX101.amr.corp.intel.com>
	<CAJycT5oNX5x32xnFg3eWqVyJEdFOT0R=psKB7PM+0Y7gZ-f+rg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B861@ORSMSX101.amr.corp.intel.com>
	<CAJycT5qy8zdPF0f0AjafrH+657-GAPjx8vLvUdNJuPr=KTRsgg@mail.gmail.com>
	<CAJycT5o1+pEUWy_7PME0xw8Sy-sUABD-vsN-uwkjyJGP+3c-kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJycT5o1+pEUWy_7PME0xw8Sy-sUABD-vsN-uwkjyJGP+3c-kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I did try to modify  rsocket.c/rstream.c in order to pass to
ib_post_send addresses
aligned with the page size but I'm not succeeding. Indeed it's not
enough to memalign
the buffers allocated to page_size but as far as I understood each
buffer is sent
in chunks this means that those chunks have to be (but last) all in
size multiple
of page_size as well. I did try increasing RS_OLAP_START_SIZE to
page_size (4096)
but somehow in the cycle in rsocket.c in rsend the buffer passed to
rs_write_data
become unaligned. I have not much time right now to follow what is going on in
there but I'm sure that Sean can fix it in a blink of an eye.

Let me know, I would like to adopt rsocket in my application instead of my own
implementation but until rsocket is not "fixed" I have to stick with
my implementation.

Gaetano

On Wed, Aug 29, 2012 at 6:03 PM, Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I was able to make ib_write_bw to suffer of the same NUMA issue,
> and this is a good news.
> The buffer allocation is aligned to 4K, basically the memory allocation
> is done in this way:
>
> page_size = sysconf(_SC_PAGESIZE); //this is 4K on my system
> buf = memalign(page_size, buffer_size);
>
> with same modification on my code now it doesn't matter on which
> NUMA node I do the affinity (mem/cpu) I'm getting around 1400MB/sec
>
> Gaetano
>
>
> On Wed, Aug 29, 2012 at 10:27 AM, Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Aug 29, 2012 at 12:51 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> I'm not sure if I have to say sorry for the noise or not but it seems
>>>> that the issue was just an NUMA issue!
>>>
>>> that's good news
>>>
>>>> May be rsocket has to do a memory affinity on the node with the IB
>>>> board attached on
>>>> before to allocate his own memory?
>>>
>>> Do you know what code is necessary for doing this?
>>
>> It's something I have never done before, apart doing a cpu affinity of
>> the current process/thread
>> to a particular core, it should not be hard to see what numactl does.
>> However before doing
>> this, that for me has the taste of an hack we should find out why
>> ib_write_bw is not affected by
>> cpu/memory affinity.
>>
>> Gaetano
>>
>> --
>> cpp-today.blogspot.com
>
>
>
> --
> cpp-today.blogspot.com



-- 
cpp-today.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
