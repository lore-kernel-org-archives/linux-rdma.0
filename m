From: Eva <wuzhh01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rdma hangs on =?utf-8?b?cG9sbF9kZXZpY2UoKQ==?= while tcp is correct
Date: Thu, 21 Jan 2016 06:31:15 +0000 (UTC)
Message-ID: <loom.20160121T072936-849@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Run MPI_Send on MPI1.8.5 without multithread enabled:
it hangs on mca_pml_ob1_send() -> opal_progreses() -> 
btl_openib_component_progress() -> poll_device() -> libmlx4-rdmav2.so -> cq -> 
phread_spin_unlock
The program can run on TCP with no error.

Details:
I run with two machines, 2 process per node: process0, process1, process2, 
process3.
After some random rounds of communications, the communication hangs. When I 
debug into the program, I found:
process1 sent a message to process2; 
process2 received the message from process1 and then start to receive messages 
from other processes. 
But process1 doesn't get notice: process2 has received its message and then 
hang on MPI_Send->...->poll_device() of rdmav2.

#0  0x00007f6ba95f03e5 in ?? () from /usr/lib64/libmlx4-rdmav2.so
#1  0x00007f6bacf1ed93 in poll_device () from /home/openmpi-1.8.5-
gcc4.8/lib/openmpi/mca_btl_openib.so
#2  0x00007f6bacf1f7ed in btl_openib_component_progress () from /home/openmpi-
1.8.5-gcc4.8/lib/openmpi/mca_btl_openib.so
#3  0x00007f6bb06539da in opal_progress () from /home/openmpi-1.8.5-
gcc4.8/lib/libopen-pal.so.6
#4  0x00007f6bab831f55 in mca_pml_ob1_send () from /home/openmpi-1.8.5-
gcc4.8/lib/openmpi/mca_pml_ob1.so
#5  0x00007f6bb0df33c2 in PMPI_Send () from /home/openmpi-1.8.5-
gcc4.8/lib/libmpi.so.1

Some experiments I have tried:
1. compile openmpi without multi-thread enable
2. --mca pml_ob1_use_early_completion 0
3. disable eager mode
4. ssend, Bsend

but it still hangs.

The same program works fine on TCP for more than one year. After I move it onto 
rdma, it starts to hang. And I can't debug into any rdma details

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
