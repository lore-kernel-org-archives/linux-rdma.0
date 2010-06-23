From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Name for a new type of QP
Date: Wed, 23 Jun 2010 14:27:24 +0300
Message-ID: <4C21EF9C.1020304@voltaire.com>
References: <4C21D1AA.8060402@Voltaire.COM>	<BE2BFE91933D1B4089447C64486040801E9D892A@irsmsx503.ger.corp.intel.com> <7E95F01E94AB484F83061FCFA35B39F868D9D2@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F868D9D2-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Alex Rosenbaum wrote:
> I never fully understood what does IBV_QPT_RAW_ETY stand for? Maybe we should change its name to better represent what the code does.
before, maybe take a look on the IB spec... see the spec references 
mentioned by the patch to support IB_QPT_RAW_ETY which posted to the 
list in the past, but didn't make it to upstream yet @ 
http://lists.openfabrics.org/pipermail/general/2008-December/055954.html

Also, IBA  chapter 2, states that "Raw Datagram - A packet that contains 
an IBA Local Route Header, may contain an IBA Global Route Header, but 
does not contain an IBA Transport header, and is not handled by IBA 
transport services",
&& chapter 3, section 3.6.2 "IBA TRANSPORT SERVICES" explains everything 
in detail, including what is the difference between raw ethernet to raw 
ipv6, look for "The Raw Datagram service is not technically a transport 
but rather it is a data link service that allows a QP to send and 
receive raw datagram messages" and following text.

Or.





Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
