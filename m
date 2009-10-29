From: Kevin Harms <harms-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org>
Subject: Re: Ubuntu and OFED package
Date: Thu, 29 Oct 2009 11:48:34 -0500
Message-ID: <8337AF06-59EF-4114-AFF2-2B9A965AFD88@alcf.anl.gov>
References: <5D00672F-A0D5-4A5C-8C62-D32AA922C4AF@alcf.anl.gov> <e2e108260910290946k477128day752dc951830e866f@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; boundary=Apple-Mail-31--645159341; micalg=sha1; protocol="application/pkcs7-signature"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260910290946k477128day752dc951830e866f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-31--645159341
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Bart,

   It appears that it has.

node:~$ aptitude search libmlx4
i A libmlx4-1                       - A userspace driver for Mellanox  
ConnectX I
p   libmlx4-1-dbg                   - Debugging symbols for the  
libmlx4 driver
p   libmlx4-dev                     - Development files for the  
libmlx4 driver

kevin

On Oct 29, 2009, at 11:46 AM, Bart Van Assche wrote:

> On Thu, Oct 29, 2009 at 5:10 PM, Kevin Harms <harms-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org>  
> wrote:
>>
>>  I'm having an issue with using the available distro OFED package.  
>> This was with Ubuntu 9.04:
>>
>> node:~$ sudo ibv_devinfo
>> mlx4: There is a mismatch between the kernel and the userspace  
>> libraries: Kernel does not support XRC. Exiting.
>> Failed to open device
>>
>>   This was using the 2.6.28-11-server kernel. We also tried backing  
>> down to a 2.6.27-15-server kernel and got a similar error.
>>
>>  Can anyone give me a hint on what to do? Or do i need to scrap the  
>> ubuntu provided package?
>
> Has libmlx4 been installed ?
>
> Bart.


--Apple-Mail-31--645159341
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

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
AAA=

--Apple-Mail-31--645159341--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
