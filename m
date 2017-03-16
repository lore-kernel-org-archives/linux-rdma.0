From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/6] rdmacm: Use C11 stdatomic for all atomics
Date: Thu, 16 Mar 2017 10:16:26 -0600
Message-ID: <20170316161626.GE23821@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489615927-12117-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489618538.2660.14.camel@sandisk.com>
 <20170315231837.GA23082@obsidianresearch.com>
 <1489626275.3542.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489626275.3542.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 16, 2017 at 01:04:49AM +0000, Bart Van Assche wrote:
> Have you considered to introduce something like the function below? I think
> that would make the changes smaller and hence easier to review.

I started like this and then just inlined the arithmatic in the few
call sites.

I think the algorithm reads as clearly either way and I generally
prefer to use the standard library directly..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
