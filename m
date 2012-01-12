From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Send with immediate data completion
Date: Wed, 11 Jan 2012 17:51:03 -0700
Message-ID: <20120112005103.GC31021@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373256758E5@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823732567591B@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDVDR_yNmGyCpFKpH39PF5NG90qo7bBDV+DbGmh7FySiZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVDR_yNmGyCpFKpH39PF5NG90qo7bBDV+DbGmh7FySiZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 03:35:58PM -0800, Roland Dreier wrote:
> On Wed, Jan 11, 2012 at 2:22 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > The intent is for immediate data only to be provided on receive
> > work completions. ?The IBTA will clarify the spec on this. ?I'll
> > submit patches that remove setting the wc flag, which may help
> > avoid this confusion some.
> 
> The unfortunate thing is that we never defined enum values like
> 
> IBV_WC_RDMA_WRITE_WITH_IMM
> 
> to go along with
> 
> IBV_WR_RDMA_WRITE_WITH_IMM
> 
> If there was a good reason for that, I've long since forgotten it.

Do you think there is a need to have a WC discern if there was an
attached immediate data? There is no resource attached to the
immediate data that needs special handling.

That is about the only argument I can see for continuing to set
the IBV_WC_WITH_IMM flag on the WC.

All I think is really needed here is a firm note someplace that
imm_data is only valid if IBV_WC_RECV is set, while IBV_WC_WITH_IMM
is set based on the opcode.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
