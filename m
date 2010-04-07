From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [0/3] support --diff and --diffcheck in
	ibnetdiscover
Date: Wed, 07 Apr 2010 10:05:29 -0700
Message-ID: <1270659929.26381.38.camel@crazyclimber.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sasha,

The following sets of patches implement a --diff and --diffcheck options
in ibnetdiscover to let users diff an ibnetdiscover state to a previous
ibnetdiscover state.  The goal of this option is to help system
administrators isolate/determine changes in the network quickly compared
to a previous state.  Here's an example:

# > ./ibnetdiscover --diff=orig.cache 

vendid=0x8f1
devid=0x5a30
sysimgguid=0x8f10400411f57
switchguid=0x8f10400411f56(8f10400411f56)
Switch  24 "S-0008f10400411f56"         # "ISR9024D Voltaire" base port 0 lid 11 lmc 0
< [14]  "H-0002c90200219ef0"[1](2c90200219ef1)          # "wopr0" lid 64 4xDDR
< [19]  "H-0002c9030000ff7c"[1](2c9030000ff7d)          # "wopr9" lid 48 4xDDR
> [20]  "H-0002c9030000ff7c"[1](2c9030000ff7d)          # "wopr9" lid 4 4xDDR

< vendid=0x2c9
< devid=0x6282
< sysimgguid=0x2c90200219ef3
< caguid=0x2c90200219ef0
< Ca    2 "H-0002c90200219ef0"          # "wopr0"
< [1](2c90200219ef1)    "S-0008f10400411f56"[14]                # lid 64 lmc 2 "ISR9024D Voltaire" lid 11 4xDDR

In this particular example, port 14 on the switch (which is connected to
node 'wopr0') was up before but is now down (and the associated CA is
noted too).  In addition, 'wopr9' is connected to port 20 instead of
port 19 on the switch.

By default --diff checks switches, cas, routers, and port connections.
The --diffcheck option allows the user to specify which diff options
they want done, and also adds other diff checks for lids and/or node
descriptions.  More diff checks could be added later as needed.  For
example, the following only checks for differences of lids on switches.

# > ./ibnetdiscover --diff=orig.cache --diffcheck=sw,lid

vendid=0x8f1
devid=0x5a30
sysimgguid=0x8f10400411f57
switchguid=0x8f10400411f56(8f10400411f56)
< Switch        24 "S-0008f10400411f56"         # "ISR9024D Voltaire" base port 0 lid 11 lmc 0
> Switch        24 "S-0008f10400411f56"         # "ISR9024D Voltaire" base port 0 lid 3 lmc 0
< [13]  "H-0002c90200219e64"[1](2c90200219e65)          # "wopri" lid 4 4xDDR
> [13]  "H-0002c90200219e64"[1](2c90200219e65)          # "wopri" lid 1 4xDDR

Others on the list may wonder how this is different than just using the
normal 'diff' tool.  The differences I can think of are:

1) This checks differences in the network, not text.  This is
particularly important when lids, lmc, etc. are changed.  Otherwise
there are many differences in a normal diff output that aren't
necessary.

2) This provides the appropriate "context" in the diff output, showing
the appropriate system ids to allow a system administrator to identify
ports on what switch have changed.  Under normal diff output, you may
not get that appropriate context of information.  The system
administrator can of course use options like --context in diff, but the
goal is to make the diff output clear and concise, not outputting
unnecessary junk.

3) As parallelization has been added into ibnetdisocver/libibnetdiscover
this becomes more critical as output in ibnetdiscover/libibnetdiscover
can be re-ordered.  So a normal diff suddenly is non-functional.

There's probably other minor advantages.  Even if minor output tweaks
happen to ibnetdiscover in the future, this can still work against old
cache files.

Al


-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
