From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Thu, 2 Nov 2017 10:42:02 -0600
Message-ID: <20171102164202.GL18874@ziepe.ca>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
 <20171101165625.GE1030@ziepe.ca>
 <20171102050942.GU16127@mtr-leonro.local>
 <20171102161222.GH18874@ziepe.ca>
 <20171102163125.GZ16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102163125.GZ16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 06:31:25PM +0200, Leon Romanovsky wrote:
> > Header file patch, man pages, documentation and an example are the
> > logical next steps to vet a proposed verbs API in the public forum.
> 
> And I think that RFC should be much lighter than you wrote. Pseudo API,
> motivation and examples.

The general rule in the kernel community is that things do not get
reviewed without code, and as I said, this specific RFC is confusing,
to say the least.

So if you want some kind of ack that the idea will not be revised when
the code is presented, you need to at least present some code to get it
reviewed.

In this case, man pages and header files would be a reasonable place
to start.

This is particularly true since none of these new RFCs are not backed
by any sort of spec, and the code submission and RFC itself forms the
spec.

Starting by writing the spec is a sane engineering practice.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
