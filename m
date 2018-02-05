From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 07/24] ibtrs: client: sysfs interface functions
Date: Mon, 5 Feb 2018 13:20:47 +0200
Message-ID: <1e874694-b30e-d957-6b48-edefe8e41c9a@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-8-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-8-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roman,

> This is the sysfs interface to IBTRS sessions on client side:
> 
>    /sys/kernel/ibtrs_client/<SESS-NAME>/
>      *** IBTRS session created by ibtrs_clt_open() API call
>      |
>      |- max_reconnect_attempts
>      |  *** number of reconnect attempts for session
>      |
>      |- add_path
>      |  *** adds another connection path into IBTRS session
>      |
>      |- paths/<DEST-IP>/
>         *** established paths to server in a session
>         |
>         |- disconnect
>         |  *** disconnect path
>         |
>         |- reconnect
>         |  *** reconnect path
>         |
>         |- remove_path
>         |  *** remove current path
>         |
>         |- state
>         |  *** retrieve current path state
>         |
>         |- stats/
>            *** current path statistics
>            |
> 	  |- cpu_migration
> 	  |- rdma
> 	  |- rdma_lat
> 	  |- reconnects
> 	  |- reset_all
> 	  |- sg_entries
> 	  |- wc_completions
> 
> Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

I think stats usually belong in debugfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
