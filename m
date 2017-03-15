From: Greg <gvrose8192-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about the SM Assigned GUID
Date: Wed, 15 Mar 2017 10:20:54 -0700
Message-ID: <1489598454.3695.6.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Greetings!

I'm working on an overlay driver for a new type of network controller
that can support traffic similar to infiniband and RDMA.  I've got an IB
driver going that reports the following when I run ibstat:

CA 'lfib0'
	CA type: LF HP HBA
	Number of ports: 1
	Firmware version: 1
	Hardware version: 1
	Node GUID: 0x14db9f33e9fe45b2
	System image GUID: 0x14db9f33e9fe45b2
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 10
		Base lid: 2
		LMC: 0
		SM lid: 1
		Capability mask: 0x009c0002
		Port GUID: 0x9eb738f98bf43f02
		Link layer: InfiniBand

However, when I run the opensm subnet manager the log shows this:

[root@fermi ~]# systemctl status opensm -l
● opensm.service - Starts the OpenSM InfiniBand fabric Subnet Manager
   Loaded: loaded (/usr/lib/systemd/system/opensm.service; enabled;
vendor preset: disabled)
   Active: active (running) since Wed 2017-03-15 09:42:02 PDT; 35min ago
     Docs: man:opensm
  Process: 559 ExecStart=/usr/libexec/opensm-launch (code=exited,
status=0/SUCCESS)
 Main PID: 561 (opensm-launch)
   CGroup: /system.slice/opensm.service
           ├─  561 /bin/bash /usr/libexec/opensm-launch
           └─10769 /usr/sbin/opensm -p 0 -g 0x9eb738f98bf43f02
--subnet_prefix 0xfe80000000000000

Mar 15 10:16:33 fermi OpenSM[10769]: -E- Parsing error in field
sm_assigned_guid, value out of range
Mar 15 10:16:33 fermi opensm-launch[559]: -E- Parsing error in field
sm_assigned_guid, value out of range

I've looked at the opensm code and I can't tell where the
sm_assigned_guid comes from or how my driver should be using it.

I apologize for my ignorance but I'm new to IB having come from the
Ethernet world of IWARP and RDMA.  If I could get a tip or a pointer
that would be great.

Thanks for your time,

- Greg
Lightfleet Corp.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
