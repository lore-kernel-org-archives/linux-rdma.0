From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm 1.0.12
Date: Tue, 25 May 2010 15:36:11 +0200 (CEST)
Message-ID: <79817.1274794571169.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CE35DBA4CC524BD3BDA61C7DE2BD39CD-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 22, 2010 01:06 AM, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I've pushed out release 1.0.12 of librdmacm. This incorporates several
> new APIs
> that should make connecting and transferring data over RDMA devices
> simpler for
> user applications, plus adds support for user space path record
> caching.
> 
> New APIs include simple wrappers for common verbs operations, such as
> memory
> registration, posting of work requests, and retrieving completions.
> Support for
> synchronous connection establishment was added, along with newer calls
> that
> combine the work done using multiple existing calls. To help address
> MPI
> scaling issues, this release provides support for IB ACM path record
> caching
> capabilities, enabled through the use of a compile time option. New
> client and
> server test applications were also added to demonstrate the use of the
> new APIs.
> 
> (Note that the source code includes changes for AF_IB support, but
> AF_IB has
> been disabled in the code to avoid potential ABI compatibility issues
> until the
> kernel changes have been accepted upstream.) This version wants the
> soon to be
> released version of libibverbs, but will work with older versions
> installed.
> 
> Please pull this release into OFED 1.5.2. I will provide a set of
> release notes
> next week.
> 
> - Sean
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Sean,
Hi Arlin,

I'm very interesting about librdmacm.

I'm working on Intel Net Effect NE020 cards from February 2010 for an
INFN experimental proposal, called REDIGO (Read out at 10 Gbits/s),
about the data
acquisition and movement systems. The covergence of storage protocols
around 10 Gigabits/s Ethernet protocols shows that one way could be the
Remote Direct Memory Access (RDMA). The goals are the investigations of
latency time, the throughput, the buffer size schemes and finally the
global event building bandwidth.
I explore different ways as TCP, SDP, RDMA, FCoE, MPI, excluded
Infiniband.

Actually I transfer data (read/write) in a server/client system with
RDMA. The transfer speed measured is about 1.17 Mbytes/s (93% of
designed bandwith). I try to measure the latency, but I have a TCP
socket as syncronization actor and the measure is not "clean". The card
nominal latency value is 6 us.

I'm not an expert of code, but I read this thread and I understand that
new librdmacm version will be easier for users.

I will wait your release notes to know if librdmacm 1.0.12 is better for
my test configuration and simplier in performance evaluation.

Thank you very much.
Keep in touch,
Andrea


Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
