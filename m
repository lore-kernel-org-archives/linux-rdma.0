From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 13:10:28 +0200
Message-ID: <525539A4.8090700@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

we've encountered an issue with OpenSM 3.3.16 and the config option
"console off".
OpenSM processes are at 100% CPU load.

>From strace:
poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
read(0, "", 4096)                       = 0
poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
read(0, "", 4096)                       = 0
poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
read(0, "", 4096)                       = 0

As far as I've seen in the code, the function osm_console() from
opensm/osm_console.c is the only function which uses poll().

Is this issue already known or perhaps already fixed?

Thanks,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
