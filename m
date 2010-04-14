From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Wed, 14 Apr 2010 12:58:31 +0300
Message-ID: <20100414095831.GR10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
 <20100413132531.GI10830@me>
 <20100413133028.b55a0cb1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413133028.b55a0cb1.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:30 Tue 13 Apr     , Ira Weiny wrote:
> 
> If we are going to do something like this why not more like a context?
> 
> Something like this?
> 
> ibqueryerrors.c
> 	query_errors_ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
> 
> 	{
> 		ibnd_context_t ctx;
> 		ctx.ca_name = ibd_ca;
> 		ctx.ca_port = ibd_ca_port;
> 		ctx.portid = portid;
> 		ctx.hops = hops;
> 		fabric = ibnd_discover_fabric(&ctx);  /* opens it's own ibmad_port */
> 	}
> ...

I didn't think about "context"-like, more as about few mandatory
(explicit) parameters + optional config.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
