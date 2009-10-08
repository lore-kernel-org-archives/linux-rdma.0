From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Fri, 9 Oct 2009 01:33:56 +0200
Message-ID: <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
	 <4ACAF913.3050909@voltaire.com>
	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
	 <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>
	 <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>
	 <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0A383504E0E54C949DEF84405E3AE92F-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>When used over IB, the IP address is little more than a qualifier con=
tained
>>within the IB CM REQ private data.
>
> If we added support for AF_GID/AF_IB to the kernel, the rdma_cm could=
 leave all
> of the private data carried in the IB CM REQ entirely up to the user.=
 =A0If the
> user happens to format that data to look like the CMA header, so be i=
t. =A0I
> believe this would allow for a 'clean' implementation of rdma_resolve=
_addr,
> preserve the ABI, and still allow a library to provide backwards comp=
atibility.

Sean,

So in this design librdmacm will change the user supplied AF_XXX in
the provided sock address and set it to AF_GID/IB, sounds okay.

> Would this approach combined with the ability to set the route work f=
or everyone?

yes, it makes sense.

However, I don't manage to follow on your port space discussion with
Jason. Some apps may have client in user space and server in the
kernel or vise versa. I wouldn't tie PS_IB or a like with ACM. The ACM
ARP replacement protocol will reply only if the ip address specified
in the broadcast request is an ip of this host on that pkey and a port
connected to that fabric, correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
