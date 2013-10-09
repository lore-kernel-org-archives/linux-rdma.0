From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 12:51:47 -0400
Message-ID: <525589A3.6060001@dev.mellanox.co.il>
References: <525539A4.8090700@profitbricks.com> <52555A04.8080606@dev.mellanox.co.il> <52556172.2070707@dev.mellanox.co.il> <52556BEE.5070409@profitbricks.com> <525572FE.5080805@dev.mellanox.co.il> <52557BCF.6030302@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52557BCF.6030302-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/9/2013 11:52 AM, Sebastian Riemer wrote:
> On 09.10.2013 17:15, Hal Rosenstock wrote:
>> What does service restart do in terms of OpenSM ?
>>
>> Note that the console parameter is _not_ changeable "on the fly" right
>> now so if OpenSM is being SIGHUP'd by service restart then this is a
>> current limitation (and is clearly not detected/protected against in the
>> current code base). It sounds like that may be what is going on.
> 
> Yes, it emits SIGHUP. Thanks for the information! The opensm is a
> critical component. So IMHO it needs to be fixed in a way that it either
> protects itself against such changes by ignoring them on the fly or it
> needs to support these changes.
> 
> The current situation is not really acceptable and the opensm stability
> is crucial. So I'll think about fixing it.
> Are you interested in patches in this regard?

Yes; such patches are always welcome! Thanks.

-- Hal

> 
> Cheers,
> Sebastian
> 
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
