From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
Subject: RE: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Date: Mon, 10 Oct 2011 11:57:55 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A48888433C0838@AVEXMB1.qlogic.org>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F683D.9020604@xenotime.net>
 <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dept_Infinipath <Dept_Infinipath@qlogic.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

As do I.

I've confirmed that patch does no harm, but I would like to see the error.

Which of the github repos exposes the error?

Mike

> -----Original Message-----
> From: Roland Dreier [mailto:roland@purestorage.com]
> Sent: Friday, October 07, 2011 5:21 PM
> To: Randy Dunlap
> Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel;
> Dept_Infinipath; linux-rdma@vger.kernel.org; Andrew Morton
> Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build
> errors
>
> On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net>
> wrote:
> > Add <linux/stat.h> to fix build errors:
>
> When did this break?  I build ipath in my test config all the time...
>
>  - R.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
