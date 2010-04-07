From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 22/37] librdmacm: add new call to create id
Date: Wed, 7 Apr 2010 12:42:53 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF254BDAE1C4@orsmsx501.amr.corp.intel.com>
References: <F818D641D3E64DA197E789362F5F0222@amr.corp.intel.com>
 <20100407193402.GH15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100407193402.GH15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> + *   The rdma_cm_id will be set to use synchronous operations (connect,
>> + *   listen, and get_request).  To convert to synchronous operation, the
>                                               ^^^^^^^^^
>asynchronous?

yes - thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
