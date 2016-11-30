From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [1/1] ibacm: Modify comment related to default pkey in
 ibacm_addr.cfg
Date: Wed, 30 Nov 2016 23:36:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BA504@ORSMSX109.amr.corp.intel.com>
References: <1480445462-88653-1-git-send-email-jay.p.patel@intel.com>
 <1480445462-88653-2-git-send-email-jay.p.patel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480445462-88653-2-git-send-email-jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Patel, Jay P" <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Comment in ibacm_addr.cfg mentions that default pkey is 0xffff while
> the default pkey is the first entry in pkey table which may be
> different from 0xffff. Hence, comment specifying default key as 0xffff
> is misleading.

Please add a signed-off-by line.  Opening a pull request directly against the github tree would simplify merging this.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
