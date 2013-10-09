From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 09:28:36 -0400
Message-ID: <52555A04.8080606@dev.mellanox.co.il>
References: <525539A4.8090700@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525539A4.8090700-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sebastian,

On 10/9/2013 7:10 AM, Sebastian Riemer wrote:
> Hi Hal,
> 
> we've encountered an issue with OpenSM 3.3.16 and the config option
> "console off".
> OpenSM processes are at 100% CPU load.
> 
>>From strace:
> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> read(0, "", 4096)                       = 0
> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> read(0, "", 4096)                       = 0
> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
> read(0, "", 4096)                       = 0

So this doesn't block for 1 second and that's why the CPU is 100% ?

> As far as I've seen in the code, the function osm_console() from
> opensm/osm_console.c is the only function which uses poll().

osm_vendor_ibumad has a receiver thread polling umad under the covers of
umad_recv but I think that uses infinite rather than 1 second.

> Is this issue already known or perhaps already fixed?

This area of the console code has not changed in quite a while.
Any idea if this works with older versions of OpenSM ?

This is first I've heard of this issue.

-- Hal

> Thanks,
> Sebastian
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
