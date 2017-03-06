From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Issues Building krping on RHEL 7.2
Date: Mon, 6 Mar 2017 08:51:05 -0600
Message-ID: <084301d29689$15355b70$3fa01250$@opengridcomputing.com>
References: <DM3PR07MB22010C36EE6B652B1AA1356FF82D0@DM3PR07MB2201.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM3PR07MB22010C36EE6B652B1AA1356FF82D0-jBX7zO+Db/wI9Q/2ysJlLeFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Steve,
> Are you the maintainer of krping?
> I've tried to build krping from
> https://github.com/larrystevenwise/krping.git.
> But I get multiple errors.
> I guess I'm missing something simple.
> 
> i.e. -
> 0. RHEL 7.2 with INBOX OFED (tried also newer kernels)
> 1. git clone https://github.com/larrystevenwise/krping.git
> 2. vim Makefile and have 'KSRC=/usr/src/kernels/3.10.0-327.el7.x86_64/'
> 3. Make
> 
> And I get all the errors below.
> 
> Any clue?

Hey Ram.  The krping code is only maintained on the most recent upstream
kernels.   So your best shot is using >= 4.8.  A quick compile on 4.10 works
for me.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
