From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 11:15:10 -0400
Message-ID: <525572FE.5080805@dev.mellanox.co.il>
References: <525539A4.8090700@profitbricks.com> <52555A04.8080606@dev.mellanox.co.il> <52556172.2070707@dev.mellanox.co.il> <52556BEE.5070409@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52556BEE.5070409-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/9/2013 10:45 AM, Sebastian Riemer wrote:
> On 09.10.2013 16:00, Hal Rosenstock wrote:
> 
>> Do you recall the sequence to get to this ?
>>
>> Was console option changed to off and then OpenSM SIGHUP'd ? Something
>> else ?
>>
>> Is this reproducible ?
> 
> Yes, now I can reproduce it. The opensm has been initially started with
> "console off" and I activate "console local" and restart the service.
> CPU load is at 100% immediately. I set "console off" again and restart
> the service and CPU load is low again.
> 
> I did this three times in a row, now. And the third time it even
> remained at 100% load in the "off" state. I've set "local" and "off"
> again and CPU load was low again.

What does service restart do in terms of OpenSM ?

Note that the console parameter is _not_ changeable "on the fly" right
now so if OpenSM is being SIGHUP'd by service restart then this is a
current limitation (and is clearly not detected/protected against in the
current code base). It sounds like that may be what is going on.

-- Hal

> Cheers,
> Sebastian
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
