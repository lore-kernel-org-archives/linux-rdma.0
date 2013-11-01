From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 08/10] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Fri, 01 Nov 2013 13:37:07 -0700
Message-ID: <527410F3.6040704@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-9-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-9-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> This patch implements IB_WR_REG_SIG_MR posted by the user.
>
> Baisically this WR involvs 3 WQEs in order to prepare and properly
> register the signature layout:
>
> 1. post UMR WR to register the sig_mr in one of two possible ways:
>      * In case the user registered a single MR for data so the UMR data segment
>        consists of:
>        - single klm (data MR) passed by the user
>        - BSF with signature attributes requested by the user.
>      * In case the user registered 2 MRs, one for data and one for protection,
>        the UMR consists of:
>        - strided block format which includes data and protection MRs and
>          their repetitive block format.
>        - BSF with signature attributes requested by the user.
>
> 2. post SET_PSV in order to set the for the memory domain initial
>     signature parameters passed by the user.
>
> 3. post SET_PSV in order to set the for the wire domain initial
>     signature parameters passed by the user.
>
> This patch also introduces some helper functions to set the BSF correctly
> and determining the signature format selectors.

Has it already been explained somewhere what the abbreviations KLM, BSF 
and PSV stand for ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
