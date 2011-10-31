From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/4] opensm: Add mtu validation to SA
Date: Mon, 31 Oct 2011 18:33:34 +0200
Message-ID: <20111031163334.GD4616@calypso.mtl.com>
References: <4E8B0FBF.3070606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E8B0FBF.3070606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 09:53 Tue 04 Oct     , Hal Rosenstock wrote:
> The following patch series adds MTU validation to SA and is similar to the previous series on rate validation.
> 
> [PATCH 1/4] opensm/osm_helper: Add ib_mtu_is_valid
> [PATCH 2/4] opensm/osm_sa_path_record.c: Add mtu validation if supplied
> [PATCH 3/4] opensm/osm_sa_mcmember_record.c: Add mtu validation if supplied
> [PATCH 4/4] opensm/osm_sa_multipath_record.c: Add mtu validation if supplied
> --

Applied, thanks.
-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
