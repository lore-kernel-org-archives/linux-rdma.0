From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Better handling of non responsive SMAs
Date: Wed, 9 Jun 2010 22:37:07 +0300
Message-ID: <20100609193707.GK20172@me>
References: <20100609182911.GA26769@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100609182911.GA26769-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:29 Wed 09 Jun     , Hal Rosenstock wrote:
> 
> In order to better handle non responsive SMAs (when link is physically up
> but the SMA does not respond), a timeout based mechanism for SMPs is added
> to better enable forward progress in a more timely fashion. So rather than
> waiting for timeouts and outstanding wire SMPs to drop below some configured
> value, there is also an additional limit introduced for transaction based SMPs.
> These timeout based SMPs are capped at a configured maximum value.
> 
> Two new options are added for this:
> max_wire_smps2 indicates the second (higher) limit of timeout based
> SMPs supported. When this limit is reached, timeout based SMPs
> are not longer sent (until the number of outstanding ones drops below
> this limit).
> max_smps_timeout indicates the number of microseconds used for the
> timeout in between sending SMPs when the oustanding wire count is above
> max_wire_smps and below max_wire_smps2. It defaults to the transaction
> timeout times the transaction retries.
> 
> The timeout based SMP mechanism can be disabled by setting max_wire_smps2 
> to the same value as max_wire_smps. This is equivalent to the (current)
> algorithm prior to this change. By default, this mechanism is disabled.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
