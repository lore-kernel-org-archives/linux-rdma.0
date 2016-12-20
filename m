From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Connect-X5 device ID to device white lists
Date: Tue, 20 Dec 2016 23:14:36 +0200
Message-ID: <CAJ3xEMiN_nwLed217tiwpodj2rD_GdQWY0wmQFSkVfLrZq8d9g@mail.gmail.com>
References: <cb54fa49-84fb-3d2f-6431-e6b513b6fb46@dev.mellanox.co.il>
 <CAJ3xEMif-e63QZsJ025+O8T=ow6Rq-5sO9QvK8cC9wXYy7pnRg@mail.gmail.com> <9625766b-9c87-3905-d35c-e14e3ddc3653@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9625766b-9c87-3905-d35c-e14e3ddc3653-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 20, 2016 at 6:40 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 12/20/2016 2:25 AM, Or Gerlitz wrote:
>> What is the semantics of the white-list?
>
> The white lists control the issuing/checking of several Mellanox vendor
> specific MADs such as SM class MLNX ExtendedPortInfo (MEPI) which
> handles FDR10 and vendor class 0x0A GeneralInfo interpretation as to
> whether extended version fields are supported.
>
>> What happens if you see a device which is not there?
>
> It will affect FDR10 reporting or version reporting done via Mellanox
> vendor specific MADs.
>
> Do you see any that you think are missing ?

no, thanks for explaining
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
