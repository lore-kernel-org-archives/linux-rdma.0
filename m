From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: PSM and OpenMPI
Date: Fri, 29 Apr 2011 12:39:28 -0400
Message-ID: <BANLkTi=m98+HZ4F8sqHo+-RTVoQWGwKz4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the meantime, while i'm waiting for some contacts at Qlogic to get
back to me, does anyone on the list have any idea what we might be
running up against here?

OpenMPI 1.5.3 w/ PSMkey patch
Slurm 2.2.4
Ofed 1.5.2
Rhel 5.6 (stock kernel)

You can see this mailing list thread for details:
http://www.open-mpi.org/community/lists/users/2011/04/16394.php

but here's the meat...

mpirun -n 2 -host node1 <prog>

and my <prog> runs just fine, However if i do

srun --resv-ports -n 2 -w node1 <prog>

I get

[node1:16780] PSM EP connect error (unknown connect error):
[node1:16780]  node1
[node1:16780] PSM EP connect error (Endpoint could not be reached):
[node1:16780]  node1

PML add procs failed
--> Returned "Error" (-1) instead of "Success" (0)

I did notice a difference in the precondition env variable between the two runs

mpirun -n 2 -host node1 <prog>

sets precondition_transports=fbc383997ee1b668-00d40f1401d2e827 (which
changes with each run (aka random))

srun --resv-ports -n 2 -w node1 <prog>

sets precondition_transports=0000184500000000-0000000100000000 (which
doesn't seem to change run to run)

Can anyone decode the PSM EP and PML errors?  Is there any rhyme to
the psm key being random of some type over just a few values
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
