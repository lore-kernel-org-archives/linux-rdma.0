From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Write Packets to InfiniBand HCA
Date: Tue, 3 Jan 2012 15:40:32 -0800
Message-ID: <CAL1RGDUOZw-+8R+rbsErd7PdB4gUH=zv1NYN-W1bxO5_ZgpdXQ@mail.gmail.com>
References: <CANtVascW3aRunBOSevwJgv8vN6gnNjmZM=8vLii=pUsDaFam3w@mail.gmail.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB5CCCCCFB63@MNEXMB1.qlogic.org> <CANtVasebZqgxoZOVMJ7uRGN7subRZqgq1vWjh_r11vXxa--Qog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANtVasebZqgxoZOVMJ7uRGN7subRZqgq1vWjh_r11vXxa--Qog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is possible with ConnectX (cf "MLX QPs" in the kernel driver).
However I don't know what documentation
is available and some hacking would be needed to use this for
something more general than sending
MADs on special QPs.

On Tue, Jan 3, 2012 at 8:43 AM, Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org> wrot=
e:
> Yes I should have mentioned that I am using a Mellanox Connect-X
> adapter. Do you know where I can find documentation for QLogic's
> iPath? A quick google search didn't seem to turn anything up.
>
> Thanks for the information.
>
> - Greg Kerr
>
> On Tue, Jan 3, 2012 at 9:53 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> That would depend on which HCA you are using. I know that you can us=
e QLogic's iPath interface to do what you want, but I don't think it is=
 possible through the verbs interface available through stock OFED.
>>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger=
=2Ekernel.org] On Behalf Of Greg I Kerr
>> Sent: Monday, January 02, 2012 9:50 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Write Packets to InfiniBand HCA
>>
>> Hi,
>>
>> Does anyone know if it is or isn't possible to put the HCA in some k=
ind of "raw" mode where I can compose a packet in software and write it=
 to the card? This is obviously in comparison to calling ibv_post_send =
and having a work request converted into a packet.
>>
>> Thanks,
>>
>> Greg Kerr
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo =
info at =A0http://vger.kernel.org/majordomo-info.html
>>
>>
>> This message and any attached documents contain information from QLo=
gic Corporation or its wholly-owned subsidiaries that may be confidenti=
al. If you are not the intended recipient, you may not read, copy, dist=
ribute, or use this information. If you have received this transmission=
 in error, please notify the sender immediately by reply e-mail and the=
n delete this message.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
