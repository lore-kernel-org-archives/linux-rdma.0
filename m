From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: disconnect to SRP target before removing SCSI
 host
Date: Mon, 07 Jan 2013 12:34:57 +0100
Message-ID: <50EAB2E1.7050702@acm.org>
References: <1357394162-26316-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357394162-26316-1-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/05/13 14:56, Dongsu Park wrote:
> There has been a nasty problem upon removing an SRP target when the SRP
> target machine crashed accidently without giving back any IB events. In
> that case, the admin cannot make use of deleting remote ports for the
> purpose of tearing down SRP targets as well as SCSI host. One of the
> reasons was a completion on target->done, the other was the invocation
> order of srp_disconnect_target() and scsi_remove_host(). Consequence of
> the latter was unfortunately hanging forever on device_del(), until the
> target machine comes up again after having rebooted.
>
> That symptom is simply reproducible via sysfs. First of all, trigger an
> immediate reboot via /proc/sysrq-trigger on the SRP target.
>
>    target# echo b > /proc/sysrq-trigger
>
> After doing that, the Infiniband connection will be completely gone for
> several minutes at least. Then on the initiator's side, delete a remote
> port by writing 1 to /sys/class/srp_remote_ports/port-*\:1/delete, e.g.:
>
>    initiator# echo 1 > /sys/class/srp_remote_ports/port-6\:1/delete
>
> , where the SRP remote port to be deleted has its number 6.
>
> Then you will see stale SCSI targets remaining despite of rport delete,
> which is not expected though. That was resulted from device_del()
> hanging forever on destroying SCSI LLD.
>
> The solution consists of two modifications. The first one was already
> committed to jejb/for-next. See the commit 55d93898 "IB/srp: send
> disconnect request without waiting for CM timewait exit" by Vu Pham
> <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>. That will prevent from waiting for completion.
>
> The next one, which this commit is saying about, is changing the
> invocation order in srp_remove_target(). Call srp_disconnect_target()
> before scsi_remove_host(). This change will prevent device_del() from
> hanging indefinitely.
>
> This patch is based on the srp-ha-v3.7 tree by Bart Van Assche.
> See also <https://github.com/advance38/linux/tree/ib-srp-remove-target-v3.7>.
> If necessary, I could rebase it on the stable tree.
>
> Signed-off-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 307430e..ca4bf40 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -553,10 +553,11 @@ static void srp_remove_target(struct srp_target_port *target)
>   	if (scsi_host_added) {
>   		srp_del_scsi_host_attr(shost);
>   		srp_remove_host(shost);
> +		srp_disconnect_target(target);
>   		scsi_remove_host(shost);
> -	}
> +	} else
> +		srp_disconnect_target(target);
>
> -	srp_disconnect_target(target);
>   	ib_destroy_cm_id(target->cm_id);
>   	cancel_work_sync(&target->tl_err_work);
>   	srp_free_target_ib(target);

Sorry but this patch looks wrong to me, and that because of the 
following reasons:
- A root cause analysis is missing. It has been mentioned in the patch
   description that device_del() did hang but an analysis of why that
   hang occurred is missing.
- An explanation of why the above patch prevents device_del() to hang is
   missing.
- Invoking srp_disconnect_target() before scsi_remove_host() is wrong
   because it prevents the SYNCHRONIZE CACHE command issued by
   sd_shutdown() to reach the SRP target.

Note: although I'm not sure which issue exactly you ran into, this patch 
may help: "[PATCH for-next] IB/srp: Make SCSI error handling finish" 
(http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg13711.html).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
