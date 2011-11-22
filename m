From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 0/5] infiniband-diags: Complete functionality of C based
 tools and move deprecated scripts to "compat rpm"
Date: Mon, 21 Nov 2011 16:02:30 -0800
Message-ID: <20111121160230.fca82911.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series add to the "C" based tools the final "major" functionality
of the script based tools.  Furthermore, it marks the scripts deprecated and
creates a compat rpm (_not_ built by default) which contains those scripts for
those who, heaven forbid, scripted around those scripts.  The motivation
behind this move is to make the overall functionality of the diags faster and
simpler.

The specific issues addressed are:

	1) redundant functionality
		ibcheckerrors vs ibqueryerrors
		ibstat vs ibstatus
		ibcheck[net|node] vs new iblinkinfo/ibqueryerrors "check" option
		ibprint[ca|switch|rt] vs ib[hosts|switches|routers]

	2) Additional functionality
		iblinkinfo and ibqueryerrors can be configured on a link by
		link basis for what links should be rather than having
		ibcheck* scripts look for != 1X links and no check for speed
		at all.  Furthermore, support for partially populated fabrics
		is enhanced, for example checking for links which should not
		be.

	3) Better Scalability.
		iblinkinfo and ibqueryerrors can scan the fabric up to 30X
		faster than the scripts.  One example[*] I ran, compared
		"ibqueryerrors -f" vs ibchecknet on my test nodes.  My test
		system includes just 2 switches and 2 nodes with 4 HCA's
		(2/node).  The time difference is staggering.

		ibchecknet:    1.793 seconds
			VS
		ibqueryerrors: 0.063 seconds

		This includes the additional functionality of ibqueryerrors!!!

	4) remove outdated/deprecated scripts
		perl versions of iblinkinfo/ibqueryerrors

	5) Less dependence on GUID's
		specifically ibfabricconf.xml files use node names rather than
		node or port guids to resolve their checks.  As large fabrics
		are maintained CAs and switches are often swapped for
		maintenance and names are a better abstraction for System
		Admins rather than having to update GUID's in a config.[**]

One downside to this change is that there will not be any "check"
functionality which does not have to be configured.  However, I don't believe
these "checks" were really useful to begin with.  Each fabric is different and
the user has different expectations for how their fabric should be cabled and
what speed/width those cables should be.

For further information on the new ibfabricconf.xml support see the iblinkinfo
man page.

Ira



[**] Unfortunately, some hardware still exists which can not have node
descriptions programed into the firmware.  Therefore the configuration of
NodeGUID to Node Name still must be configured.

[*] Here is an example of the different runs on my test system.  2 nodes, 2
switches, and 4 HCA's (2/node)

