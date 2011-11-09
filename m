From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Source code cleanup
Date: Tue, 08 Nov 2011 23:01:12 -0800
Message-ID: <1320822072.30780.338.camel@haakon2.linux-iscsi.org>
References: <201111082048.29209.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111082048.29209.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-11-08 at 20:48 +0100, Bart Van Assche wrote:
> Address the review comments posted by Christoph Hellwig on May 18,
> 2011 and that haven't been addressed yet (see also
> http://lkml.org/lkml/2011/5/18/63):
> - Eliminate the srpt_sdev_name(), srpt_get_ch_state() and
>   srpt_get_cmd_state() helper functions.
> - Convert the printk() call in srpt_srq_event() into pr_debug().
> 
> Also, remove the test from srpt_handle_new_iu() that ignores a new
> incoming request if the channel state equals CH_DISCONNECTING or
> CH_DRAINING. That test is not necessary since during session
> shutdown arrival of new requests is prevented by transitioning the
> QP into the error state.
> 
> Change one occurrence of if (e) ... else WARN_ON(!e) into
> if (e) ... else __WARN().
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c |   80 ++++++++-------------------------
>  1 files changed, 19 insertions(+), 61 deletions(-)
> 

Applied.  Thanks for taking care of this Bart!  

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
