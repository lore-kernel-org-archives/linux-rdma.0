From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the ib_mad_hdr
Date: Thu, 14 May 2015 13:35:58 -0400
Message-ID: <20150514173557.GB10941@phlsvsds.ph.intel.com>
References: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 14, 2015 at 10:28:45AM +0300, Or Gerlitz wrote:
> On Thu, May 14, 2015 at 2:20 AM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > ib_find_send_mad only needs access to the MAD header.  Change the MAD cast.
> >
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> shorter and clearer subject line please, e.g

Sorry, I'll try to keep them brief.

> 
> IB/mad: Clean up ib_find_send_mad to use only the MAD header
> 
> Also, please try to send patches in series and not as both singles and
> series with multiple series flowing in the same time and touching the
> same module. It's hard for both reviewers and maintainers to follow.

I don't understand this statement.

This stands on its own based on Dougs "doug/to-be-rebased/for-4.2"
branch.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
