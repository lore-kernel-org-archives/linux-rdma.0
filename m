From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ubuntu and OFED package
Date: Thu, 29 Oct 2009 17:46:32 +0100
Message-ID: <e2e108260910290946k477128day752dc951830e866f@mail.gmail.com>
References: <5D00672F-A0D5-4A5C-8C62-D32AA922C4AF@alcf.anl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5D00672F-A0D5-4A5C-8C62-D32AA922C4AF-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Harms <harms-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 5:10 PM, Kevin Harms <harms-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org> wrote=
:
>
> =A0I'm having an issue with using the available distro OFED package. =
This was with Ubuntu 9.04:
>
> node:~$ sudo ibv_devinfo
> mlx4: There is a mismatch between the kernel and the userspace librar=
ies: Kernel does not support XRC. Exiting.
> Failed to open device
>
> =A0 This was using the 2.6.28-11-server kernel. We also tried backing=
 down to a 2.6.27-15-server kernel and got a similar error.
>
> =A0Can anyone give me a hint on what to do? Or do i need to scrap the=
 ubuntu provided package?

Has libmlx4 been installed ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
