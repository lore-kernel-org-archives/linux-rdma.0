From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2 1/2] opensm/osm_pkey_mgr.c: Pack switch peer port PKey
 tables
Date: Tue, 24 May 2011 19:10:36 +0300
Message-ID: <20110524161036.GC1943@calypso.voltaire.com>
References: <4DD6AE40.1030106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DD6AE40.1030106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:09 Fri 20 May     , Hal Rosenstock wrote:
> 
> In pkey_mgr_update_peer_port, rather than mirror the end port
> PKey table, pack the peer switch's port PKey table to
> eliminate any holes.
> 
> This is only done for switch external ports and not end ports
> because it's disruptive to change end port pkey indices
> whereas that's not the case for switch external ports and it has benefit there.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v1:
> Add more text to description above on why it's for end ports only
> In pkey_mgr_update_peer_port, when enforce is FALSE, return ret rather than return -1
> In pkey_mgr_update_peer_port, when ret is 0, modify debug log message
> 

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
