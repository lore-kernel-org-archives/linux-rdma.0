From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Thu, 2 Nov 2017 10:12:22 -0600
Message-ID: <20171102161222.GH18874@ziepe.ca>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
 <20171101165625.GE1030@ziepe.ca>
 <20171102050942.GU16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102050942.GU16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 07:09:42AM +0200, Leon Romanovsky wrote:
> On Wed, Nov 01, 2017 at 10:56:25AM -0600, Jason Gunthorpe wrote:
> > On Wed, Nov 01, 2017 at 11:11:42AM +0000, Alex Margolin wrote:
> >
> > >  struct verbs_context {
> > >  	/*  "grows up" - new fields go here */
> > > +	struct ib_mw * (*alloc_mw_ex)(struct ibv_mw_alloc_attr
> > >  	*mw_alloc_attr);
> >
> > This patch is full of weird little mistakes like the above, wouldn't
> > compile and doesn't really seem capture the proposed API.
> 
> Those RFCs are intended to present concept and implementation direction.
> It is a little bit over-expectation to have working code and clean UAPI
> at this stage.

Clear communication is important.

If you have to send a code snippit to explain the idea then it had
better 'work'. I'm not asking for an implementation, but certainly
correct changes to verbs.h

> > We are now asking for complete rdma-core patches before talking about
> > merging new kernel uapi features. Please retry this RFC with the new
> > requirement.
> 
> There are steps in development process, and first step before rushing
> into implementation details is to talk about concept. This is exactly
> what Alex did.

Mellanox already did the concept step internally, if you want external
review you need to clearly communicate the idea, and I don't think
these RFCs are detailed or clear enough.

Header file patch, man pages, documentation and an example are the
logical next steps to vet a proposed verbs API in the public forum.

This is analogous to a standards body context, where the next step
would be to draft standards language, eg 'man pages' and API signatures.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
