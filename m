From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags/ibqueryerrors: Change realloc of
 suppressed fields to a static array
Date: Fri, 13 Nov 2009 07:58:53 +0200
Message-ID: <20091113055853.GH7192@me>
References: <20091103202238.4662c14d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091103202238.4662c14d.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20:22 Tue 03 Nov     , Ira Weiny wrote:
> Sasha,
> 
> 2 clean up patches which apply in order.
> 
> Ira
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 3 Nov 2009 13:19:33 -0800
> Subject: [PATCH] infiniband-diags/ibqueryerrors: Change realloc of suppressed fields to a static array
> 
> 	Realloc size was wrong causing a core when enough errors were
> 	suppressed.  Reproduced by running:
> 
> 	ibqueryerrors -c -s RcvSwRelayErrors,LinkDowned,VL15Dropped,XmtWait,SymbolErrors,LinkRecovers,RcvErrors
> 
> 	Change this to a static array which also removes the need to free
> 	memory.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
