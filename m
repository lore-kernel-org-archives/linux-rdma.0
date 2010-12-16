From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RE: Intel NetEffect NE020 E10G81GP use
Date: Thu, 16 Dec 2010 17:13:08 +0100 (CET)
Message-ID: <5454582.1292515988824.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <4438953.1292407689320.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <70B82AB4096EC24DAE01A7202D27B68B010B6D4819@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <70B82AB4096EC24DAE01A7202D27B68B010B6D4819-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jaszcza, Andrzej" <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I wrote about RDMA over TCP/IP (iWARP).
Today I have installed mvapich2-1.6rc1 and openmpi-1.4.3 on my machine.

I don't know a lot about MPI code.
I just try run hello file from example folder.

[root@redigo-01 examples]# ls
connectivity_c.c hello_c.c hello_f77.f Makefile README ring_cxx.cc
ring_f90.f90
hello hello_cxx.cc hello_f90.f90 Makefile.include ring_c.c ring_f77.f
[root@redigo-01 examples]# pwd
/root/openmpi-1.4.3/examples

COMMAND LINE:
A) [root@redigo-01 examples]# mpiexec -n 6
/root/openmpi-1.4.3/examples/cpi
problem with execution of /root/openmpi-1.4.3/examples/cpi on
redigo-01.lnl.infn.it: [Errno 2] No such file or directory

B) [root@redigo-01 examples]# mpirun rsh redigo-01.lnl.infn.it_59240
hello
redigo-01.lnl.infn.it_59240: host unknown
redigo-01.lnl.infn.it_59240: host unknown
trying normal rsh (/usr/bin/rsh)
redigo-01.lnl.infn.it_59240: Unknown host


I write the mod.conf (as root user) file and I put it with correct
permissions in /etc directory.

I don't understand where is my error? 

Could you help me with these first steps in MPI?

Thank you very much.
Regards,
Andrea



On Dec 15, 2010 10:45 PM, "Jaszcza, Andrzej" <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
wrote:

> Hi Andrea,
> 
> I think you meant RDMA over TCP/IP (iWarp) and not RDMA over Converged
> Ethernet (RoCE) as Intel NetEffect cards do not support the latter.
> You may safely try to run any MPI benchmarks using MVAPICH2, Open MPI
> or Intel MPI. There is more information on iWarp, Intel NetEffect
> cards and their possible uses on Intel website:
> http://www.intel.com/technology/comms/iwarp/index.htm.
> 
> Regards,
> Andrzej
> 
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Andrea
> Gozzelino
> Sent: Wednesday, December 15, 2010 11:08 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Intel NetEffect NE020 E10G81GP use
> Importance: High
> 
> Hi all,
> 
> I have tested two cards Intel NetEffect NE020 E10G81GP with RDMA over
> Ethernet; results are OK in latency and bandwidth.
> Are there other protocols supported by cards,that offer the same
> performances?
> (TCP Offload, STORAGE, MPI). 
> Socket Direct Protocol (SDO) is not good for those performances. 
> Any suggestions about using cards with high performances?
> What are benefits using these cards in daily storage and data movement
> operations?
> 
> Thank you.
> Best regards,
> 
> Andrea Gozzelino
> 
> INFN - Laboratori Nazionali di Legnaro	(LNL)
> Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
> Office: E-101
> Tel: +39 049 8068346
> Fax: +39 049 641925
> Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
> Cell: +39 3488245552				
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
> 
> Sad Rejonowy Gdansk Polnoc w Gdansku, 
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
> numer KRS 101882
> 
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 


Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
