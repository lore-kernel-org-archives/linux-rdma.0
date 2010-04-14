From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Wed, 14 Apr 2010 13:23:35 +0300
Message-ID: <20100414102335.GT10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413134446.72eb336a.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:44 Tue 13 Apr     , Ira Weiny wrote:
> 
> > This changes the logic.  "num_smps_outstanding" is NOT the number on the wire, but it appears you have made it so.

Actually yes, it made it so.

> > This is the number which will cause process_smp_queue to continue being called.
> > 
> > If you are going to do this I think you need to change process_mads as well as process_one_recv.  We discussed process_one_recv in the error case.

process_one_recv() failure breaks the loop anyway.

> > What were you trying to fix?
> 
> Ok, I think I see.  We should move cl_qmap_insert to after a successful umad_send and putting total_smps here is ok.  But num_smps_outstanding should be put back I think.

But then it blocks process_mads() to loop forever after single
send_smp() failure (with all empty queues and umad_recv() running
without timeout).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
