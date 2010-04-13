From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Tue, 13 Apr 2010 13:38:26 -0700
Message-ID: <20100413133826.00a8afc5.weiny2@llnl.gov>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
	<20100413163836.GM10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100413163836.GM10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This changes the logic.  "num_smps_outstanding" is NOT the number on the wire, but it appears you have made it so.  This is the number which will cause process_smp_queue to continue being called.

If you are going to do this I think you need to change process_mads as well as process_one_recv.  We discussed process_one_recv in the error case.

What were you trying to fix?

Ira

On Tue, 13 Apr 2010 19:38:36 +0300
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> 
> send_smp() failure blocks whole discovery execution (it never returns).
> Fix this by updating all outstanding SMPs related counters only after
> successful MAD sending.
> 
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  infiniband-diags/libibnetdisc/src/query_smp.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
> index b4322bc..08e3ef7 100644
> --- a/infiniband-diags/libibnetdisc/src/query_smp.c
> +++ b/infiniband-diags/libibnetdisc/src/query_smp.c
> @@ -96,10 +96,12 @@ static int process_smp_queue(smp_engine_t * engine)
>  		if (!smp)
>  			return 0;
>  
> -		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
> -			       (cl_map_item_t *) smp);
>  		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
>  			return rc;
> +		engine->num_smps_outstanding++;
> +		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
> +			       (cl_map_item_t *) smp);
> +		engine->total_smps++;
>  	}
>  	return 0;
>  }
> @@ -133,8 +135,6 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
>  	portid->sl = 0;
>  	portid->qp = 0;
>  
> -	engine->total_smps++;
> -	engine->num_smps_outstanding++;
>  	queue_smp(engine, smp);
>  	return process_smp_queue(engine);
>  }
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
