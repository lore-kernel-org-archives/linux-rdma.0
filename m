From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 0/5] Add thread domain support
Date: Mon, 13 Nov 2017 13:06:51 -0700
Message-ID: <20171113200651.GG22610@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 12, 2017 at 11:41:38PM +0200, Yishai Hadas wrote:
> This RFC series is based on some initial discussion that was in the mailing
> list to support resource domain.
> 
> The series includes detailed man pages of the suggested APIs and initial
> patches in both verbs and mlx5 driver to demonstrate the expected usage.
> 
> The motivation behind the series is to allow an application finer
> grain control over share hardware resources and locks when the
> resources are used by the same thread.

I think I'm basically fine with this approach.

It is weird trade off to have a ibv_pd have two roles, but this seems
like the least bad option when compared with revising every single
ABI.

I assume you'll also add a create_cq_ex to accept a PD instead of a
device?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
