From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Date: Sun, 10 Feb 2013 21:19:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B96C1F@ORSMSX101.amr.corp.intel.com>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
 <1828884A29C6694DAF28B7E6B8A8237357D44677@ORSMSX101.amr.corp.intel.com>
 <20130209190037.GB2875@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130209190037.GB2875-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Content-Language: en-US
Sender: linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Jean Delvare <khali-PUYAD+kWke1g9hUCZPvPmw@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So, if you want a cyclic allocation, the allocation should be tried in
> [start, END) and then [0, start); otherwise, after the allocation
> wraps for the first time, as the closer the starting point gets to
> END, the chance of not finding a vacant slot in [start, END) goes
> higher.  When @start equals END - 1 for the second time, if the first
> END - 1 allocation is still around, you'll get -ENOSPC.

Got it - thanks.  I'll make a note to fix this.
