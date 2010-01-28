From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: DREQ timeout for rdma-cm consumers
Date: Wed, 27 Jan 2010 21:22:17 -0800
Message-ID: <F766FA8B1AD74F0E98EF28981448A4CF@amr.corp.intel.com>
References: <Pine.LNX.4.64.1001261749260.13804@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1001261749260.13804-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>2nd, looking on the code, I see that cma_connect_ib uses
>CMA_CM_RESPONSE_TIMEOUT
>(20) for req.remote_cm_response_timeout and CMA_MAX_CM_RETRIES (15) for
>req.max_cm_retries. Looking into the cm code, I see that ib_send_cm_req
>sets
>cm_id_priv->timeout_ms as a function of the path packet_life_time &&
>the remote_cm_response_timeout ... with the latter value being 20 and
>the
>former being 18 (this is a guess) does 100 seconds of a timeout makes
>sense to you?

I believe that the IB timeout of 20 is about 4 seconds.  If the packet
lifetime is 1 second, then each try will take 6 seconds to timeout.  For
15 retries, this is close to 100 seconds.  You should be able to destroy
the rdma_cm_id at anytime.

Also, the call to ib_send_cm_drep is called to handle the case where
both sides try disconnecting at the same time.  The call should be
harmless, since the IB CM handles the state checks.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
