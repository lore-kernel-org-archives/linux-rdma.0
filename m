From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] Add support for enhanced atomic operations
Date: Tue, 2 Feb 2010 16:02:28 -0800
Message-ID: <F1F846D4754246DC862643839C4CB216@amr.corp.intel.com>
References: <4B66FA54.6030408@dev.mellanox.co.il>	 <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>	 <4B68020D.4080401@dev.mellanox.co.il> <f0e08f231002020754h482ba0f7xe35a78a72cc165e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002020754h482ba0f7xe35a78a72cc165e8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Will Mellanox be adding this option to the IB spec rather than keep it
>as vendor proprietary ?

Along with that question, what is the use case for this feature?  The only
benefit mentioned was saving a few bytes of memory, at the cost of carrying
extra network headers.  Atomics are only 64-bits to begin with...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
