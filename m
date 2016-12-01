From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Thu, 1 Dec 2016 05:35:42 +0000
Message-ID: <BLUPR02MB16836D6466A901D088E1FE65818F0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
 <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <20161128083107.GB6380@leon.nu>
 <bdd9788e-d393-b23e-876c-ae84774fdccd@sandisk.com>
 <20161201053105.GA4497@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/30/16 21:31, Leon Romanovsky wrote:=0A=
> On Mon, Nov 28, 2016 at 08:29:55AM -0800, Bart Van Assche wrote:=0A=
>> On 11/28/2016 12:31 AM, Leon Romanovsky wrote:=0A=
>>> I'm extra cautions with stable tags and prefer to finalize my stable=0A=
>>> checker in my submissions scripts first, before adding it manually and=
=0A=
>>> I have plans to use it next kernel release.=0A=
>>=0A=
>> Thanks for explaining your workflow. However, the question remains wheth=
er=0A=
>> or not stable tags should be added to the patches in this series?=0A=
>=0A=
> It can be added but I don't see any real advantage of it. Do you know=0A=
> about real users who run RDMA stack from stable trees and don't rely on=
=0A=
> distro kernel and/or OFED?=0A=
=0A=
Hello Leon,=0A=
=0A=
Many users who build an iSER or SRP storage target themselves use a =0A=
recent stable kernel without OFED.=0A=
=0A=
Bart.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
