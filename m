From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Tue, 13 Mar 2012 08:29:37 -0400
Message-ID: <4F5F3DB1.1090002@dev.mellanox.co.il>
References: <1331064594.10889.8.camel@auk75.llnl.gov> <1331071949.17729.11.camel@auk75.llnl.gov> <4F59FECE.4030107@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823733B767E36@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823733B767E36-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2012 12:09 PM, Hefty, Sean wrote:
>> What mkey model is being proposed here ? It looks to me like it is a
>> single mkey for all ports in the subnet which is the simplest but least
>> flexible model. If so, I think we need something more flexible as IBA
>> allows each port to have it's own different mkey.
> 
> Is something more needed than just calling smp_mkey_set() to change it when needed?

I don't think so but the "tricky" part is the mkey itself.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
