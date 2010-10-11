From: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>
Subject: RE: EXTERNAL:RE: Trying to link with DAT 2.0 function
Date: Mon, 11 Oct 2010 16:04:16 -0500
Message-ID: <1F77938CC2143D47AE7204B1DB33104C02C9FD0E@XMBIL151.northgrum.com>
References: <1F77938CC2143D47AE7204B1DB33104C02C9FC57@XMBIL151.northgrum.com> <E3280858FA94444CA49D2BA02341C983011B575529@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <E3280858FA94444CA49D2BA02341C983011B575529-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks for your response! I suspected that this might be the case...

Do you have a roadmap available? Is this planned to be implemented in
the near future?

-----Original Message-----
From: Davis, Arlin R [mailto:arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, October 11, 2010 5:00 PM
To: Young, Eric R.; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: EXTERNAL:RE: Trying to link with DAT 2.0 function

>I'm trying to create a shared library that uses the function
>dat_cno_fd_create(), but I find that I get an "undefined symbol" error
>when I compile a test executable which links with my shared library.

Sorry, while this new call was defined in the DAT 2.0 specification, 
it has not yet been implemented in the latest library.  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
