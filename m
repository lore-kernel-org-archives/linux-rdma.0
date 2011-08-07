From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3] opensm: make loopback console compile on by default.
Date: Sun, 7 Aug 2011 14:26:20 +0300
Message-ID: <20110807112620.GA2305@calypso.mtl.com>
References: <20110803154230.06b59b88.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110803154230.06b59b88.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 15:42 Wed 03 Aug     , Ira Weiny wrote:
> 
> The console is very useful for debugging and should be available in opensm.conf
> as an option.
> 
> Generic socket is still an option which is off for security reasons.
> 
> Changes in V3:
>    Print warning when libwrap is not found for loopback
> 
> Changes in V2:
>    fix disable loopback when libwrap is not found
>    fix compile when loopback not enabled
>    clean up man page entry
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
