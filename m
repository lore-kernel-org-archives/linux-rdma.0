From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v3 08/13] IB/srp: Add srp_terminate_io()
Date: Wed, 03 Jul 2013 10:57:21 -0400
Message-ID: <1372863441.24238.26.camel@frustration.ornl.gov>
References: <51D41C03.4020607@acm.org> <51D41F52.4000409@acm.org>
	 <1372860491.24238.0.camel@frustration.ornl.gov> <51D43915.9000007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D43915.9000007-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-07-03 at 16:45 +0200, Bart Van Assche wrote:
> Having it in the caller has the 
> advantage that the compiler can optimize the shift operation out because 
> the number that is being shifted left is a constant.

srp_finish_req() is likely to be inlined, so the compiler will be able
to make this optimization. Regardless, this is so far in the noise that
it looses to readability. 

>  And if later on it 
> would be necessary to set more fields of the SCSI result in a caller of 
> srp_finish_req() then that will be possible without having to modify the 
> srp_finish_req() function itself.

Other than REQ_QUIET, what do you think would need to be added? I think
we can cross that bridge when we get there, as I don't think REQ_QUIET
should not be set in the LLDs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
