From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: How to build a kernel module with OFED kernel
Date: Fri, 18 Feb 2011 14:31:54 -0600
Message-ID: <4D5ED73A.90508@opengridcomputing.com>
References: <AANLkTimYRJNarSSTArd0P04Fpc00ne7QVU2=ShCOp7kW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimYRJNarSSTArd0P04Fpc00ne7QVU2=ShCOp7kW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To get rid of the symbol mismatch warnings and not force the mod load, pull the Module.symvers from /usr/src/ofa_kernel/ 
and use that instead of the default on in the kernel build tree.

Also, you'll need to include the ofa headers over the backing kernel headers.  Its kind of painful to do.  You can look 
at my krping tree for some ideas.  krping can build it two modes:  it gets built as an out-of tree module, like what 
you're doing, or it also has a build mode where you place the krping src code inside the ofa kernel tree and build it 
there using the ofa kernel Makefiles.  The latter is pretty easy to do.  The former method really doesn't work very well 
for krping.

git://git.openfabrics.org/~swise/krping.git


Steve.




On 02/18/2011 12:59 PM, Wendy Cheng wrote:
> A newbie question ..... (please cc me as I'm not on linux-rdma list yet)
>
> The system was on RHEL 5.4. I used a source tar-ball to build RHEL 5.5
> (2.6.18-194.el5). The kernel build was placed at: /usr/src/linux.
> Rebooted to pick up the new kernel .. worked fine... Then
>
> 1. On the new 2.6.18-192.el5 system, install OFED-1.5.2 ... succeed.
> 2. Reboot to pick up new ofa kernel ..succeed (check with modinfo)
> 3. Run user mode rdma application ... succeed
> 4. The new ofa kernel modules are placed (by OFED scripts) at:
>      /lib/modules/2.6.18-194.el5/updates/ directory
> 5. Build a kernel module (xx.ko) using the attached Makefile
>
> Now .. trying to load (or run after forced loading) xx.ko (on top of
> ofa kernel kmod(s)) ..   It fails .. as the build apparently picks up
> IB kmods from
> /lib/modules/2.6.18-194.el5/drivers/infiniband directory, instead of
> /lib/modules/2.6.18-194.el5/updates directory, together with wrong
> header files from
> /lib/modules/2.6.18-194.el5/source/include, where source is
> /usr/src/linux directory.
>
> Anyone can help me with a correct procedure ?
>
> I do understand the primary usage of OFED RDMA is for user mode
> applications .. but I need to have a kernel mode driver on top of OFED
> RDMA for some experiment works.
>
> Thanks,
> Wendy
>
> == Make File ==
>
> EXTRA_CFLAGS    := -I/usr/src/linux/drivers/xx/include
> EXTRA_CFLAGS    += -DXX_KMOD_DEF
>
> obj-m           := xx_kmod.o
>
> xx_kmod-y       := main/xx_main.o main/xx_init.o \
>                     libxxverbs/xx_device.o libxxverbs/xx_cm.o \
>                     libxxverbs/xx_ar.o libxxverbs/xx_mr.o \
>                     libxxverbs/xx_cq.o libxxverbs/xx_sq.o
>
> xx_kmod-y       += util/xx_perf.o
> xx_kmod-y       += brd/xx_brd.o
>
> kmod:
>          make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
>
> install:
>          make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules_install
>
> run:
>          /sbin/depmod -a; echo 5>  /proc/sys/kernel/panic; modprobe
> --force-modversion xx_kmod
>
> === End attachment ===
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
