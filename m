From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Fri, 9 Mar 2012 17:09:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823733B767E36@ORSMSX101.amr.corp.intel.com>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
 <1331071949.17729.11.camel@auk75.llnl.gov>
 <4F59FECE.4030107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F59FECE.4030107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What mkey model is being proposed here ? It looks to me like it is a
> single mkey for all ports in the subnet which is the simplest but least
> flexible model. If so, I think we need something more flexible as IBA
> allows each port to have it's own different mkey.

Is something more needed than just calling smp_mkey_set() to change it when needed?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
