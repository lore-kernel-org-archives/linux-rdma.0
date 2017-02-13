From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/srp: Avoid that duplicate responses trigger a
 kernel bug
Date: Mon, 13 Feb 2017 16:02:45 +0000
Message-ID: <1487001751.2719.0.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <20170210235611.3243-2-bart.vanassche@sandisk.com>
         <20170212170537.GE14015@mtr-leonro.local>
         <1486930017.2918.3.camel@sandisk.com>
         <20170213055432.GM14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170213055432.GM14015-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <0D6A84A2389A4C43B0F15AF3C90F0423-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Feeley <Steve.Feeley-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-02-13 at 07:54 +0200, Leon Romanovsky wrote:
> I'm sure that I'm missing something, but how would it be triggered?
> We will enter to call second srp_claim_req() function only if "req" is
> not NULL.
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 79bf48477ddb..40e7f27c40bf 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1897,10 +1897,12 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
>  		complete(&ch->tsk_mgmt_done);
>  	} else {
>  		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
> -		if (scmnd) {
> +		if (scmnd && scmnd->host_scribble) {
>  			req = (void *)scmnd->host_scribble;
>  			scmnd = srp_claim_req(ch, req, NULL, scmnd);
>  		}
> +		else
> +			scnmnd = NULL;
>  		if (!scmnd) {
>  			shost_printk(KERN_ERR, target->scsi_host,
>  				     "Null scmnd for RSP w/tag %#016llx received on ch %td / QP %#x\n",

Hello Leon,

Sorry but I had misread your previous e-mail. I agree that the above should
work fine.

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
