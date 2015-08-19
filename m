From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V8 6/6] IB/ucma: HW Device hot-removal support
Date: Wed, 19 Aug 2015 16:59:11 +0300
Message-ID: <55D48BAF.3030709@dev.mellanox.co.il>
References: <1439479927-8751-1-git-send-email-yishaih@mellanox.com> <1439479927-8751-7-git-send-email-yishaih@mellanox.com> <20150818175047.GA21113@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818175047.GA21113-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/18/2015 8:50 PM, Jason Gunthorpe wrote:
> On Thu, Aug 13, 2015 at 06:32:07PM +0300, Yishai Hadas wrote:
>> @@ -501,10 +586,24 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
>> +	if (!ctx->closing) {
>> +		mutex_unlock(&mut);
>> +		ucma_put_ctx(ctx);
>> +		wait_for_completion(&ctx->comp);
>> +		rdma_destroy_id(ctx->cm_id);
>
> Suggest nulling cm_id after it is destroyed in all places, this code
> is very complicated, I'd rather see a nice clean risk of
> null-pointer-deref than an undetected use-after free if it gets messed
> up.

It can be helpful for debugging but usually nulling is not done when 
it's not really needed, because it is considered redundant.
Currently it's not the usage in this module and in cma.c when calling 
rdma_destroy_id.


  >> +	list_for_each_entry(con_req_eve, &ctx->file->event_list, list) {
>> +		if (con_req_eve->cm_id == cm_id &&
>> +		    con_req_eve->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST) {
>> +			list_del(&con_req_eve->list);
>
> Isn't the list_for_each_safe version needed if list_del/kfree is called
> within the body?
No need for a safe version here.

The safe version is needed only when a loop continues iterating after 
list_del && kfree, which is not the case here. When the entry is found 
there is a "break" in the code and the iteration is stopped. see next 
few lines in the patch.

See also below same usage as part of mlx4_remove_device.
http://lxr.free-electrons.com/source/drivers/net/ethernet/mellanox/mlx4/intf.c#L70

By the way, even if the code continues iterating the list (which is not 
the case here ...) the code is safe as the free is done from a task that 
calls first rdma_destroy_id which internally waits on same mutex that 
the loop called with as part of cma_remove_id_dev(i.e 
id_priv->handler_mutex). When the loop ends and the mutex is released, 
all the other tasks can continue running and free the entry. (see the 
comment in rdma_destroy_id "Wait for any active callback to finish ...")

>
> The locking looks much saner now, thanks Haggaie.

Yes, thanks as well.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