First the ibqueryerrors run:

	bash-4.1# time ibqueryerrors -f
	Errors for "happy HCA-3"
	   GUID 0x1175000079da38 port 1: [SymbolErrorCounter == 332] [PortRcvErrors == 6]
	Errors for 0x66a00e3003b39 "QLogic 12200 GUID=0x00066a00e3003b39"
	   GUID 0x66a00e3003b39 port ALL: [SymbolErrorCounter == 154] [LinkDownedCounter == 2] [VL15Dropped == 23]
	   GUID 0x66a00e3003b39 port 35: [SymbolErrorCounter == 154] [LinkDownedCounter == 1] [VL15Dropped == 23]
	   GUID 0x66a00e3003b39 port 36: [LinkDownedCounter == 1]
	Errors for 0x2c9020040ff58 "Ira's Switch"
	   GUID 0x2c9020040ff58 port ALL: [LinkDownedCounter == 18] [PortRcvSwitchRelayErrors == 6940] [PortXmitDiscards == 449] [PortXmitWait == 560]
	   GUID 0x2c9020040ff58 port 19: [PortXmitDiscards == 8] [PortXmitWait == 560]
	   GUID 0x2c9020040ff58 port 20: [LinkDownedCounter == 8] [PortXmitDiscards == 1]
	   GUID 0x2c9020040ff58 port 21: [PortXmitDiscards == 230]
	   GUID 0x2c9020040ff58 port 22: [LinkDownedCounter == 4] [PortRcvSwitchRelayErrors == 46] [PortXmitDiscards == 146]
	   GUID 0x2c9020040ff58 port 27: [PortRcvSwitchRelayErrors == 6894]
	   GUID 0x2c9020040ff58 port 35: [LinkDownedCounter == 4] [PortXmitDiscards == 63]
	   GUID 0x2c9020040ff58 port 36: [LinkDownedCounter == 2] [PortXmitDiscards == 1]
	   

	## Summary: 6 nodes checked, 3 bad nodes found
	##          76 ports checked, 10 ports have errors beyond threshold
	## Thresholds:
	## Suppressed:
	
	Reading fabric conf file...
	Evaluating connectively...
	ERR: port down: "QLogic 12200 GUID=0x00066a00e3003b39" p: 35[  ] <==> p: 35 "Ira's Switch" (Should be: 4X 10.0 Gbps Active)
	ERR: speed != 10.0 Gbps: "QLogic 12200 GUID=0x00066a00e3003b39" p: 36[  ] <==(4X 5.0 Gbps Active/ LinkUp)==>  p: 36[  ] "Ira's Switch" ( Could be 10.0 Gbps)
        ERR: Unconfigured active link: "ending HCA-3" p:  2[  ] <==(4X 10.0 Gbps Active/  LinkUp)==>  p: 20[  ] "Ira's Switch" ( )
	ERR: port disabled: "Ira's Switch" p: 35[  ] <==>  p: 35 "QLogic 12200 GUID=0x00066a00e3003b39" (Should be: 4X 10.0 Gbps Active)
	
	Stats Summary: (76 total physical ports) 66 down ports(s) 1 disabled ports(s)
	   5 link(s) at 4X
	   1 link(s) at 5.0 Gbps (DDR)
	   4 link(s) at 10.0 Gbps (QDR)
	
	real    0m0.063s
	user    0m0.003s
	sys     0m0.015s


Now the ibchecknet run:

	bash-4.1# time ./ibchecknet
	#warn: counter SymbolErrorCounter = 154         (threshold 10) lid 10 port 255
	Error check on lid 10 (QLogic 12200 GUID=0x00066a00e3003b39) port all:  FAILED
	#warn: counter LinkDownedCounter = 18   (threshold 10) lid 4 port 255
	#warn: counter PortRcvSwitchRelayErrors = 6940  (threshold 100) lid 4 port 255
	#warn: counter PortXmitDiscards = 449   (threshold 100) lid 4 port 255
	Error check on lid 4 (Infiniscale-IV Mellanox Technologies) port all:  FAILED
	#warn: counter PortXmitDiscards = 230   (threshold 100) lid 4 port 21
	Error check on lid 4 (Infiniscale-IV Mellanox Technologies) port 21:  FAILED
	#warn: counter PortXmitDiscards = 146   (threshold 100) lid 4 port 22
	Error check on lid 4 (Infiniscale-IV Mellanox Technologies) port 22:  FAILED
	
	# Checking Ca: nodeguid 0x001175000079da38
	#warn: counter SymbolErrorCounter = 332         (threshold 10) lid 5 port 1
	Error check on lid 5 (happy HCA-3) port 1:  FAILED
	
	# Checking Ca: nodeguid 0x0002c90300108f2e
	
	# Checking Ca: nodeguid 0x001175000077d90e
	
	# Checking Ca: nodeguid 0x0002c903004bebda
	
	*** WARNING ***: this command is deprecated; Please use "ibqueryerrors -f"
	## Summary: 6 nodes checked, 0 bad nodes found
	##          10 ports checked, 0 bad ports found
	##          3 ports have errors beyond threshold
	
	real    0m1.793s
	user    0m0.220s
	sys     0m0.576s



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
