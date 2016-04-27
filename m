From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 27 Apr 2016 10:46:52 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com> <1461765892-1285-2-git-send-email-matanb@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461765892-1285-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 27 Apr 2016, Matan Barak wrote:

> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -271,6 +271,11 @@ struct ib_cq_init_attr {
>  	u32		flags;
>  };
>
> +struct ib_lso_caps {
> +	u32 max_lso;
> +	u32 supported_qpts; /* Use enum ib_qp_type */

So this is a bitmap of the qps supported? And thus we have a limit now of
32 QP types. That needs to be documented and  you need a BUILD_BUG_ON
somewhere in case IB_QPT_MAX becomes larger than 32. Also needs to be
better commented so we know this is a bitmap.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
