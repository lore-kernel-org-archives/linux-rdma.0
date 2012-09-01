From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/5] ib_srp: free memory correctly in srp_free_iu()
Date: Sat, 01 Sep 2012 07:32:37 +0000
Message-ID: <5041BA15.1090905@acm.org>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com> <1346443241-24844-2-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-2-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/31/12 20:00, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org wrote:
> From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> 
> As a potential fix for a race condition in srp_free_iu(),
> hold a mutex in srp_free_target_ib() before calling srp_free_iu().
> 
> In addition, also clear rx/tx ring after freeing memory.
> Both rx_ring[] and tx_ring[] should be reinitialized to NULL,
> to prevent other tasks from accessing the freed memory.
> 
> Signed-off-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 7ae5a00..a0d0ca2 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -291,10 +291,16 @@ static void srp_free_target_ib(struct srp_target_port *target)
>  	ib_destroy_cq(target->send_cq);
>  	ib_destroy_cq(target->recv_cq);
>  
> -	for (i = 0; i < SRP_RQ_SIZE; ++i)
> +	mutex_lock(&target->mutex);
> +	for (i = 0; i < SRP_RQ_SIZE; ++i) {
>  		srp_free_iu(target->srp_host, target->rx_ring[i]);
> -	for (i = 0; i < SRP_SQ_SIZE; ++i)
> +		target->rx_ring[i] = NULL;
> +	}
> +	for (i = 0; i < SRP_SQ_SIZE; ++i) {
>  		srp_free_iu(target->srp_host, target->tx_ring[i]);
> +		target->tx_ring[i] = NULL;
> +	}
> +	mutex_unlock(&target->mutex);
>  }
>  
>  static void srp_path_rec_completion(int status,

It would be interesting if you could provide a little more background
information about this patch. srp_remove_target() waits until all users
of rx_ring[] and tx_ring[] have finished before invoking
srp_free_target_ib(). Or at least, that's how it should work. Did you
come up with this patch after source reading or does this patch address
an issue you hit during testing ? In the last case we have to dig deeper
and we have to find out why it's possible that rx_ring[] and/or
tx_ring[] were accessed while srp_free_target_ib() was in progress.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
