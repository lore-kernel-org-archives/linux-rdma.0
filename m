From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibqueryerrors.c: Optimize by querying AllPortSelect
 first
Date: Mon, 14 Jun 2010 15:54:02 +0300
Message-ID: <20100614125402.GX20172@me>
References: <20100610173434.890ea8e7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100610173434.890ea8e7.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:34 Thu 10 Jun     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-n5fQTqcq6rtliZ7u+bvwcg@public.gmane.org>
> Date: Thu, 6 May 2010 13:49:55 -0700
> Subject: [PATCH] ibqueryerrors.c: Optimize by querying AllPortSelect first
> 
> 	If errors are seen with AllPortSelect query individual ports for more
> 	details.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
