From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 4/5] mlx5: Add support for ibv_parent
 domain and its related verbs
Date: Tue, 14 Nov 2017 12:15:08 -0700
Message-ID: <20171114191508.GH4263@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-5-git-send-email-yishaih@mellanox.com>
 <20171113200320.GE22610@ziepe.ca>
 <4232d248-8fb3-1d64-e117-6034d9240a05@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4232d248-8fb3-1d64-e117-6034d9240a05-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 12:29:14PM +0200, Yishai Hadas wrote:

> It's not enough, there might be cases that protection_domain is NULL but
> still the object is a parent domain as of in the CQ case where td may be
> applicable but not the protection_domain. Better having here clear
> indication which is set upon the creation API rather than some semantic.

Ugh, the idea of a ibv_pd without a ibv_pd is a ugly. That is a whole
bunch more checking and failure scenarios.

I think I'd rather have the CQ receive a PD it doesn't need than do
that..

> >>+struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
> >>+			struct ibv_parent_domain_init_attr *attr)

> >>+	pd->protection_domain= attr->pd;
> >
> >Don't we need some kind of ref counting here?
> >
> 
> We thought about it as well, however reference counting can't prevent race
> conditions when more than one thread uses the API.

Not really concerned about races. More concerned about helping the
user use it properly..

> Similar behavior exists also in current code which puts the responsibility
> on the application to correctly use the API instead of using some reference
> counting /locks inside the libraries.

We have refcounts in the kernel side for many things and generate
errors if the user does stuff in the wrong order.

> >What is the intention for the final version of this patch?
> 
> The next patch of this RFC around QP creation introduces the
> expected usage.

Well, this transformation would have to ultimately be done in this
patch or before.

Looking more, this isn't good enough, at the very least I think you
need to memcpy the struct ibv_pd portion so context and handle are
set, as those are public ABIs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
