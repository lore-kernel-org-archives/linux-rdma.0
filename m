From: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>
Subject: FW: Trying to link with DAT 2.0 function
Date: Mon, 11 Oct 2010 14:05:41 -0500
Message-ID: <1F77938CC2143D47AE7204B1DB33104C02C9FC57@XMBIL151.northgrum.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm trying to create a shared library that uses the function
dat_cno_fd_create(), but I find that I get an "undefined symbol" error
when I compile a test executable which links with my shared library.

Doing an "nm" on the libdat2.so I see that this function (along with
csp_create, csp_query, csp_free, dat_rmr_create_for_ep, etc.,) are all
listed with 't', meaning that the symbol is in text but is not global. 

1.) Why are those symbols not global (T)?
2.) What can I do so that I can link with "dat_cno_fd_create" for my
shared library and test app?

Thanks,
Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
