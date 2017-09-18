From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Mon, 18 Sep 2017 14:54:11 -0600
Message-ID: <20170918205411.GB7059@obsidianresearch.com>
References: <1505648922-21346-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505648922-21346-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 17, 2017 at 02:48:42PM +0300, Yishai Hadas wrote:

> Resource domain represents a collection of IB resources (as of QP, CQ,
> etc.) which are accessed by an application from the same context (e.g.
> same thread) and as such can share hardware and software resources to
> allow smarter management of resources by the provider library and better
> performance.

This sounds exactly like a PD to me. Why do we need another construct?
What is wrong with a 'thread-unsafe' flag during PD creation and then
contain the shared resources in the PD?

>  	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
> +	uint32_t		max_resource_domains;

Even with this approach, not sure a max makes much sense, this value should
just be hashed into whatever range the provider has on a resource by
resource basis.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
