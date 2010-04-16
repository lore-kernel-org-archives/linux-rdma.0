From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Fri, 16 Apr 2010 15:05:05 +0300
Message-ID: <20100416120505.GB11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0EEE4F40-F1DD-46A6-B756-3C46DA06B403-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:52 Wed 14 Apr     , Ira Weiny wrote:
> 
> > But then it blocks process_mads() to loop forever after single
> > send_smp() failure (with all empty queues and umad_recv() running
> > without timeout).
> 
> But moving the cl_qmap_insert below the send call fixes that.   

It doesn't:

int process_mads(smp_engine_t * engine)
{
	int rc = 0;
	while (engine->num_smps_outstanding > 0) {
		if ((rc = process_smp_queue(engine)) != 0)
			return rc;
		while (!cl_is_qmap_empty(&engine->smps_on_wire))
			if ((rc = process_one_recv(engine)) != 0)
				return rc;
	}
	return 0;
}

After send_smp() failure engine->num_smps_outstanding still be > 0 and
will be never decreased (tested).

> However, it does cause a memory leak because the smp is no longer in  
> the smp_queue_head list.

This is correct about leaking.

> It needs to be put back on that list to be  
> retried with a limit on the retries (to prevent what you are saying  
> here.)

We have already retries mechanism implemented in umad_send(), so likely
failed MAD should be just dropped and freed:

diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 08e3ef7..89c0b05 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -96,8 +96,10 @@ static int process_smp_queue(smp_engine_t * engine)
 		if (!smp)
 			return 0;
 
-		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
+		if ((rc = send_smp(smp, engine->ibmad_port)) != 0) {
+			free(smp);
 			return rc;
+		}
 		engine->num_smps_outstanding++;
 		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
 			       (cl_map_item_t *) smp);


> Are you seeing a hang?

I'm seeing endless loop.

> I have seen a hang when running "iblinkinfo -S <guid>".

What do you mean "hang"? Endless loop?

> However, the  
> problem is not with send_smp.  I am seeing the mad going on the wire  
> and returning (according to madeye) but I am not receiving it from  
> umad_recv.  I don't know why.  If I run with 1 outstanding mad it  
> works???

Do you see this with current master (for me 'iblinkinfo -S' works fine,
but I have only two switches).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
