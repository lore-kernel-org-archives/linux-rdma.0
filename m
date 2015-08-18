From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V8 6/6] IB/ucma: HW Device hot-removal support
Date: Tue, 18 Aug 2015 11:50:47 -0600
Message-ID: <20150818175047.GA21113@obsidianresearch.com>
References: <1439479927-8751-1-git-send-email-yishaih@mellanox.com>
 <1439479927-8751-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439479927-8751-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 13, 2015 at 06:32:07PM +0300, Yishai Hadas wrote:
> @@ -501,10 +586,24 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
> +	if (!ctx->closing) {
> +		mutex_unlock(&mut);
> +		ucma_put_ctx(ctx);
> +		wait_for_completion(&ctx->comp);
> +		rdma_destroy_id(ctx->cm_id);

Suggest nulling cm_id after it is destroyed in all places, this code
is very complicated, I'd rather see a nice clean risk of
null-pointer-deref than an undetected use-after free if it gets messed
up.

> +	list_for_each_entry(con_req_eve, &ctx->file->event_list, list) {
> +		if (con_req_eve->cm_id == cm_id &&
> +		    con_req_eve->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST) {
> +			list_del(&con_req_eve->list);

Isn't the list_for_each_safe version needed if list_del/kfree is called
within the body?

The locking looks much saner now, thanks Haggaie.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
