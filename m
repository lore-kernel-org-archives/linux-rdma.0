From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: PROBLEM: nvmet rxe : Kernel oops when running nvmf IO over
 rdma_rxe
Date: Sun, 2 Oct 2016 15:16:42 +0300
Message-ID: <e50c485a-00b0-e896-34de-856714fcb454@grimberg.me>
References: <1475179824-10377-1-git-send-email-sbates@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475179824-10377-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi All

Hey Stephen,

> So I thought I would try and run NVMe over Fabrics over
> Soft-RoCE. Both were adding to 4.8 so what could possibly go wrong
> ;-).

Obviously... :)

> Problem
> -------
>
> Kernel panics when attempting to run NVMe over Fabrics I/O over
> soft-RoCE.
>
> Interestingly nvme discover and connect seem to go well. In some cases
> I even seem to be able to issue some IO against the /dev/nvme0n1
> device on the host. However pretty quick I get a kernel oops on the
> target as shown below.

Hmm, does this crash happens even if there is no IO? probably
if not discover works well.

> My testing of soft-roce itself using userspace tools like ib_write_bw
> seem to be passing. So I am thinking the interaction between the
> kernel space interface for RXE and NVMf are not playing well
> together.

Thats a fair assumption...

> Oops Trace
> -----------
>
> I am including a couple of lines before the oops because I suspect
> they might be relevant. addr2line decodes the last addrss in the call
> trace as
>
> ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);

Hmm, How did you get to this line?
I got:
--
$ gdb drivers/nvme/target/nvmet-rdma.ko
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.04) 7.11.1
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from drivers/nvme/target/nvmet-rdma.ko...done.
(gdb) l *(nvmet_rdma_free_rsps+0x80)
0xa20 is in nvmet_rdma_free_rsps (drivers/nvme/target/rdma.c:430).
425		int i, nr_rsps = queue->recv_queue_size * 2;
426	
427		for (i = 0; i < nr_rsps; i++) {
428			struct nvmet_rdma_rsp *rsp = &queue->rsps[i];
429	
430			list_del(&rsp->free_list);
431			nvmet_rdma_free_rsp(ndev, rsp);
432		}
433		kfree(queue->rsps);
434	}
(gdb)
--

Anyway, this looks like a use-after-free condition. The strange thing
is that we don't see any queues being freed twice (we have a print
there)...

I suspect that either we have some problems with the draining logic in
rxe or, we uncovered a bug in nvmet-rdma that is triggered with rxe on
a VM (back when I tested this I didn't get this, so things must have
changed...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
