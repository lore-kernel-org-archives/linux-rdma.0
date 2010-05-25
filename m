From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: sdp and port 0
Date: Tue, 25 May 2010 11:04:06 +0200 (CEST)
Message-ID: <803144.1274778246034.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <1274178031.6513.22.camel@spike.ugent.be> <4BFB8B8A.6080205@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFB8B8A.6080205-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stijn De Weirdt <stijn.deweirdt-Cru1EgDzd7c@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,
Hi Stijn,

I would like to integrate Amir's information about an old discussion.
In April I have tested SDP with Neteffect cards with OFED 1.5.1 and OFED
1.5.2 without success. I have open two bug on Bugzilla (number 2027 and
2028 --> LINK:https://bugs.openfabrics.org/).
The first is closed thanks to Amir. 
On the second one, Steve will work in July.

Stijn, you can find our old discussion about SDP under the subject-title
"Socket Direct Protocol: help(2)" and "BUG 2027 / 2028" (something like
that).
I have also posted some information on the blog link below:

http://nixcraft.com/linux-software/14686-socket-direct-protocol-netperf.html#post25324

I don't know if those information help you, but I think it's important
read and understand more about SDP.

Can I ask you why do you use SDP in your activity?

Thanks again to Amir.
Regards,
Andrea

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org	



On May 25, 2010 10:34 AM, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:

> Stijn Hi,
> 
> Listening to port 0 is supported and should work.
> Which OFED version do you use (issue ofed_info to know)?
> 
> Does it work for you on a simple test application that only listen on
> a socket?
> 
> - Amir
> 
> 
> On 05/18/2010 01:20 PM, Stijn De Weirdt wrote:
> > hi all,
> >
> > (i'm not on the list, please keep me in cc)
> >
> > i am trying SDP with some executable (i don't have the source), but
> > i'm
> > getting errors with the bind step (output from strace):
> >
> > bind(20, {sa_family=AF_INET, sin_port=htons(0),
> > sin_addr=inet_addr("1.2.3.4")}, 16) = -1 EADDRINUSE (Address already
> > in
> > use)
> >
> > is it possible that a bind to port 0 (ie ask system for free port)
> > is
> > not supported with libsdp?
> >
> > using 'both' as addressfamily in the configfile instead of 'sdp'
> > works
> > but the tcp is used.
> > i also tried to add a portrange to avoid port 0 with sdp (ie tcp for
> > port 0, sdp for the rest), but this doesn't work either (which is
> > not
> > that surprising).
> >
> >
> > thanks a lot,
> >
> > stijn
> >   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


		

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
