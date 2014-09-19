From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Fri, 19 Sep 2014 17:08:09 +0200
Message-ID: <CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A@mail.gmail.com>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com>
 <541C380B.1000803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541C380B.1000803-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Bart,

Thank you very much for quick reply. I tried you test program with:

=2E/discontiguous-io -l 4096 -o 1024 -s -w /dev/sdb

The program just wait there, and strace show it hang at read:

munmap(0x7fb074c10000, 24430)           =3D 0
brk(0)                                  =3D 0x1896000
brk(0x18b8000)                          =3D 0x18b8000
open("/dev/sdb", O_RDONLY)              =3D 3
ioctl(3, BLKSSZGET, 0x6066e0)           =3D 0
fstat(0, {st_mode=3DS_IFCHR|0600, st_rdev=3Dmakedev(136, 0), ...}) =3D =
0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7fb074c16000
read(0,

ib_srp load with cmd_sg_entries=3D255, target side use ib_srpt from svn
1 month ago.

Kernel is 3.14.13

lsscsi
[0:0:0:0]    disk    ATA      ST3750528AS      CC38  /dev/sda
[1:0:0:0]    disk    SCST_BIO vol0              310  /dev/sdb
[1:0:0:1]    disk    SCST_BIO vol1              310  /dev/sdc

Regards,
Jack



On Fri, Sep 19, 2014 at 4:04 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> w=
rote:
> On 09/19/14 15:11, Jinpu Wang wrote:
>>
>> During go through SRP FMR support, I found ib_srp pre-alloc
>> fmr_list/map_page in each request,
>> fmr_list are alloced as many as target->cmd_sg_cnt
>>
>> I add some debug message when run fio test with different settings.
>> Result show, state.ndesc and state.nmdesc is 1, state.npages is 0,
>> after srp_map_sg,
>> my question is : do we really need as many cmd_sg_cnt fmr_list, or I
>> miss something,  ndesc and nmdesc could be bigger than 1?
>
>
> Hello Jack,
>
> The limitations for FMR / FR memory registration are more restrictive=
 than
> those imposed by the SCSI core on S/G-list layout. A few examples:
> * Memory registered via FMR must be aligned on an FMR page boundary.
> * Memory registered via a single FMR / FR registration must be a cont=
iguous
> virtual memory region.
> * The maximum size for a memory region registered via FMR or FR
> (dev->mr_max_size) can be below the maximum size of an S/G-list that =
can be
> passed by the SCSI core.
>
> Hence the need for multiple memory descriptors. In case you are wonde=
ring
> how I tested memory registration involving multiple memory descriptor=
s: I
> wrote a test program that causes the SCSI core to send an S/G-list to=
 the
> SRP initiator that consists of 128 elements with four bytes of data. =
None of
> these elements are aligned on a page boundary and no two S/G-list ele=
ments
> are contiguous in virtual memory. This test program causes the SRP in=
itiator
> to allocate 128 memory descriptors. Please note that I/O requests sub=
mitted
> by the attached test program will only be accepted by the SRP initiat=
or if
> the cmd_sg_entries kernel module parameter has been set to a value >=3D=
 128.
>
> Bart.
>



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
