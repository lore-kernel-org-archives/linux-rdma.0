From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to preserve QP over HA events for librdmacm applications
Date: Thu, 20 Sep 2012 21:52:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E89E@ORSMSX101.amr.corp.intel.com>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
 <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com>
 <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov>
 <505B5470.9030707@linux.vnet.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E77F@ORSMSX101.amr.corp.intel.com>
 <505B8349.4050402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <505B8349.4050402-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Fair enough, I understand one needs to use a different CM id. For the IB
> case I was thinking of avoiding APM (since that is limited to a device
> -isn't that so?).

APM is limited to a single device, as is memory registration, CQs, PDs, SRQs, etc.  Migration between devices requires entirely new memory registrations, the use of different lkeys/rkeys, and new CQs.  There's no guarantee that the HW devices support the same features - registration size, QP size, CQ size, etc.

> Is PD device specific? Couldn't one reuse the same CQs and MRs, even
> though the QP is different? Of course only one QP would be active at any
> time.

You can only reuse the resources if you limit yourself to the same device.

Supporting migration between devices requires a higher level abstraction which hides the internal RDMA device details.

HA itself likely requires more than simply establishing a new connection.  You may need to resolve the addresses again, to determine where to migrate to, plus obtain new path records.  Any app that wants full HA capability really needs to be able to handle a connection failing completely and establishing a new one.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
