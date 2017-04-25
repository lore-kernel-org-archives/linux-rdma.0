From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Tue, 25 Apr 2017 23:41:00 +0300
Message-ID: <CACaajQsh+XUB=8T6YvSQv=70WHJuUxoSeYbh9Kn9bhCEDUH0EQ@mail.gmail.com>
References: <20170424114733.GI14088@mtr-leonro.local> <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local> <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
 <20170424181351.GM14088@mtr-leonro.local> <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA@mail.gmail.com>
 <20170424183137.GA27506@obsidianresearch.com> <CACaajQt8WZrCWXN5-JGovCcknwV9TKiy5gntzNmTjpmdxf6PJg@mail.gmail.com>
 <20170424201033.GA28656@obsidianresearch.com> <CACaajQsMdNt++M=DStZ+27km04xNRRxpbcrSGS9av_qtUgPJHA@mail.gmail.com>
 <20170425173912.GA6242@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425173912.GA6242-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2017-04-25 20:39 GMT+03:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
> and also how to implement user space access to hardware in your new
> language, this includes something like the C11 multi-threaded memory
> model, unlocked atomics, and processor specific memory barriers (that
> even C requires inline asm for)
>
> You may find implementing the above at all will always require some
> kind of C calls out..


=( pkay i'm try to stuck at C code now. And if i have some problems,
try to solve it

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
