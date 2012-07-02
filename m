From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3 3/3] opensm: Add enum for FILE_ID for per module logging
Date: Mon, 2 Jul 2012 14:54:55 +0300
Message-ID: <20120702115455.GB9633@calypso>
References: <4FCFF739.9010006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FCFF739.9010006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 20:35 Wed 06 Jun     , Hal Rosenstock wrote:
> From e1230ff977e5a3412a83e11d26c4fb2c0765ce31 Mon Sep 17 00:00:00 2001
> From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 7 Jun 2012 03:19:15 +0300
> Subject: [PATCHv3 3/3] opensm: Add enum for FILE_ID for per module logging
> 
> An osm_file_ids_enum was added to new osm_file_ids_enum.h
> and a FILE_ID const definition to each source file.
> 
> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v2:
> Put osm_file_ids_enum into own header file rather than
> osm_sm.h
> 
> Changes since v1:
> opensm/osm_log.c: Use file_id rather than FILE_ID in
> osm_log_is_active_v2 call in osm_log_msg_box_v2 function
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
