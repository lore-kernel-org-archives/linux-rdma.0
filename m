From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/srp: Fix residual handling
Date: Thu, 03 Jul 2014 10:00:49 -0700
Message-ID: <1404406849.32754.1.camel@haswell.thedillows.org>
References: <53B55E55.5040907@acm.org> <53B55EE0.1050403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55EE0.1050403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-07-03 at 15:47 +0200, Bart Van Assche wrote:

> -		if (rsp->flags & (SRP_RSP_FLAG_DOOVER | SRP_RSP_FLAG_DOUNDER))
> -			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
> -		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
> +		if (rsp->flags & SRP_RSP_FLAG_DIUNDER)
>  			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
> +		else if (rsp->flags & SRP_RSP_FLAG_DIOVER)
> +			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
> +		else if (rsp->flags & SRP_RSP_FLAG_DOUNDER)
> +			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
> +		else if (rsp->flags & SRP_RSP_FLAG_DOOVER)
> +			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));

LGTM. I wonder if we're getting to a point we should hide all the flag
checking behind a if (unlikely(rsp->flags)) { ...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
