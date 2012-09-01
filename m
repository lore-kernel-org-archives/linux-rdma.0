From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/5] ib_srp: removed superfluous warning in send timeout
 case
Date: Sat, 01 Sep 2012 07:44:02 +0000
Message-ID: <5041BCC2.8010309@acm.org>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com> <1346443241-24844-3-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-3-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/31/12 20:00, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org wrote:
> From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> 
> Signed-off-By: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a0d0ca2..1b274484 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -534,7 +534,6 @@ static void srp_wait_last_send_wqe(struct srp_target_port *target)
>  		msleep(20);
>  	}
>  
> -	WARN_ON(!target->last_send_wqe);
>  }
>  
>  static void srp_disconnect_target(struct srp_target_port *target)

The purpose of the functions srp_wait_last_recv_wqe() and
srp_wait_last_send_wqe() is to wait until the IB HCA has finished
delivering work completions to ib_srp. The InfiniBand Architecture
Manual specifies how long that can take. If the above WARN_ON()
statement is hit it means that it took longer than expected before all
pending work was completed. Letting srp_wait_last_send_wqe() return
before all pending work has been completed is dangerous because that may
trigger a use-after-free in the code that calls that function. So we
have to dig deeper here and find out why that WARN_ON() statement was hit.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
