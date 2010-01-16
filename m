From: Nico <parpandet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Sat, 16 Jan 2010 14:42:44 +0100
Message-ID: <8fd3bb681001160542h13c0024h5bd10dcae10ddb71@mail.gmail.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
	 <adabpgwmwiw.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabpgwmwiw.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I just created a debian bug :

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D565494

Regards.

Nicolas



2010/1/14 Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>:
>
> =A0> I'am using an infiniband kernel 2.6.32-trunk-686 from debian,
>
> I guess the problem is that standard don't enable
> CONFIG_INFINIBAND_IPOIB_CM. =A0It's probably worth filing a Debian bu=
g for
> that, and we should probably change the upstream kernel default to "y=
es"
> as well.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
