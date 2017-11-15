From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Bug#881731: rdma-core: FTBFS on armhf and mips*: missing providers that need coherent DMA
Date: Wed, 15 Nov 2017 06:50:35 -0800
Message-ID: <588e0240-1b78-7a94-2fef-0287f5fa66bc@acm.org>
References: <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <20171114190805.GF4263@ziepe.ca> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <7f295a93-e27e-6661-7e57-743818e12ef5@redhat.com> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <20171115054400.GP18825@mtr-leonro.local> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net>
Reply-To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115054400.GP18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/14/17 21:44, Leon Romanovsky wrote:
> On Tue, Nov 14, 2017 at 03:41:13PM -0500, Don Dutile wrote:
>> Jason:
>> Why am I being cc'd on this debian bug?
>> I also received a notice about a bug fix in debian, and I had zip to do with it.
>>
>> Is my name tagged in Debian wrt rdma for some reason? by someone? other?
> 
> Don,
> 
> All of us received this email [1], because maintainer of rdma-core package
> is mailing list:
> 
> "Package: src:rdma-core; Maintainer for src:rdma-core is Linux RDMA
> Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;"
> 
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=881731

Something that's very annoying is that "linux-rdma" is not in the 
Cc-list of the bug tracker e-mails so these e-mails escape from filter 
rules. I would appreciate it if either linux-rdma would be removed as a 
maintainer from the Debian bug tracker, if it would be made visible in 
the e-mail Cc-list.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
