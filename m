From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_sm_state_mgr.c Don't clear IS_SM bit when changing
 state to NOT_ACTIVE
Date: Thu, 06 Jun 2013 06:09:03 -0400
Message-ID: <51B05FBF.2000708@dev.mellanox.co.il>
References: <89cab6e6-1a00-4def-8f89-cda8ccef67ce@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <89cab6e6-1a00-4def-8f89-cda8ccef67ce@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/5/2013 7:14 AM, Line Holen wrote:
> The SM is still operational even though it is in this state. Other
> SMs will not know about "our" presence when IS_SM is cleared and will
> therefor not attempt to enable "us" again.
> 
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
