From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Trying to link with DAT 2.0 function
Date: Mon, 11 Oct 2010 14:00:10 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011B575529@orsmsx506.amr.corp.intel.com>
References: <1F77938CC2143D47AE7204B1DB33104C02C9FC57@XMBIL151.northgrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1F77938CC2143D47AE7204B1DB33104C02C9FC57-/R8ruR6G1fHgAiKnVY1dJgQSgKfZeEaX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I'm trying to create a shared library that uses the function
>dat_cno_fd_create(), but I find that I get an "undefined symbol" error
>when I compile a test executable which links with my shared library.

Sorry, while this new call was defined in the DAT 2.0 specification, 
it has not yet been implemented in the latest library.  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
