From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 29 Dec 2015 12:55:51 -0500
Message-ID: <20151229175550.GA14328@phlsvsds.ph.intel.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com> <20151222181905.GA742@phlsvsds.ph.intel.com> <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com> <20151223200727.GA6886@phlsvsds.ph.intel.com> <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com> <20151224161415.GA674@phlsvsds.ph.intel.com> <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com> <5682B6B4.60306@redhat.com> <CAG9sBKMoXneqQJvMWKXkTXx-D2WrLuabW=5hCH_5V=TePe4WYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKMoXneqQJvMWKXkTXx-D2WrLuabW=5hCH_5V=TePe4WYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 07:38:30PM +0200, Moni Shoua wrote:
>This is not a question if I can hook Soft RoCE driver into this framework.
>In fact, I can't think of an IB driver that can't use this framework. What 
>this
>framework offers is just another hop from ib_core the real driver.
>Where is the removal of duplicated code? This is a list of functions
>that for now
>must be implemented in the low level driver.
>
>create_cq
>destroy_cq
>poll_cq
>req_notify_cq
>resize_cq
>create_srq
>modify_srq
>destroy_srq
>query_srq
>create_qp
>query_device
>query_gid
>alloc_ucontext
>modify_device
>modify_qp
>dealloc_ucontext
>query_port
>destroy_qp
>get_port_immutable
>modify_port
>query_qp
>post_send
>post_recv
>post_srq_recv
>
>Most if not all of them have common part in all drivers.
>What are the plans to get rid of them? When?
>Don't you think that this should be known in advance?

We have patch sets that implement all of these which will be posted soon.  
With the holidays things have just been a bit slow to come out.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
