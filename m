From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] Flow steering handling
Date: Thu, 9 Nov 2017 10:53:47 -0700
Message-ID: <20171109175347.GL7063@ziepe.ca>
References: <1510157897-10384-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510157897-10384-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 08, 2017 at 06:18:15PM +0200, Yishai Hadas wrote:
> This series aligns in the user space area the flow steering uverbs commands
> with other objects (e.g. QP, CQ) such that the commands don't allocate and free
> the ib_flow but are just responsible to issue the command.
> 
> The second patch in the series in mlx4 handles the cleanup on fatal scenario as
> already done for other destroy commands on top of the above change.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/244

Reviewed-by: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
