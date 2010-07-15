From: "Boris Shpolyansky" <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: IB perf test questions
Date: Wed, 14 Jul 2010 22:04:26 -0700
Message-ID: <1E3DCD1C63492545881FACB6063A57C10612EB11@mtiexch01.mti.com>
References: <4C3E1DDF.1090305@utah.edu> <20100714211650.GA7348@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Regarding the BW numbers: they look reasonable. You can try to improve =
the BW up to 3.2GB/s by increasing PCIe MTU from 128 to 256 byte. It us=
ually requires BIOS configuration changes.

Boris Shpolyansky
Sr. Member of Technical Staff, Applications
=A0
Mellanox Technologies Inc.
350 Oakmead Parkway, Suite 100
Sunnyvale, CA 94085
Tel.: (408) 916 0014
=46ax: (408) 585 0314
Cell: (408) 834 9365
www.mellanox.com
Mellanox on Twitter and Facebook

-----Original Message-----
=46rom: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of Jason Gunthorpe
Sent: Wednesday, July 14, 2010 2:17 PM
To: Tom Ammon
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: IB perf test questions

On Wed, Jul 14, 2010 at 02:28:15PM -0600, Tom Ammon wrote:

> Also, whether I use ib_read_bw or ib_write_bw, the machine I initiate=
=20
> the test from (in this case "taildrop") shows one of its CPU cores=20
> pegged at 100% for the duration of the test, but I see no CPU=20
> utilization at all on the receiving node. Can someone explain to me=20
> what's going on under the hood, here? I would think that read_bw woul=
d=20
> load up the sending host but that write_bw would load up the receivin=
g=20
> host (or maybe vice versa), so this seems counterintuitive to me. whe=
n I=20
> use the -b flag to do a bidirectional test, a single CPU core on both=
=20
> machines pegs at 100%.

In all cases the master machine sits in a CPU bound loop waiting for
completions so it can issue more RDMA operations. The difference
between write and read is simply the RDMA op that is issued.

The slave side just sits there and the NIC does all the work.

Bi-directional mode runs a master operation on both sides..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
