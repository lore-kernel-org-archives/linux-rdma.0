From: Philip Frey <philip.frey-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Subject: Re: Simplified iWARP Consumer Library
Date: Tue, 16 Feb 2010 08:28:16 +0100
Message-ID: <4B7A4910.6070703@inf.ethz.ch>
References: <4B796BBD.5050007@inf.ethz.ch> <4B7A2CF8.1070002@voltaire.com>
Reply-To: philip.frey-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B7A2CF8.1070002-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear all,

I was made aware of the fact that the general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org mailinglist 
was deprecated and that my initial post about the iWARP library did not reach 
you. (The general list is still linked on openfabrics.org without a notice of it 
being deprecated.)

Please, find below a copy of the original message.

"Dear all,

throughout the course of my PhD, I have written a number of user applications 
based on the OFED verbs. After some time, I realized that many programming tasks 
are repetitive (particularly the connection management) and started to wrap them.

This eventually led to a slim, shared library called libiwarp which includes all 
the basic primitives of RDMA-based communication, implemented as wrappers around 
libibverbs. Throughout various research projects, the library has turned out to 
be quite useful especially for people who are not familiar with all the details 
of the OFED verbs (like master students that only have 6 months to complete 
their projects or people that simply want to play around with iWARP and run a 
few simple tests).

We have shown, by experiment, that the overhead induced by the wrappers is 
negligible, yet it simplifies writing RDMA-based applications significantly. 
Furthermore, as the library does not replace the OFED verbs, it does not impose 
any restrictions with regard to the original functionality. Whenever there is 
something missing in the libiwarp, you can always use the interface provided by 
the OFED verbs.

As I am now in the process of finishing my work, I was wondering whether there 
is an interest in the OpenFabrics community for such a library which provides a 
simplified interface for the OFED verbs. If there is, I would be glad to share 
my source code with you.

Many thanks for your consideration and best regards,
  Philip"

Or Gerlitz wrote:
> Philip Frey wrote:
>> as announced last week (on general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org) [...] I 
>> would be very interested in your feedback!
> The general list isn't functional since last fall, as of such, your 
> announcement wasn't seen by any of the non directly CCed recipients... 
> can you please resend it here (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)?
> 
> Or.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
