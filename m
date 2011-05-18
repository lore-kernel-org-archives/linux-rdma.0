From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 12:05:19 -0600
Message-ID: <20110518180519.GA11860@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
 <20110518170226.GA2595@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373FBC7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373FBC7-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2011 at 05:30:30PM +0000, Hefty, Sean wrote:
> > As long as the version number in the ibv_context is increasing and not
> > branching then I think it is OK. 0 = what we have now. 1 = + XRC, 2 =
> > +XRC+ummunotify, etc. Drivers 0 out the function pointers they do not
> > support.
> 
> I was thinking more along this line, but I can see how using a named extension could be useful for OFED or vendor specific extensions that aren't part of the upstream libibverbs.  (Whether _that_ is useful is another matter, but it seems to be the world that we're in anyway.)
> 
> I'm not familiar with OpenGL, so I'll take a look at it.  (The concept sounds similar to Window's COM interfaces.)
> 
> Beyond the interfaces, are there any thoughts on how to handle structure changes, such as:
> 
> 	struct ibv_xrc_send_wr {
> 		struct ibv_send_wr wr;
> 		uint32_t remote_qpn;
> 	};
> 
> ?  Do we want to use the existing ibv_post_send() call, or add a new
> ibv_post_xrc_send() routine specifically for this purpose (and
> simplify the above definition)?

I prefer to see type safety, so ibv_post_xrc_send is my vote.

Just looking at this, I think it can be stuffed into the existing wr..

        union {
                struct {
                        uint64_t        remote_addr;
                        uint32_t        rkey;
                } rdma;
                struct {
                        uint64_t        remote_addr;
                        uint64_t        compare_add;
                        uint64_t        swap;
                        uint32_t        rkey;
                } atomic;
                struct {
                        struct ibv_ah  *ah;
                        uint32_t        remote_qpn;
                        uint32_t        remote_qkey;
                } ud;
        } wr;

(ignoring 32 bit for now) This union must start 64 bit aligned.

The size is 3*64 + 1*32 so there is a 32 bit pad, thus we can rewrite
it as:

        union {
                struct {
                        uint64_t        remote_addr;
                        uint32_t        rkey;
			uint32_t        xrc_remote_qpn;
                } rdma;
                struct {
                        uint64_t        remote_addr;
                        uint64_t        compare_add;
                        uint64_t        swap;
                        uint32_t        rkey;
			uint32_t        xrc_remote_qpn;
                } atomic;
                struct {
                        struct ibv_ah  *ah;
                        uint32_t        remote_qpn;
                        uint32_t        remote_qkey;
                } ud;
        } wr;

Without changing the size at all.

32 bit users will grow, but that is still ABI acceptable because the
pass into ibverbs uses a linked list structure that clearly identifies
the start of each wr. So long as the extended stuff is not touched
if the WR is not related to XRC things will be OK.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
