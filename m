From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: about cxgb3 and cxgb4
Date: Thu, 22 Jul 2010 08:43:21 -0500
Message-ID: <4C484AF9.7010909@opengridcomputing.com>
References: <3669127.1279790079150.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3669127.1279790079150.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Andrea Gozzelino wrote:
> Hi all,
>
> I ask you an opinion about RDMA driver cxgb3 and cxb4.
>
> I installed two NetEffect Intel cards on machines with OS Linux and
> driver cxgb3. Please see the detail below:
>
>   

cxgb3/4 is for the Chelsio T3/T4 hardware, not the NetEffect/Intel hardware.

You want iw_nes.ko.

Steve,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
