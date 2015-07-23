From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Thu, 23 Jul 2015 02:30:46 -0700
Message-ID: <20150723093046.GF32592@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9001357@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9001357-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 12:57:34AM +0000, Hefty, Sean wrote:
> > +enum ib_mr_type {
> > +	IB_MR_TYPE_FAST_REG,
> > +	IB_MR_TYPE_SIGNATURE,
> 
> If we're going to go through the trouble of changing everything, I vote
> for dropping the word 'fast'. It's a marketing term.  It's goofy.  And
> the IB spec is goofy for using it.

Yes.  Especially as the infrastructure will be usable to support FMR
on legacy adapters as well except that instead of the ib_post_send it'll
need a call to the FMR code at the very end.

While we're at it  wonder if we should consolidate the type and the
flags field as well, as the split between the two is a little confusing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
