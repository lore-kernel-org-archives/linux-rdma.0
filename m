From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 1/1] RDMA/uverbs: Intialize cq_context properly
Date: Wed, 16 Aug 2017 10:02:57 -0500
Message-ID: <009d01d316a0$be80b200$3b821600$@opengridcomputing.com>
References: <1502132526-18355-1-git-send-email-bharat@chelsio.com> <20170812124810.GA21000@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170812124810.GA21000-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Doug,
> Please pull this change for next rc if you feel the change appropriate.
> Thanks,
> Bharat.

I think this commit needs to be pushed to stable as well.  I see the commit it
fixes in linux-4.12.y.  Doug can you please add the stable tag when you merge
this?

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
