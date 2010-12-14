From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: opensm configuration question
Date: Tue, 14 Dec 2010 15:42:32 -0700
Message-ID: <4D07F2D8.4080602@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sam Liston <sam.liston-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I've got an opensm question.

With opensm running, I run opensm --help, and it tells me what I am 
expecting from the configuration I have given it. I configured it for 
updn routing with /etc/opensm/rootguids.conf as the root guids file:


-------------------------------------------------
OpenSM 3.3.7
  Reading Cached Option File: /etc/opensm/opensm.conf
  Loading Cached Option:guid = 0x0002c9030009714d
  Loading Cached Option:routing_engine = updn
  Loading Cached Option:root_guid_file = /etc/opensm/rootguids.conf
  Loading Cached Option:sm_priority = 15
  Loading Cached Option:log_flags = 4
  Loading Cached Option:console = local
Command Line Arguments:


However, when I do an ibtracert between two nodes on different leaf 
switches, it appears to be using minhop routing (the root guids I 
specified are not in the path):

[root@sm2 ~]# ibtracert 24 69
 From ca {0x0002c903000bb5d8} portnum 1 lid 24-24 "em001 HCA-1"
[1] -> switch port {0x0008f10500201d8c}[1] lid 15-15 "Voltaire 4036 # 
komas-is-a1-1"
[36] -> switch port {0x0008f105006515ca}[19] lid 9-9 "Voltaire sLB-4018 
    Line 8  Chip 1 4200 #komas-is-a6-1"
[20] -> switch port {0x0008f10500201b32}[36] lid 18-18 "Voltaire 4036 # 
komas-is-a2-1"
[28] -> ca port {0x0002c903000bb5f9}[1] lid 69-69 "em056 HCA-1"
To ca {0x0002c903000bb5f8} portnum 1 lid 69-69 "em056 HCA-1"

Looking in the opensm log file, I see this over and over:

OpenSM $ OpenSM $ OpenSM $ Dec : Command not found

Supported commands and syntax:
help [<command>]
quit (not valid in local mode; use ctl-c)
loglevel [<log-level>]
priority [<sm-priority>]
resweep [heavy|light]
reroute
sweep [on|off]
status [loop]
logflush -- flush the opensm.log file
querylid lid -- print internal information about the lid specified
portstatus [ca|switch|router]
switchbalance [verbose] [guid]
lidbalance [switchguid]
dump_conf
update_desc
version -- print the OSM version
dump_portguid [file filename] regexp1 [regexp2 [regexp3 ...]] -- Dump 
port GUID matching a regexp
OpenSM $


Any ideas?

Also, how can I use the console? I noticed a couple of config options 
for it, but I don't understand how to actually attach to the console to 
try things out.

Thanks,

Tom



-- 
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
