From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V1 9/9] IB/cma: Join and leave multicast groups
 with IGMP
Date: Mon, 23 Nov 2015 14:25:26 -0700
Message-ID: <20151123212526.GD6062@obsidianresearch.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
 <1444925232-13598-10-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444925232-13598-10-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 07:07:12PM +0300, Matan Barak wrote:
> diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
> index 0a40ed2..5bea0e8 100644
> +++ b/include/rdma/ib_sa.h
> @@ -206,6 +206,9 @@ struct ib_sa_mcmember_rec {
>  	u8           scope;
>  	u8           join_state;
>  	int          proxy_join;
> +	int	     ifindex;
> +	struct net  *net;
> +	enum ib_gid_type gid_type;
>  };

This is really gross.

Make ib_init_ah_from_mcmember accept a QP and get the above stuff from
the QP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
