From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] Installation problems of OFED-1.5.2
Date: Wed, 23 Feb 2011 11:14:18 +0200
Message-ID: <4D64CFEA.1030805@dev.mellanox.co.il>
References: <AANLkTi=s7YtdX2+bb4pLY035OXQSqyf21JuxatDCL=N_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=s7YtdX2+bb4pLY035OXQSqyf21JuxatDCL=N_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tanin <fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/23/2011 05:12 AM, Tanin wrote:
>   Dear all,
>
> I have recompiled the kernel to 2.6.18, and try to install  OFED-1.5.2
> instead.
>
> Now the kernel version is
>
> [litan@tera04 OFED-1.5.2]$ uname -a
> Linux tera04.ultralight.org 2.6.18-prep #1 SMP Tue Feb 22 18:51:00 EST 2011
> x86_64 x86_64 x86_64 GNU/Linux
>
>
> I have the full log file in the attachment. Dose it related to that I try
> many times to install different version of OFED? Thanks a million!
>

OFED's backport system is rely on kernel version.
So, changing kernel version changes the set of patches and headers to be used for the compilation.
You should keep the kernel version as close as possible to the original version.
E.g.:
If you compile 2.6.18 from kernel.org then you can name it 2.6.18-prep
But, if you recompile 2.6.18-164.el5, then you should name it  2.6.18-164.<any extension>.el5

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
