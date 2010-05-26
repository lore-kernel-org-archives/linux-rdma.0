From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] librdmacm 1.0.12
Date: Wed, 26 May 2010 13:58:24 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F2B9399@orsmsx501.amr.corp.intel.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
 <79817.1274794571169.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <79817.1274794571169.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm not an expert of code, but I read this thread and I understand that
> new librdmacm version will be easier for users.

New APIs were added to the librdmacm that make it easier for a developer to establish a connection over an RDMA device.  Additionally, wrappers were added around several of the verbs calls to make it easier to post work requests.  Man pages were added for the newer connection related interfaces, and two additional sample applications were added to demonstrate their use.

See: rdma_create_ep, rdma_getaddrinfo, rdma_destroy_ep calls, and
     rdma_server, rdma_client apps
The wrapper calls are in rdma/rdma_verbs.h

Most of the concepts were based on feedback from MPI developers and students who needed easier interfaces to use and understand, with some specific ideas pulled in from an libiwarp helper library developed by Philip Frey.

For the most part, you can mix new interfaces calls with lower level verbs calls as needed by your application.

I'm still 1-2 weeks away from writing up the release notes.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
