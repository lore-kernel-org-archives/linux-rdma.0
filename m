From: "Sufficool, Stanley" <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org>
Subject: RE: [ofw] What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 15:45:27 -0700
Message-ID: <946F457324732742B1457FAFC8CF1ECB012DD2B083B6@EXCHANGE2.sbcounty.gov>
References: <AANLkTikvA8oaksoszCoAvUs=sHp7uap-q+d9=f+AoQ96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikvA8oaksoszCoAvUs=sHp7uap-q+d9=f+AoQ96-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chris Worley' <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "'ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'OFED mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>-----Original Message-----
>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris Worley
>Sent: Friday, August 27, 2010 1:52 PM
>To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; OFED mailing list
>Subject: [ofw] What is an IOC device ID and what is DriverStore
>
>
>In scouring the many manuals with the Window's IB drivers I
>found a clue as to why I can't get SRP working in WinOF:
>
>  Windows PNP (Plug-n-Play) will match the IOC device ID with
>DriverStore installed drives and then will load the IBiou.sys driver
>
>How do I set the "IOC device ID" and what is DriverStore?

Not sure what this is, but I have never had to set any values on the OFED-W initiator.

>
>I can make the Windows SRP miniport devices appear and
>disappear by removing/reloading ib_srpt on the target (at
>least with the 2.1.1 driver from Mellanox; the latest at
>openfabrics.org panics the WS2008R2 system when ib_srpt is rmmod'ed).
>
>Beyond that, Windows never sees the drives... Linux initiators
>don't have an issue.

What messages do you get on the target? It it even receiving the request?

Does windows disk management show a broken LUN?

>
>Someone throw me a bone!  The SRP initiator seems to have been
>broken for many months on WinDoh's.

I have had no problems with the SRP initiator as long as I start the target _after_ the windows systems boot.

>
>Thanks,
>
>Chris
>_______________________________________________
>ofw mailing list
>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
