From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 2/8] RDMA/core: Refactor IDR to be per-device
Date: Tue, 19 Jul 2016 20:15:41 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607192014010.5828@east.gentwo.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com> <1468941812-32286-3-git-send-email-matanb@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Jul 2016, Matan Barak wrote:

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 432bed5..14bfe3b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1706,6 +1706,10 @@ struct ib_device {
>
>  	struct iw_cm_verbs	     *iwcm;
>
> +	struct idr		idr;
> +	/* Global lock in use to safely release device IDR */
> +	spinlock_t		idr_lock;

Global? In what sense? This is a lock for the idrs for the particular
device right? The comment is a bit confusing. Maybe better remove it?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
