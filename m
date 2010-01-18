From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv7 7/9] ib_core: Add API to support RoCEE from userspace
Date: Mon, 18 Jan 2010 09:53:10 +0200
Message-ID: <4B541366.2090509@Voltaire.com>
References: <20100105103322.GI31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103322.GI31480@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Add ib_uverbs_get_mac() to be used by ibv_create_ah() to retirieve the remote
> port's MAC address from the remote port's GID. Port link layer is also returned
> by ibv_query_port()

why can't all this be implemented within libibverbs? looking on mlx4's implementation of ib_get_mac, it reduces to calling rdma_get_ll_mac, a two liner inline function which does the translation.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
