From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 01/14] IB/srp: Fix remove_one crash due to resource exhaustion
Date: Wed, 12 Jun 2013 15:38:23 +0200
Message-ID: <51B879CF.1080802@acm.org>
References: <51B87501.4070005@acm.org> <51B875A4.7040903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B875A4.7040903-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/12/13 15:20, Bart Van Assche wrote:
> If the add_one callback fails during driver load no resources are
> allocated so there isn't a need to release any resources. Trying
> to clean the resource may lead to the following kernel panic:
>
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa0132331>] srp_remove_one+0x31/0x240 [ib_srp]
> RIP: 0010:[<ffffffffa0132331>]  [<ffffffffa0132331>] srp_remove_one+0x31/0x240 [ib_srp]
> Process rmmod (pid: 4562, threadinfo ffff8800dd738000, task ffff8801167e60c0)
> Call Trace:
>   [<ffffffffa024500e>] ib_unregister_client+0x4e/0x120 [ib_core]
>   [<ffffffffa01361bd>] srp_cleanup_module+0x15/0x71 [ib_srp]
>   [<ffffffff810ac6a4>] sys_delete_module+0x194/0x260
>   [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>
> [bvanassche: Shortened patch description]
> Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 7ccf328..368d160 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2507,6 +2507,8 @@ static void srp_remove_one(struct ib_device *device)
>   	struct srp_target_port *target;
>
>   	srp_dev = ib_get_client_data(device, &srp_client);
> +	if (!srp_dev)
> +		return;
>
>   	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
>   		device_unregister(&host->dev);
>

Please note that this patch was authored by Dotan Barak, so I should 
have mentioned:

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
