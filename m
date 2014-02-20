From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 1/6] scsi_transport_srp: Fix two kernel-doc warnings
Date: Thu, 20 Feb 2014 13:01:41 +0100
Message-ID: <5305EEA5.8090802@profitbricks.com>
References: <5305DE01.7030004@acm.org> <5305DE2C.4080203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5305DE2C.4080203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20.02.2014 11:51, Bart Van Assche wrote:
> This patch fixes the following two kernel-doc warnings:
> 
> Warning(drivers/scsi/scsi_transport_srp.c:819): No description found for parameter 'rport'
> Warning(include/scsi/scsi_transport_srp.h:75): Excess struct/union/enum/typedef member 'deleted' description in 'srp_rport'
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Reported-by: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/scsi/scsi_transport_srp.c | 1 +
>  include/scsi/scsi_transport_srp.h | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index d47ffc8..13e8983 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -810,6 +810,7 @@ EXPORT_SYMBOL_GPL(srp_remove_host);
>  
>  /**
>   * srp_stop_rport_timers - stop the transport layer recovery timers
> + * @rport: SRP remote port for which to stop the timers.
>   *
>   * Must be called after srp_remove_host() and scsi_remove_host(). The caller
>   * must hold a reference on the rport (rport->dev) and on the SCSI host
> diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
> index b11da5c..cdb05dd 100644
> --- a/include/scsi/scsi_transport_srp.h
> +++ b/include/scsi/scsi_transport_srp.h
> @@ -41,7 +41,6 @@ enum srp_rport_state {
>   * @mutex:             Protects against concurrent rport reconnect /
>   *                     fast_io_fail / dev_loss_tmo activity.
>   * @state:             rport state.
> - * @deleted:           Whether or not srp_rport_del() has already been invoked.
>   * @reconnect_delay:   Reconnect delay in seconds.
>   * @failed_reconnects: Number of failed reconnect attempts.
>   * @reconnect_work:    Work structure used for scheduling reconnect attempts.
> 

This is trivial. Thanks!
Acked-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
