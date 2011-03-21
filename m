From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Adding Congestion Control definitions.
Date: Mon, 21 Mar 2011 10:37:26 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC7B902@orsmsx501.amr.corp.intel.com>
References: <20110321162017.GA5062@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110321162017.GA5062-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +#undef DEBUG
> +#define DEBUG   if (ibdebug)    IBWARN

I didn't see where this was used, but in general this sort of definition may not work.  It can incorrectly associate a 'else' class with the if (ibdebug) statement, rather than the intended statement.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
