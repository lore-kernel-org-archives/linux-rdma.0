From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Thu, 11 Nov 2010 09:43:18 +0100 (CET)
Message-ID: <7059780.1289464998874.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <ibbr34$ima$1@dough.gmane.org> <20101109204452.GG909@obsidianresearch.com> <4538690.1289385043068.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <ibefrf$9qq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ibefrf$9qq$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Nov 10, 2010 05:05 PM, Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
wrote:

> On 11/10/10 10:30, Andrea Gozzelino wrote:
> > Hi Jonathan,
> >
> > I wrote down a test (latency and transfer speed) with RDMA.
> > Server and client work with the same code and they change defined
> > size
> > buffers for n times (loop). In the makefile.txt, you can find an
> > help to
> > use the code.
> >
> > I tested Intel NetEffect NE020 E10G81GP cards with this code and I
> > found
> > minimum latency about 11 us,maximum transfer speed about 9,6 GBytes,
> > CPU
> > usage up to 90% on client side.
> > The last value is not good for us.
> 
> Hi Andrea,
> 
> Thanks for the code. With the advice from Jason I have changed my test
> program to get reliable communication using 1Mbyte buffers. The CPU 
> usage is less than 2% on both client and server for 10Gb throughput. I
> have Chelsio S310CR.
> 
> I find using the poll() approach more natural as I have experience
> with
> conventional sockets based programming before.
> 
> The rdma_client/rdma_server example programs from librdmacm were the 
> easiest to start from and I have incrementally changed them from 
> synchronous to asynchronous operation, and moved the internals of the 
> high level functions in <rdma/rdma_verbs.h> into my own code piece by 
> piece. The learning curve is very steep :)
> 
> I found this paper quite interesting 
> www.systems.ethz.ch/research/awards/minimizingthehidden.pdf
> 
> Cheers,
> Jonathan.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Jonathan,

I would like testing my Intel NetEffect cards with your code, if it is
possible.
Could you please send me the files client/server and the compiling
commands?

Thank you very much for the pdf paper: I'm going to read it during the
morning.

Cheers,
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
