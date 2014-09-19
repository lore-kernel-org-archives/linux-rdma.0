From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Fri, 19 Sep 2014 17:14:35 +0200
Message-ID: <541C485B.60302@acm.org>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com> <541C380B.1000803@acm.org> <CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/19/14 17:08, Jinpu Wang wrote:
> Thank you very much for quick reply. I tried you test program with:
>
> ./discontiguous-io -l 4096 -o 1024 -s -w /dev/sdb
>
> The program just wait there, and strace show it hang at read:
>
> munmap(0x7fb074c10000, 24430)           = 0
> brk(0)                                  = 0x1896000
> brk(0x18b8000)                          = 0x18b8000
> open("/dev/sdb", O_RDONLY)              = 3
> ioctl(3, BLKSSZGET, 0x6066e0)           = 0
> fstat(0, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x7fb074c16000
> read(0,
>
> ib_srp load with cmd_sg_entries=255, target side use ib_srpt from svn
> 1 month ago.
>
> Kernel is 3.14.13
>
> lsscsi
> [0:0:0:0]    disk    ATA      ST3750528AS      CC38  /dev/sda
> [1:0:0:0]    disk    SCST_BIO vol0              310  /dev/sdb
> [1:0:0:1]    disk    SCST_BIO vol1              310  /dev/sdc

Hello Jack,

Did you know that file descriptor 0 corresponds to stdin ? With 
command-line option -w the test program reads data from stdin and sends 
that data to a SCSI device. I think the test program is waiting for you 
to provide input data :-)

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
