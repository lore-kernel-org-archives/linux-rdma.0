From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Add per module logging support
Date: Wed, 30 May 2012 17:30:50 -0400
Message-ID: <4FC6918A.9080503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add _v2 APIs for osm_log, osm_log_is_active, and osm_log_msg_box
Also, add these to libopensm.map
Add _V2 forms of the various OSM_LOG macros

All of above pass additional parameter to identify module.
Each module defines a unique FILE_ID from 0-254.
255 is reserved to indicate "name not found".
FILE_ID must match index in osm_subnet.c:module_name_str
table. Note also currently that subnet's
per_mod_log_tbl is 128 entries (which is enough
more than the number of modules).

Use version 2 API (osm_log_v2) and macros (OSM_LOG_V2_xxxx)
in OpenSM client code

Added options to enable/disable per module logging and
it's configuration file

Config file format
Set of lines with module name and logging level as follows:
<module name><separator><logging level>
where:
module name is file name including .c
separator is either = , space, or tab
logging level is the same levels as used in the coarse/overall logging
as follows:

 BIT    LOG LEVEL ENABLED
 ----   -----------------
 0x01 - ERROR (error messages)
 0x02 - INFO (basic messages, low volume)
 0x04 - VERBOSE (interesting stuff, moderate volume)
 0x08 - DEBUG (diagnostic, high volume)
 0x10 - FUNCS (function entry/exit, very high volume)
 0x20 - FRAMES (dumps all SMP and GMP frames)
 0x40 - ROUTING (dump FDB routing information)
 0x80 - currently unused

Add parsing of the configuration file into table of log levels
indexed by FILE_ID

Added osm_get_log_per_module routine to obtain the configured info
for a supplied module name. This is a new library function.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
As this patch is too large for email, please find this @
https://www.openfabrics.org/~halr/0001-opensm-Add-per-module-logging-support.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
