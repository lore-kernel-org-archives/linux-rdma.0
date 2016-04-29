From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 01:13:07 +0000 (UTC)
Message-ID: <pan$583bc$3e721561$9d7dc567$cdf52f56@googlemail.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
	<5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
	<CAANLjFo2Riv3anBg99CCd2E_9gmZHrL93ZNT2Od58GMw+TPHpw@mail.gmail.com>
	<CAANLjFrRdcWbC5butmFe29OFZep9RJ-najPAOAq965Y0Jb=i8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Apr 2016 17:39:23 -0600, Robert LeBlanc wrote:

> Looks like quite a bit has changed especially with
> b7d3e0a94fe128912bbebf0ae68551c85fd2d429 causing those patches to not
> apply cleanly. I'm trying to get this to work on 4.5+, but having
> trouble getting this all figured out (not being a programmer and not
> extremely familiar with the inner workings of RDMA. If someone has a
> newer patch set, I'd like to do some testing.

I have no idea whether it works, but the rxe_submission_v8 branch in
the Github upstream repo (https://github.com/SoftRoCE/rxe-dev) looks
up-to-date and is based on top of kernel 4.5, so that will probably be
the easiest path to get anywhere. I haven't tried myself yet, so good
luck. :)

-h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
