From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets with RoCE
Date: Fri, 29 Jun 2012 22:45:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A3F986@ORSMSX101.amr.corp.intel.com>
References: <4FEB964B.5060303@linux.vnet.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A3F493@ORSMSX101.amr.corp.intel.com>
 <4FEBA31A.4050302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FEBA31A.4050302-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > No objection.  The rdma_cm shouldn't be considered speed path anyway.  Btw, the IB CM exports some
> counters which can sometimes be helpful in debugging, though, those only report a count of which
> messages have been sent/received.
> 
> I have not used this before. How does one read these counters?

Look in /sys/class/infiniband_cm, under the device/port subdirectories
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
