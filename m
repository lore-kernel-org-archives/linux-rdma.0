From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH V2 1/2] IB/core: Add support for enhanced atomic operations
Date: Mon, 01 Mar 2010 17:13:34 +0100
Message-ID: <AD48C8D2-A6DE-4490-B026-D83A47854C1E@Sun.com>
References: <20100214135128.GA7607@vlad-laptop>
 <adaljegx4vz.fsf@roland-alpha.cisco.com> <4B8ADB89.3010700@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4B8ADB89.3010700-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Still in-development, but it should be ready very soon. We will be th=
e
> first in-kernel user of atomics, as well as masked atomics. This tree
> does not support masked atomics yet because it is based on ofed 1.5.1=
=2E
> When 1.5.2 is officially released, I'll rebase, add mask support, and
> plan on pushing to mainline and ofed 1.6 as soon as it opens.



May be I missed something, but how do you guys intend to reflect this n=
ew functionality vs. the capabilities? A new atomic_enhanced_cap ?

The reason for asking is that the IB ordinary atomic repertoire fits ni=
cely with those of PCIe Gen 3, so one could possible assume new HCAs su=
pporting PCIe Gen3 to possess the ATOMIC_GLOB capability for atomic_cap=
=2E But I do not see that happening to the proposed Enhanced IB Atomics=
=2E


Thanks, H=E5kon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
