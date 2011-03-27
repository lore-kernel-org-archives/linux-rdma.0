From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Proper mfttop initialization when
 starting/restarting
Date: Sun, 27 Mar 2011 18:26:47 +0200
Message-ID: <20110327162647.GF23892@calypso.voltaire.com>
References: <4D8D1161.7020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D8D1161.7020900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 00:04 Sat 26 Mar     , Hal Rosenstock wrote:
> Rather than setting mfttop to 0xbfff first time, initialize (indicated
> by first_time_master_sweep) based on whether or not SA DB is being loaded.
> If it's being loaded, get mfttop from there (based on max MLID in the
> SA DB). Otherwise, it's set to 0 which makes multicast behave as it did
> prior to there being an mfttop (meaning any MC routes are "honored".
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
