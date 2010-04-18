From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Sun, 18 Apr 2010 18:49:50 +0300
Message-ID: <20100418154950.GI11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
 <20100416120505.GB11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100416120505.GB11943@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:05 Fri 16 Apr     , Sasha Khapyorsky wrote:
> 
> I'm seeing endless loop.

Actually proposed fix is not enough, '-o 1' still be broken. To make it
properly outstanding SMPs counters should be discounted in
process_one_recv() before calling process_smp_queue() and smp receive
callback. The patch soon...

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
