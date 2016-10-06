From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RDMA developer gatherings around Kernel Summit and Linux Plumbers
 in Santa Fe
Date: Thu, 6 Oct 2016 13:19:07 -0700
Message-ID: <e6b8a6e9-19cd-dbe0-e885-995b91c55137@sandisk.com>
References: <E82DA475-17F6-461C-A927-66AE4AE22D72@ccn-mail.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E82DA475-17F6-461C-A927-66AE4AE22D72-K3XgeB3KlJxL3NSqSJqx7PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/06/2016 11:33 AM, Coulter, Susan K wrote:
> The OFA’s position is that we have some member companies that require
 > dual license in order to offer products and solutions that repackage
 > OFS software on non-Linux OSs.  We are in the process of finding out
 > from those members what bits are critical to that re-packaging.  We
 > also believe, contrary to your understanding, that we cannot force dual
 > license on the entire RDMA kernel subsystem.

Hello Susan,

Thank you for having clarified the position of the OFA.

What is not clear to me is what are these products and who are these 
companies? And why do these companies think that they need a BSD 
license? If the Linux RDMA code that is repackaged is built as a 
separate module then they don't need the BSD license. GPL should be 
fine. Run-time loading of kernel modules creates what is considered as a 
collective work under copyright law. The "viral" property of GPL only 
applies to derivative works. A collective work is not the same as a 
derivative work. This is explained in detail by several authors. E.g. 
Lawrence Rosen explains this in his book "Open Source Licensing", 
Software Freedom and Intellectual Property Law, Prentice Hall, 2004 
(http://www.rosenlaw.com/oslbook.htm).

Please note that the above is my own opinion and has not been reviewed 
by the corporate legal team.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
