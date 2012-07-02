From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3 1/3] opensm: Add per module logging support
Date: Mon, 2 Jul 2012 14:54:23 +0300
Message-ID: <20120702115423.GA9633@calypso>
References: <4FD0DED6.6020801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FD0DED6.6020801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 13:03 Thu 07 Jun     , Hal Rosenstock wrote:
> Add _v2 APIs for osm_log, osm_log_is_active, and osm_log_msg_box
> Also, add these to libopensm.map
> 
> All of above pass additional parameter to identify module.
> Each module defines a unique FILE_ID from 0-255.
> FILE_ID must match index in osm_subnet.c:module_name_str
> table.
> 
> Modify OSM_LOG macros to use version 2 log APIs when FILE_ID
> is defined. Modify OpenSM client code to use version 2 log
> APIs when used log functions and not macros.
> 
> Added options to enable/disable per module logging and
> it's configuration file
> 
> Config file format
> Set of lines with module name and logging level as follows:
> <module name><separator><logging level>
> where:
> module name is file name including .c
> separator is either = , space, or tab
> logging level is the same levels as used in the coarse/overall logging
> as follows:
> 
>  BIT    LOG LEVEL ENABLED
>  ----   -----------------
>  0x01 - ERROR (error messages)
>  0x02 - INFO (basic messages, low volume)
>  0x04 - VERBOSE (interesting stuff, moderate volume)
>  0x08 - DEBUG (diagnostic, high volume)
>  0x10 - FUNCS (function entry/exit, very high volume)
>  0x20 - FRAMES (dumps all SMP and GMP frames)
>  0x40 - ROUTING (dump FDB routing information)
>  0x80 - SYS (syslog at LOG_INFO level in addition to OpenSM logging)
> 
> Add parsing of the configuration file into table of log levels
> indexed by FILE_ID
> 
> Added osm_get_log_per_module routine to obtain the configured info
> for a supplied module name. This is a new library function.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v2:
> Fixed find_module_name bug/typo
> Found and fixed by Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Changes since v1:
> Modify OSM_LOG macros to use version 2 log APIs when FILE_ID defined
> Eliminate magic numbers around per module logging table
> Based on comments from Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
> As this patch still is too large for email, please find this @
> https://www.openfabrics.org/~halr/0001-opensm-Add-per-module-logging-support.patch
> 
> --

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
