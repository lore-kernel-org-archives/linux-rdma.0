From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/5] infiniband-diags/mcm_rereg_test.c: dead code
 removal
Date: Fri, 13 Apr 2012 18:40:52 -0700
Message-ID: <20120413184052.72d31575.weiny2@llnl.gov>
References: <1334279385-10792-1-git-send-email-foraker1@llnl.gov>
	<1334279385-10792-2-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334279385-10792-2-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Apr 2012 18:09:42 -0700
Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> wrote:

> Remove old #if 0'd code
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/mcm_rereg_test.c |   86 --------------------------------------------------
>  1 file changed, 86 deletions(-)
> 
> diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
> index a764d02..55b8add 100644
> --- a/src/mcm_rereg_test.c
> +++ b/src/mcm_rereg_test.c
> @@ -195,34 +195,6 @@ static int rereg_send_all(int port, int agent, ib_portid_t * dport,
>  	return 0;
>  }
>  
> -#if 0
> -static int rereg_mcm_rec_send(int port, int agent, ib_portid_t * dport, int cnt)
> -{
> -	ib_portid_t portid;
> -	ibmad_gid_t port_gid;
> -	uint8_t *umad;
> -	int len, ret = 0;
> -
> -	ib_resolve_self(&portid, NULL, &port_gid);
> -
> -	len = umad_size() + 256;
> -	umad = calloc(1, len);
> -	if (!umad) {
> -		err("cannot alloc mem for umad: %s\n", strerror(errno));
> -		return -1;
> -	}
> -
> -	while (cnt--) {
> -		if (!rereg_port_gid(port, agent, dport, umad, len, port_gid))
> -			ret += 2;
> -	}
> -
> -	free(umad);
> -
> -	return ret;
> -}
> -#endif
> -
>  static int rereg_recv(int port, int agent, ib_portid_t * dport,
>  		      uint8_t * umad, int length, int tmo)
>  {
> @@ -350,42 +322,6 @@ static int rereg_query_all(int port, int agent, ib_portid_t * dport,
>  	return 0;
>  }
>  
> -#if 0
> -static int rereg_mcm_rec_recv(int port, int agent, int cnt)
> -{
> -	uint8_t *umad, *mad;
> -	int len = umad_size() + 256;
> -	int i;
> -
> -	umad = calloc(1, len);
> -	if (!umad) {
> -		err("cannot alloc mem for umad: %s\n", strerror(errno));
> -		return -1;
> -	}
> -
> -	for (i = 0; i < cnt; i++) {
> -		int retry;
> -		retry = 0;
> -		while (umad_recv(port, umad, &len, TMO) < 0 &&
> -		       errno == ETIMEDOUT)
> -			if (retry++ > 3) {
> -				err("umad_recv %d failed: %s\n",
> -				    i, strerror(errno));
> -				free(umad);
> -				return -1;
> -			}
> -		dbg("umad_recv %d (retries %d), tid = 0x%016" PRIx64
> -		    ": len = %d, status = %d\n", i, retry,
> -		    mad_get_field64(umad_get_mad(umad), 0, IB_MAD_TRID_F), len,
> -		    umad_status(umad));
> -		mad = umad_get_mad(umad);
> -	}
> -
> -	free(umad);
> -	return 0;
> -}
> -#endif
> -
>  #define MAX_CLIENTS 50
>  
>  static int rereg_and_test_port(char *guid_file, int port, int agent,
> @@ -451,12 +387,7 @@ int main(int argc, char **argv)
>  	if (!srcport)
>  		err("Failed to open port");
>  
> -#if 1
>  	ib_resolve_smlid_via(&dport_id, TMO, srcport);
> -#else
> -	memset(&dport_id, 0, sizeof(dport_id));
> -	dport_id.lid = 1;
> -#endif
>  	dport_id.qp = 1;
>  	if (!dport_id.qkey)
>  		dport_id.qkey = IB_DEFAULT_QP1_QKEY;
> @@ -467,28 +398,11 @@ int main(int argc, char **argv)
>  		err("cannot alloc mem for umad: %s\n", strerror(errno));
>  		return -1;
>  	}
> -#if 1
>  	port = mad_rpc_portid(srcport);
> -#else
> -	ret = umad_init();
> -
> -	port = umad_open_port(NULL, 0);
> -	if (port < 0) {
> -		err("umad_open_port failed: %s\n", strerror(errno));
> -		return port;
> -	}
> -#endif
>  
>  	agent = umad_register(port, IB_SA_CLASS, 2, 0, NULL);
>  
> -#if 0
> -	int cnt;
> -	cnt = rereg_mcm_rec_send(port, agent, &dport_id, cnt);
> -
> -	rereg_recv_all(port, agent, &dport_id);
> -#else
>  	rereg_and_test_port(guid_file, port, agent, &dport_id, TMO);
> -#endif
>  	mad = umad_get_mad(umad);
>  
>  	free(umad);
> -- 
> 1.7.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
