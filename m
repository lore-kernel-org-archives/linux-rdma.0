From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual
 functions in virtual machine
Date: Tue, 5 Feb 2013 12:45:53 +0100
Message-ID: <CAOoYFkH0Lzfm9eb1gz-FWrYqbdx_QmmQH_iTZX2W60zwyc2N3A@mail.gmail.com>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
	<201301291644.35771.jackm@dev.mellanox.co.il>
	<CAOoYFkErXNxSBrQC_spMwcEiVmOpkzqQwuTQPOwO70bigsgYkQ@mail.gmail.com>
	<201302031040.20906.jackm@dev.mellanox.co.il>
	<CAOoYFkHnrty9Nh294y94bWx2PEXHxk8_cVbYbPJ+=jLgf4m+0A@mail.gmail.com>
	<B855DA7245737D4B83EDD9C0B7698E655952F564@MTLDAG02.mtl.com>
	<1359991471.11144.396.camel@bling.home>
	<CAOoYFkEnzYwPDjka+GGXeXt2xkGhX7qwAptGUvUJChgDEjRBGw@mail.gmail.com>
	<5110E64F.7080106@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5110E64F.7080106-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/2/5 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> On 05/02/2013 12:32, Mathis GAVILLON wrote:
>>
>> I've just finished to install qemu 1.3.1 and all is working well. IRQ
>> error has disappeared and an IB interface is know available in the virtual
>> machine.
>
>
> nice! could you say again what distribution provided you with the
> "problematic" kvm-qemu and what
> was the exact version of that qemu?

I'm using Fedora 18 and none of 1.2 versions (I really try 1.2.0,
1.2.2-2, 1.2.2-4 and 1.2.2-6 versions) of qemu-kvm support Infiniband
virtualization.

Mathis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
