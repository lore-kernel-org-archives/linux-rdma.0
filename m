From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags/libibnetdisc: clean up PortInfo
 queries
Date: Thu, 12 Nov 2009 22:43:49 +0200
Message-ID: <20091112204349.GU7192@me>
References: <20091110140137.0c66e84f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091110140137.0c66e84f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:01 Tue 10 Nov     , Ira Weiny wrote:
> Sasha,
> 
> This and the subsequent patch clean up the port info query code to be more
> straight forward.
> 
> First off I got rid of the "decode_port_info" function as it does very little
> and combined the smp_query_via call into a "query_port_info"
> 
> The second patch removes the "get_port_info" function as it became nearly
> redundant with query_port_info.
> 
> Ira
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 10 Nov 2009 11:22:03 -0800
> Subject: [PATCH] infiniband-diags/libibnetdisc: clean up PortInfo queries
> 
> 	remove old "decode_port_info" and replace with new "query_port_info"
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
