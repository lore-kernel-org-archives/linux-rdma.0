From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Setting RoCE to v2 automatically
Date: Wed, 22 Mar 2017 17:30:11 -0600
Message-ID: <CAANLjFqEeB6JM8pFDFcTRJCL9FPc4hUai45rNPf72rNb8g3NEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

How are people setting their adapters to use RoCEv2 automatically?
I've created a udev rule that creates the directory in configfs and
echos into default_roce_mode and it works fine if I run it with
'udevadm test', but on boot or module load it is not working (I do
have the udev rule in initrd and it is creating the VFs, and renaming
the adapters from my other rules). I was trying to get it all done
through udev so that it happens when the module is loaded or at boot.
We are not using OFED and the 4.9.14 kernel on CentOS 7.2.

My current rule is:
ACTION=="add", SUBSYSTEM=="net", ATTR{type}=="1",
ATTRS{subsystem_vendor}=="0x15b3", \
ATTRS{device}=="0x101?", WAIT_FOR="/sys/kernel/config/rdma_cm", \
   PROGRAM=="/bin/sh -ec 'D=$(ls /sys$DEVPATH/device/infiniband); \
       C=/sys/kernel/config/rdma_cm; if [ ! -d $C/$D ]; \
       then mkdir $C/$D; fi; \
       echo RoCE v2 > $C/$D/ports/1/default_roce_mode'"

I've tried a variation using the infiniband subsystem, but it had the
same result.

Any ideas?

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
