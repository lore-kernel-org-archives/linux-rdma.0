From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] OpenSM: LFT update breaks if IB_SMP_DATA_SIZE changes
Date: Tue, 13 Oct 2015 10:25:25 -0400
Message-ID: <561D1455.7060509@dev.mellanox.co.il>
References: <1444742750-23875-1-git-send-email-jens.domke@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444742750-23875-1-git-send-email-jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/13/2015 9:25 AM, Jens Domke wrote:
> This is only a precautionary patch for a theoretical
> bug which would arise if someone redefines IB_SMP_DATA_SIZE
> to a values !=64.
> 
> ucast_mgr_pipeline_fwd_tbl() calculates the max. number of
> blocks to update using 64 explicitly, while set_lft_block()
> uses IB_SMP_DATA_SIZE.
> If IB_SMP_DATA_SIZE != 64 then switches would receive too few
> or too many blocks.
> 
> Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
