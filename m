From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 21:35:08 +0530
Message-ID: <CANjDDBifbT65XB9RZaRwAn0vDTnUHdT=LcdNpm-KJvLyTBU5BQ@mail.gmail.com>
References: <20170815085452.3546-1-leon@kernel.org> <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816053744.GD24282@mtr-leonro.local> <SN1PR0301MB21274177B67EE02B96F14424DE820@SN1PR0301MB2127.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR0301MB21274177B67EE02B96F14424DE820-VLIetriUNob/KlJXleiaIJwN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

We probably should be okay to retain SWITCH and ROUTER devices, lets
say if someone wants to port entire linux kernel IB stack on a
IB-switch or Router. Probably portability was the motivation to add
these since the birth of kernel IB stack.



On Wed, Aug 16, 2017 at 8:00 PM, Suri Shelvapille
<suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org> wrote:
> Leon:
> Our Drivers are not in Kernel (being a small company we don't have resour=
ces to make it in-kernel). When I and Hal worked on adding the switch capab=
ility into the kernel, we thought it would be useful for the community (as =
there was interest in a few others besides us). Philosophically, since SWIT=
CH and ROUTER definitions are part of the IB spec, don't you think having t=
hese definitions makes the kernel close to spec and hence useful? I know th=
ese definitions can be easily added into our drivers.
> Just treat this as a request, if it is not an onus to the community, plea=
se keep the SWITCH and ROUTER (only) definitions. If you have strong reason=
s I have no objections to your patches.
>
> Thanks,
> Suri
>
> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Wednesday, August 16, 2017 1:38 AM
> To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_ty=
pes and node transport
>
> On Tue, Aug 15, 2017 at 06:25:54PM +0000, Suri Shelvapille wrote:
>> Leon:
>>
>> We do have IB_SWITCH and IB_ROUTER functionality and we do use the SWITC=
H capability provided by the "core" in our product. The "core" has a wrappe=
r function which Identifies the device as a switch to direct smp packets. I=
 am glad that has not been removed. And I hope it won't be removed as it wo=
uld be a burden to us. Although we prefer to have the IB_SWITCH/IB_ROUTER d=
efinitions in the core as well, it is not a big deal to move these definiti=
ons inside our driver.
>>
>
> Can you please point me to IN-KERNEL hardware/driver where these values a=
re being set? Because I didn't find any.
>
> Thanks
>
> This correspondence, and any attachments or files transmitted with this c=
orrespondence, contains information which may be confidential and privilege=
d and is intended solely for the use of the addressee. Unless you are the a=
ddressee or are authorized to receive messages for the addressee, you may n=
ot use, copy, disseminate, or disclose this correspondence or any informati=
on contained in this correspondence to any third party. If you have receive=
d this correspondence in error, please notify the sender immediately and de=
lete this correspondence and any attachments or files transmitted with this=
 correspondence from your system, and destroy any and all copies thereof, e=
lectronic or otherwise. Your cooperation and understanding are greatly appr=
eciated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
