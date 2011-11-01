From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_link_mgr.c: Remove no longer needed memset
Date: Tue, 1 Nov 2011 18:28:03 +0200
Message-ID: <20111101162803.GD2286@calypso.mtl.com>
References: <4EA98D17.6090006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EA98D17.6090006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 12:55 Thu 27 Oct     , Hal Rosenstock wrote:
> 
> Since PortInfo attribute is now IB_SMP_DATA_SIZE (64 bytes),
> there is no remaining space at the end of the attribute as
> it now fills the entire SMP data size.
> 
> Found-by: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
