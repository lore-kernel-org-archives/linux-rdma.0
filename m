From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 08/9] ib/iser: move to use libiscsi passthrough mode
Date: Wed, 03 Feb 2010 15:32:10 -0600
Message-ID: <4B69EB5A.4050301@cs.wisc.edu>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com> <Pine.LNX.4.64.1002031740540.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031740540.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/03/2010 09:41 AM, Or Gerlitz wrote:
> @@ -526,17 +523,8 @@ void iser_snd_completion(struct iser_tx_
>   		kmem_cache_free(ig.desc_cache, tx_desc);
>   	}
>
> -	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
> -	    ISER_QP_MAX_REQ_DTOS)
> -		resume_tx = 1;
> -
>   	atomic_dec(&ib_conn->post_send_buf_count);
>
> -	if (resume_tx) {
> -		iser_dbg("%ld resuming tx\n",jiffies);
> -		iscsi_conn_queue_work(conn);
> -	}

What prevents the problem this code was handling from coming up now? Are 
you now preallocating enough resources, or are you returning 
-ENOMEM/-ENOBUFS from the init_task/xmit_task callouts so the scsi layer 
is now requeueing the IO?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
