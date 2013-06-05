From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx4 v6 1/2] libmlx4: Infra-structure changes to
 support verbs extensions
Date: Wed, 5 Jun 2013 10:55:04 -0600
Message-ID: <20130605165504.GB30184@obsidianresearch.com>
References: <1364332591-22866-1-git-send-email-sean.hefty@intel.com>
 <51AE4288.4010505@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A823736FD2CF18@ORSMSX109.amr.corp.intel.com>
 <51AE47A3.5060802@opengridcomputing.com>
 <51AF5129.7020205@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51AF5129.7020205-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 05, 2013 at 09:54:33AM -0500, Steve Wise wrote:
> >Ah.  I was thinking it would use the old interface if it was
> >compiled against a libibverbs that didn't support the extensions.

> So old provider libs will work with the new libibverbs but new
> provider libs will not work with the old libibverbs?   Is there no
> way around this?  That dependency can be painful.

providers can use dlopen/dlsym tricks, or perhaps weak symbols to
discover the new libibverbs symbols. Nobody has had an interest in
working on that problem though.

My original thought when putting all this together was that the one
time synchronized update to the extendable interface was manageable.

.. but seeing now that the providers are linking to other new symbols
beyond the init (eg the cmd family) it seems this will be beyond just
a one time thing. :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
