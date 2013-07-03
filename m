From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: PATCH: opensm enhancements
Date: Wed, 03 Jul 2013 06:23:35 -0400
Message-ID: <51D3FBA7.9040604@dev.mellanox.co.il>
References: <51CB5BF1.1090601@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CB5BF1.1090601-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ciotti, Robert B. (ARC-TNE)" <bob.ciotti-NSQ8wuThN14@public.gmane.org>, Dale Talcott <Dale.R.Talcott-NSQ8wuThN14@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

HI Jeff,

On 6/26/2013 5:24 PM, Jeff Becker wrote:
> Hi Hal. At the OFA workshop, I mentioned that I've been working on some
> modifications to opensm that we use at NASA. Following extensive testing
> of these applied to opensm 3.3.13 (the version we run here), I have
> ported these to top of tree opensm, and have tested them on a small
> cluster.

Thanks for getting this done! For future reference, patches should be
sent as plain text as this makes it easier to comment.

> The first patch modifies the console logflush command to take "on" or
> "off" as an argument for toggling. 

Thanks. Applied.

> The second (more extensive) patch
> adds a command line option to specify a file in which each line contains
> a switch GUID/port pair to be ignored by opensm. The idea is to specify
> this file when you start opensm (it can be empty), and add ports to
> ignore (one per line for each end of a connection) to the file. At the
> next heavy sweep (or HUP) the sm will reprogram the forwarding tables
> without including the ignored links. We use this for replacing cables,
> as well as for system expansion (adding new racks).

I'll comment on this one later.

-- Hal

> Please let me know if you have any questions/issues with these. Thanks.
> 
> -jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
