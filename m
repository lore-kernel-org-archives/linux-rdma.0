From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to preserve QP over HA events for librdmacm applications
Date: Thu, 20 Sep 2012 20:10:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E77F@ORSMSX101.amr.corp.intel.com>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
 <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com>
 <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov>
 <505B5470.9030707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <505B5470.9030707-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What if you say pre-created a second (fail over) QP for HA purposes all
> under the covers of a single socket? And both QPs were connected before
> the failure. Not sure if that would work with the same CM id though. If
> not, we will need to rdma_connect() the second QP after failure.

CM IDs are not shared across devices, and can't be reused for different QPs until the first connection has been torn down and gone through timewait.  For IB, you probably want path migration capabilities.

Anything more generic should really be handled by the application.  Migrating a connection between devices also requires using different CQs, PDs, MRs, etc.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
