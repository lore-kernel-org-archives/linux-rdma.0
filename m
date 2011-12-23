From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] opensm/libvendor/osm_vendor_ibumad.c: Fix DR path
 printing on send timeouts
Date: Fri, 23 Dec 2011 13:49:27 +0200
Message-ID: <20111223114927.GA28372@calypso>
References: <4EF0EB2E.9060407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EF0EB2E.9060407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:08 Tue 20 Dec     , Hal Rosenstock wrote:
> 
> Also, make log_send_error routine and call when MAD is cancelled
> 
> This patch is an alternative to Ira's v4 patch entitled 
> "opensm: Move Error printing to MAD error call back functions"
> which pushes this functionality up into the send error callbacks.
> 
> This patch is currently compile tested only.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Change since v1:
> Removed hop pointer from ERR 5411 log message
> 

Applied all 3 patches. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
