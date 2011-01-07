From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Thu, 6 Jan 2011 21:47:07 -0500
Message-ID: <ig5usq$tgi$1@dough.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm new to Infiniband and am trying to use a Mellanox MHES14-XTC with an
embedded AMCC PowerPC 440SPe on a custom board and a Denx 2.6.26 Linux
kernel.

Using the mthca driver from 2.6.26, I initially got various mapping errors.
The patch in the next note fixed these.  The problem is that the 440SPe uses
a 36-bit physical address on an otherwise 32-bit CPU.  This means it is
important to use the Linux "phys_addr_t" type, rather than "unsigned long"
(which is still 32-bits on this CPU).  "phys_addr_t" is 64-bits on this
platform and should work for all platforms, as far as I know.  I therefore
believe this patch has general value (correct me if I'm wrong!).

The other problem I had initially was a crash during the driver's install,
unless it was started with num_cq set to 2048 or 4096.  It appears the
default value for num_cq (65536) requires too much memory on this platform.
I'm not sure what the ramifications are when running with fewer "cqs".

With these changes, the driver loads fine on this hardware.  There are no
errors and the number and size of mapped areas matches my host Intel RH4.6
system (which I'm using for the subnet manager, et al).

I know the host Intel RH4.6 system is OK because I have a third MHES14-XTC
in a second host Intel RH5.4 system and everything works fine when the two
host Intel systems are connected (e.g. green and yellow LEDs come on both
cards, and I can establish an IPoIB connection between them).

But when I connect my 440SPe system to the Intel RH4.6 system, I only get
the green LED to light on each card (no yellow LED).  The Intel RH4.6
/var/log/osm.log shows:

-> umad_receiver: ERR 5409: send completed with error (method=0x1 attr=0x11
trans_id=0x3600001239) -- dropping
-> umad_receiver: ERR 5411: DR SMP Hop Ptr: 0x0
-> Received SMP on a 1 hop path:
Initial path = 0,0
Return path  = 0,0
-> __osm_sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error
(IB_TIMEOUT)

As far as I can tell, the 440SPe is OK.  That is, IRQs from the card have
been fielded during the driver's load, etc.  Here's the 440SPe's
/var/log/messages output from the driver's loading:

ib_mthca: Mellanox InfiniBand HCA driver v1.0 (April 4, 2008)
ib_mthca: Initializing 0000:16:00.0
ib_mthca 0000:16:00.0: enabling device (0000 -> 0002)
PCI: Enabling bus mastering for device 0000:16:00.0
FW version 000100020000, max commands 16
Catastrophic error buffer at 0x80e82a50, size 0x10
FW supports commands through doorbells
Mapped doorbell page for posting FW commands
FW size 5136 KB
Clear int @ 80ef00d8, EQ arm @ 80e61748, EQ set CI @ 80e72000
No HCA-attached memory (running in MemFree mode)
Mapped 21 chunks/5136 KB for FW.
Base MM extensions: no
Max ICM size 523264 MB
Max QPs: 16777216, reserved QPs: 1024, entry size: 256
Max SRQs: 1024, reserved SRQs: 64, entry size: 32
Max CQs: 16777216, reserved CQs: 128, entry size: 64
Max EQs: 64, reserved EQs: 1, entry size: 64
reserved MPTs: 16, reserved MTTs: 2
Max PDs: 8388608, reserved PDs: 4, reserved UARs: 1
Max QP/MCG: 8388608, reserved MGMs: 0
Max CQEs: 131072, max WQEs: 16384, max SRQ WQEs: 16384
Flags: 00370347
profile[ 0]--13/11 @ 0x               0 (size 0x20000000)
profile[ 1]--10/20 @ 0x        20000000 (size 0x 4000000)
profile[ 2]-- 0/16 @ 0x        24000000 (size 0x 1000000)
profile[ 3]-- 7/18 @ 0x        25000000 (size 0x  800000)
profile[ 4]-- 9/17 @ 0x        25800000 (size 0x  800000)
profile[ 5]-- 4/16 @ 0x        26000000 (size 0x  400000)
profile[ 6]-- 8/13 @ 0x        26400000 (size 0x  200000)
profile[ 7]-- 3/12 @ 0x        26600000 (size 0x   40000)
profile[ 8]--11/11 @ 0x        26640000 (size 0x   10000)
profile[ 9]-- 2/10 @ 0x        26650000 (size 0x    8000)
profile[10]-- 1/ 0 @ 0x        26658000 (size 0x    1000)
profile[11]-- 5/ 0 @ 0x        26659000 (size 0x    1000)
profile[12]-- 6/ 5 @ 0x        2665a000 (size 0x    1000)
profile[13]--12/ 0 @ 0x        2665b000 (size 0x    1000)
HCA context memory: reserving 629104 KB
629104 KB of HCA context requires 1240 KB aux memory.
Mapped 8 chunks/1240 KB for ICM aux.
Mapped page at 7b3a6000 to 2665a000 for ICM.
Mapped 1 chunks/256 KB at 20000000 for ICM.
Mapped 1 chunks/256 KB at 25800000 for ICM.
Mapped 1 chunks/256 KB at 24000000 for ICM.
Mapped 1 chunks/256 KB at 26000000 for ICM.
Mapped 1 chunks/256 KB at 26600000 for ICM.
Mapped 1 chunks/32 KB at 26650000 for ICM.
Mapped 1 chunks/256 KB at 26400000 for ICM.
Mapped 1 chunks/256 KB at 26440000 for ICM.
Mapped 1 chunks/256 KB at 26480000 for ICM.
Mapped 1 chunks/256 KB at 264c0000 for ICM.
Mapped 1 chunks/256 KB at 26500000 for ICM.
Mapped 1 chunks/256 KB at 26540000 for ICM.
Mapped 1 chunks/256 KB at 26580000 for ICM.
Mapped 1 chunks/256 KB at 265c0000 for ICM.
Memory key throughput optimization activated.
Allocated EQ 1 with 8192 entries
Allocated EQ 2 with 256 entries
Allocated EQ 3 with 256 entries
Setting mask 00000000001f43fe for eqn 2
Setting mask 0000000000000400 for eqn 3
NOP command IRQ test passed
Mapped page at 2fac2000 to bf000 for ICM.
Mapped page at 2fac1000 to 80000 for ICM.
Mapped 1 chunks/256 KB at 24040000 for ICM.
Mapped 1 chunks/256 KB at 25000000 for ICM.

I've tried various things (e.g. used a non-highmem Linux kernel, turned on
more of the debugging info in the driver) but I don't have any information
on how the Mellanox card is supposed to work so I don't know what aspect of
the 440SPe environment is unusual or wrong for its operation.  I think the
problem might be some kind of memory coherency issue (where the software
might not see that there is a pending event to process) but I don't really
have a clue as to what to do to confirm or deny this.  Alternatively, maybe
there's some subtle Endian issue?

Does anyone have any ideas as to what might be wrong in my environment?  Or
maybe suggestions as to how I should proceed to debug this?

Thanks very much for your help.

John Burr



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
