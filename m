From: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 14:30:05 +0000
Message-ID: <SN1PR0301MB21274177B67EE02B96F14424DE820@SN1PR0301MB2127.namprd03.prod.outlook.com>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816053744.GD24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816053744.GD24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Leon:
Our Drivers are not in Kernel (being a small company we don't have resource=
s to make it in-kernel). When I and Hal worked on adding the switch capabil=
ity into the kernel, we thought it would be useful for the community (as th=
ere was interest in a few others besides us). Philosophically, since SWITCH=
 and ROUTER definitions are part of the IB spec, don't you think having the=
se definitions makes the kernel close to spec and hence useful? I know thes=
e definitions can be easily added into our drivers.
Just treat this as a request, if it is not an onus to the community, please=
 keep the SWITCH and ROUTER (only) definitions. If you have strong reasons =
I have no objections to your patches.

Thanks,
Suri

-----Original Message-----
From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
Sent: Wednesday, August 16, 2017 1:38 AM
To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_type=
s and node transport

On Tue, Aug 15, 2017 at 06:25:54PM +0000, Suri Shelvapille wrote:
> Leon:
>
> We do have IB_SWITCH and IB_ROUTER functionality and we do use the SWITCH=
 capability provided by the "core" in our product. The "core" has a wrapper=
 function which Identifies the device as a switch to direct smp packets. I =
am glad that has not been removed. And I hope it won't be removed as it wou=
ld be a burden to us. Although we prefer to have the IB_SWITCH/IB_ROUTER de=
finitions in the core as well, it is not a big deal to move these definitio=
ns inside our driver.
>

Can you please point me to IN-KERNEL hardware/driver where these values are=
 being set? Because I didn't find any.

Thanks

This correspondence, and any attachments or files transmitted with this cor=
respondence, contains information which may be confidential and privileged =
and is intended solely for the use of the addressee. Unless you are the add=
ressee or are authorized to receive messages for the addressee, you may not=
 use, copy, disseminate, or disclose this correspondence or any information=
 contained in this correspondence to any third party. If you have received =
this correspondence in error, please notify the sender immediately and dele=
te this correspondence and any attachments or files transmitted with this c=
orrespondence from your system, and destroy any and all copies thereof, ele=
ctronic or otherwise. Your cooperation and understanding are greatly apprec=
iated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
