From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/17] Use the kernel ABI header instead of
 kern-abi.h
Date: Mon, 22 Jan 2018 10:37:17 -0700
Message-ID: <20180122173717.GA708@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 03:13:23PM -0700, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This substantially eliminates most of kern-abi.h. All that remains are the
> structs that have been modified by appending the header.
> 
> Much of the hard work was done via an automatic script.
> 
> I've been threatening to do this for some time, but forthcoming work on the
> kabi has now made it timely.
> 
> This is a github pull request:
> 
> https://github.com/linux-rdma/rdma-core/pull/282

Merged. ops_fix as well.

Unfortunately the merge message went awry from the github UI and
didn't get word wrapped :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
