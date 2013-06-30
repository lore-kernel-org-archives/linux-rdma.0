From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 10/15] IB/srp: Use SRP transport layer error recovery
Date: Sun, 30 Jun 2013 17:20:37 -0400
Message-ID: <1372627237.12468.41.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD87A9.2090702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD87A9.2090702-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 14:55 +0200, Bart Van Assche wrote:
> Enable reconnect_delay, fast_io_fail_tmo and dev_loss_tmo
> functionality for the IB SRP initiator. Add kernel module
> parameters that allow to specify default values for these
> three parameters.

> +static int srp_tmo_set(const char *val, const struct kernel_param *kp)
> +{
> +	int tmo, res;
> +
> +	if (strncmp(val, "off", 3) != 0) {

Trivial nit: this allows 'offended' to turn off the functionality.
Perhaps use two strcmp() to deal with the possible newline? Of course, I
think everyone else follows this pattern so, as I said trvial nit.

Assuming we accept patch 8, 
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
