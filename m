From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: fix strtoull error handling
Date: Sun, 17 Apr 2011 18:13:56 +0300
Message-ID: <20110417151356.GB31503@calypso.voltaire.com>
References: <20110415151922.cd760149.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110415151922.cd760149.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:19 Fri 15 Apr     , Ira Weiny wrote:
> Subject: [PATCH] opensm: fix strtoull error handling
> 
> The man page states that errno _may_ be returned when the string can not be
> converted.  Check that the entire string was consumed otherwise assume this is
> not a guid.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
