From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: FW: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Tue, 10 Jun 2014 09:10:13 +0300
Message-ID: <5396A145.90504@mellanox.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1>	<CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com>	<20140609165105.GB1816@obsidianresearch.com>	<004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>	<20140609184207.GA534@obsidianresearch.com>	<2ABFA3E36CBB794685BFBA191CC1964952C605CB@FMSMSX105.amr.corp.intel.com> <CAEmgqz2HtEJ1ho0rS4xR7ud6YgFfeAvR8uD8MgPjVhw=E9PFEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEmgqz2HtEJ1ho0rS4xR7ud6YgFfeAvR8uD8MgPjVhw=E9PFEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: PJ Waskiewicz <pj.waskiewicz-PrFOU5CTvK1l57MIdRCFDg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/06/2014 03:08, PJ Waskiewicz wrote:
> This was something I presented and discussed at NetConf 2011 

Peter, the email address from your signature on the patches isn't 
functional anymore, is it OK
if the patches will be re-worded with this (or any other address you 
want to) one such that we don't
introduce (3.16) patches which has wrong email from day one? Roland, can 
you make that?

> with David and other netdev core folks: 
> http://vger.kernel.org/netconf2011.html. The main issue David had with 
> the original approach was the socket was being consumed by something 
> else inside the kernel. It circumvented the TCP socket 
> allocation/reservation code, which was frowned upon. The compromise we 
> came up with is the approach in this patchset. As long as the socket 
> is claimed via userspace, David had no problem with the approach. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
