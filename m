From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA version of select for multiplexing rdma connections?
Date: Fri, 22 Oct 2010 22:28:37 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7E8@orsmsx501.amr.corp.intel.com>
References: <AANLkTikPStczJpRo9va7Q=rj0C+gwwq0X0kOUKDBKN34@mail.gmail.com>
 <20101022220644.GC15514@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101022220644.GC15514-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Adit Ranadive <adit.262-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If you want to do non-blocking accept .. I'm not sure that is possible
> with RDMA CM. 

non-blocking 'accept' functionality can be achieved by using get_event and select/poll on the associated fd. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
