From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
 revert setting of init failure on QoS initialization failures
Date: Thu, 24 Dec 2009 14:37:29 +0200
Message-ID: <20091224123729.GJ26940@me>
References: <20091224112036.GA32559@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091224112036.GA32559-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06:20 Thu 24 Dec     , Hal Rosenstock wrote:
> 
> opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, revert setting of init failure on QoS attribute initialization failures
> 
> Revert the QoS related part of commit 254c2ef34fa0f475a93a63d805582bdd2efdeace 
> 
> There are unexplained cases of status 0x1c that have been observed
> for SL to VL mapping table setting as documented in "Re: qos on service-id"
> http://article.gmane.org/gmane.linux.drivers.rdma/1464
> 
> A subsequent patch will reintroduce this checking based on an additional
> option which will default to not do this.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
