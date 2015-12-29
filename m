From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 29 Dec 2015 19:38:30 +0200
Message-ID: <CAG9sBKMoXneqQJvMWKXkTXx-D2WrLuabW=5hCH_5V=TePe4WYQ@mail.gmail.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
	<20151222181905.GA742@phlsvsds.ph.intel.com>
	<CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com>
	<20151223200727.GA6886@phlsvsds.ph.intel.com>
	<CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com>
	<20151224161415.GA674@phlsvsds.ph.intel.com>
	<CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com>
	<5682B6B4.60306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5682B6B4.60306-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think that my point is missed. See my answers inline


> This is incorrect.  This isn't some public API that we are exporting to
> user space.  Nor is it an API that out of tree drivers are using.  This
> is a purely kernel internal API for use by a limited number of drivers.
>  As such, it need not be finalized before it is submitted or used.  It
> can be taken one piece at a time, and if, at some point, it is
> determined that there are shortcomings to the API, it can be updated in
> place with all of the drivers that use it in a single patch or patch
> series.  So a finalized design prior to putting code in place is
> specifically *not* needed.
>
This is not a question of future backward comparability where
interfaces must be kept forever. I agree that kernel interfaces may be
changed with kernel moving forward. However, this is not what I'm
arguing against.

When one submits a RFC for a generic Infrastructure he must state what
are the interfaces between blocks of the design.
Soft RoCE block can't start until I know how the final interfaces look
like. This is an unacceptable method of work.

>
> They released it so that you can start hooking SoftRoCE into it.  As you
> hook it in, if it needs changes to work with SoftRoCE, simply make the
> changes needed and move on.

This is not a question if I can hook Soft RoCE driver into this framework.
In fact, I can't think of an IB driver that can't use this framework. What this
framework offers is just another hop from ib_core the real driver.
Where is the removal of duplicated code? This is a list of functions
that for now
must be implemented in the low level driver.

create_cq
destroy_cq
poll_cq
req_notify_cq
resize_cq
create_srq
modify_srq
destroy_srq
query_srq
create_qp
query_device
query_gid
alloc_ucontext
modify_device
modify_qp
dealloc_ucontext
query_port
destroy_qp
get_port_immutable
modify_port
query_qp
post_send
post_recv
post_srq_recv

Most if not all of them have common part in all drivers.
What are the plans to get rid of them? When?
Don't you think that this should be known in advance?

I already asked and never been answered seriously: what was
the purpose of the submission in this premature state of the code
It can't be for feedback because what kind of feedback can you provide
for just a skeleton? Moreover, today they submitted V2 with a changelog
that is almost 100% cosmetic changes. I really don't understand this kind
of work.




>
> I think Dennis' point, and I agree with him, is that you are over
> complicating the issue here.  This need not be a highly designed item,
> it needs to be a functional item, and we can build it as we go.  If you
> have to make changes to rdmavt in order to hook up SoftRoCE, that's
> fine, post them to the list, they will get reviewed.  As long as the
> change doesn't break or otherwise negatively impact qib and/or hfi1,
> then it should be fine.  If it does, then I'm sure Intel will work with
> you to find a solution that doesn't negatively impact them.

A reminder of what the initial goal was - remove code duplicates between
all IB transport drivers. This goal is complicated and in my RFC I explained
why. So, for start, I am not complicating anything that was simple before.

Second, what you are saying here is actually: "this is a project to serves
Intel's needs". So why treat it as a generic infrastructure? I'm not aiming to
hurt performance but Intel should aim for achieving the goals we agreed on
in the begging.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
