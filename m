From: Mike M <mike060677-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA CM problems, ib_find_cached_gid() fails
Date: Wed, 14 Apr 2010 10:55:57 -0500
Message-ID: <y2r3d2745531004140855r8dac1efdr7d6a1e8d37f4b66@mail.gmail.com>
References: <g2i3d2745531004131526gcfec6bc2pccbae15d55997e95@mail.gmail.com>
	 <CC1A47DBF3084F98B391E73238EAE221@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CC1A47DBF3084F98B391E73238EAE221-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 13, 2010 at 5:41 PM, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>Putting in lots of printk messages, I see that the server machine
>>indeed gets a connection request MAD, but that the
>>ib_find_cached_gid() call inside of cma_acquire_dev() fails.
>>
>>Any ideas?
>
> What kernel version are you using, and are you trying to connect using IPv4 or
> IPv6 addresses?
>

A modified 2.6.26-based kernel patched with updated OFED drivers based
on an rc version of 1.4.1.  IPv4 addresses.

I reverted to standard 2.6.26 and everything worked fine.  I will
further investigate.

Regards,
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
