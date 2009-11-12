From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibqueryerrors: Reformat the output of
 the xmtdiscard details.
Date: Thu, 12 Nov 2009 19:21:59 +0200
Message-ID: <20091112172159.GK7192@me>
References: <20091110140440.c6b30018.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091110140440.c6b30018.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:04 Tue 10 Nov     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 3 Nov 2009 13:58:03 -0800
> Subject: [PATCH] infiniband-diags/ibqueryerrors: Reformat the output of the xmtdiscard details.
> 
> Old:
> Errors for 0x2c9020040fec8 "Infiniscale-IV Mellanox Technologies"
>    GUID 0x2c9020040fec8 port 27: [XmtDiscards == 8]
>    GUID 0x2c9020040fec8 port 27: [PortNeighborMTUDiscards == 8]
> 
> New:
> Errors for 0x2c9020040fec8 "Infiniscale-IV Mellanox Technologies"
>    GUID 0x2c9020040fec8 port 27: [XmtDiscards == 8] [PortNeighborMTUDiscards == 8]
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
