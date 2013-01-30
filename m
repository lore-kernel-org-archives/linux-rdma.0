From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] Fix -Wtautological-compare warnings with clang
Date: Wed, 30 Jan 2013 19:49:20 +0200
Message-ID: <20130130174920.GL2961@calypso.mtl.com>
References: <alpine.BSF.2.00.1212091205060.64779@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.BSF.2.00.1212091205060.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Garret,

On 12:14 Sun 09 Dec     , Garrett Cooper wrote:
> From 1f91aeca2d9fecd1301d6fe2731a79d8640b2072 Mon Sep 17 00:00:00 2001
> From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Sun, 9 Dec 2012 02:44:32 -0800
> Subject: [PATCH 1/3] Fix -Wtautological-compare warnings with clang
> 
> V1:
> 
> The noted branch conditions are true or false and hence not
> tested/executed as designed.
> 
> Prune the always true/false conditional checks.
> 
> V2:
> 
> Fix the conditional check in osm_vendor_new by properly checking for
> IB_SUCCESS instead of assuming that values < 0 denotes error as this
> isn't possible given the enum definition.
> 
> Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

Applied the series. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
