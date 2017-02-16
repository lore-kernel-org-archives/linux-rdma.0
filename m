From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Wed, 15 Feb 2017 17:46:38 -0700
Message-ID: <CAANLjFqysktowbWZ2ch62vNL7N6ppQ3mPQ1uADRtC07wbQMbEA@mail.gmail.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
 <1487097898.2466.8.camel@sandisk.com> <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw@mail.gmail.com>
 <1487104602.2466.17.camel@sandisk.com> <CAANLjFonC2UJpCSgkuRXXGdUVEa7sg0Lb9tzHpxp0zM0vit+hg@mail.gmail.com>
 <CAANLjFqrKYdAyj-c0avvnjFEmiMuQ5zc5wYzuPmNjAHgZOUo4w@mail.gmail.com>
 <1487116271.2466.29.camel@sandisk.com> <CAANLjFp8ybkAwqHdoBXVtdCgnLXnqjxE-gewB4MMR-s3zj168g@mail.gmail.com>
 <1487132923.20239.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487132923.20239.2.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 14, 2017 at 9:32 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> Hello Robert,
>
> Are you using ZFS on Solaris or on Linux? In the last case, are you aware
> that the Linux NVMeoF target driver supports all block devices? That
> includes regular block devices SCSI devices and also the loop device. The
> last option allows to export a file through the NVMeOF target driver.

We are using ZFS on Linux. I did some reading and got NVMeoF working
on our RoCE cards using a loop device. It was surprisingly easy and I
didn't have any connection problems or D state issues. I'd like to
know how the performance compares to iSER, but this D state problem
prevents getting data on the iSER side.

Thanks for helping me understand that NVMeoF can use a regular block device.

Robert LeBlanc

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
