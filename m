From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 1/2] IB/core: Add support for enhanced atomic operations
Date: Tue, 20 Apr 2010 16:36:42 +0300
Message-ID: <4BCDADEA.1090105@dev.mellanox.co.il>
References: <20100414142300.GB16346@vlad-laptop> <BE945405-03B6-4D5F-8DC8-A7424250BDEC@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE945405-03B6-4D5F-8DC8-A7424250BDEC-U0mLk4xYmo8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

H=E5kon Bugge wrote:
> On Apr 14, 2010, at 16:23 , Vladimir Sokolovsky wrote:
>=20
>> The additional operands are carried in the Extended Transport Header
>=20
> Is this a newly defined ETH which follows the AETH on the wire?
>=20
>=20
>=20
> Thanks, H=E5kon
>=20

Yes,
Atomic masked Fetch and Add uses first 64 bits to provide the date to a=
dd,
and the second 64 bits provide the field boundary:

Swap (or Add) data high [63:32]
Swap (or Add) data low  [31:0]
Compare data (or Field boundary) high [63:32]
Compare data (or Field boundary) high [31:0]

Atomic masked Compare and Swap uses:

Swap (or Add) data high [63:32]
Swap (or Add) data low  [31:0]
Compare data high [63:32]
Compare data high [31:0]
Swap mask high [63:32]
Swap mask low  [31:0]
Compare mask high [63:32]
Compare mask low  [31:0]


Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
