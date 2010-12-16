From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Intel NetEffect NE020 E10G81GP use
Date: Thu, 16 Dec 2010 09:46:10 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904B957A56C@azsmsx506.amr.corp.intel.com>
References: <4438953.1292407689320.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <70B82AB4096EC24DAE01A7202D27B68B010B6D4819@irsmsx503.ger.corp.intel.com>
 <5454582.1292515988824.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5454582.1292515988824.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Jaszcza, Andrzej" <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> [root@redigo-01 examples]# ls
> connectivity_c.c hello_c.c hello_f77.f Makefile README ring_cxx.cc
> ring_f90.f90
> hello hello_cxx.cc hello_f90.f90 Makefile.include ring_c.c ring_f77.f
> [root@redigo-01 examples]# pwd
> /root/openmpi-1.4.3/examples
> 
> COMMAND LINE:
> A) [root@redigo-01 examples]# mpiexec -n 6
> /root/openmpi-1.4.3/examples/cpi
> problem with execution of /root/openmpi-1.4.3/examples/cpi on
> redigo-01.lnl.infn.it: [Errno 2] No such file or directory

You don't have cpi in /root/openmpi-1.4.3/examples directory.  Try running hello instead.

Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
