From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: ibnetdiscover issue
Date: Wed, 08 Dec 2010 10:48:35 -0700
Message-ID: <4CFFC4F3.3040805@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I get the following when I try to run ibnetdiscover from a server 
plugged in to a voltaire 4036 switch. We're using OFED 1.5.2:

[root@sm1 ~]# ibnetdiscover
src/chassis.c:535; Unexpected node found: guid 0x0008f1050075134c
ibnetdiscover: iberror: failed: discover failed


However, ibdiagnet runs fine:

[root@sm1 ~]# ibdiagnet
Loading IBDIAGNET from: /usr/lib64/ibdiagnet1.5.4
-W- Topology file is not specified.
      Reports regarding cluster links will use direct routes.
Loading IBDM from: /usr/lib64/ibdm1.5.4
-I- Using port 1 as the local port.
-I- Discovering ... 277 nodes (23 Switches & 254 CA-s) discovered.


-I---------------------------------------------------
-I- Bad Guids/LIDs Info
-I---------------------------------------------------
-I- No bad Guids were found

-I---------------------------------------------------
-I- Links With Logical State = INIT
-I---------------------------------------------------
-I- No bad Links (with logical state = INIT) were found

-I---------------------------------------------------
-I- General Device Info
-I---------------------------------------------------

-I---------------------------------------------------
-I- PM Counters Info
-I---------------------------------------------------
-W- lid=0x0007 guid=0x0008f105006515ba dev=23131 Port=33
        Performance Monitor counter     : Value
        link_error_recovery_counter     : 0xff (overflow)
-W- lid=0x0010 guid=0x0008f10500201d7c dev=23130 Port=14
        Performance Monitor counter     : Value
        symbol_error_counter            : 0xffff (overflow)
-W- lid=0x0001 guid=0x0008f10500108a76 dev=23130 Port=30
        Performance Monitor counter     : Value
        symbol_error_counter            : 0xffff (overflow)

-I---------------------------------------------------
-I- Fabric Partitions Report (see ibdiagnet.pkey for a full hosts list)
-I---------------------------------------------------
-I-    PKey:0x7fff Hosts:254 full:254 limited:0

-I---------------------------------------------------
-I- IPoIB Subnets Check
-I---------------------------------------------------
-I- Subnet: IPv4 PKey:0x7fff QKey:0x00000b1b MTU:2048Byte rate:10Gbps
SL:0x00

-I---------------------------------------------------
-I- Bad Links Info
-I- No bad link were found
-I---------------------------------------------------
----------------------------------------------------------------
-I- Stages Status Report:
      STAGE                                    Errors Warnings
      Bad GUIDs/LIDs Check                     0      0
      Link State Active Check                  0      0
      General Devices Info Report              0      0
      Performance Counters Report              0      3
      Partitions Check                         0      0
      IPoIB Subnets Check                      0      0

Please see /tmp/ibdiagnet.log for complete log
----------------------------------------------------------------

-I- Done. Run time was 21 seconds.

Any ideas?

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
