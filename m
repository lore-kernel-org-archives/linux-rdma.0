From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
Date: Tue, 10 Nov 2009 13:12:17 -0800
Message-ID: <E34EB5B2A00C459EB20F307ED1C5B437@amr.corp.intel.com>
References: <20091028054253.GA22882@obsidianresearch.com> <1256846162.12957.27.camel@wilder.ibm.com> <20091029202106.GF1966@obsidianresearch.com> <4AF9D5A1.6030309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF9D5A1.6030309-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Pradeep Satyanarayana' <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>How can we make progress? What are your thoughts?

I'm actually working on this today.  I've taken Jason's patch as a starting
point, and I'm breaking it into separate patches for merging and testing.  I
hope to post the patches within the next couple of days.  I'll compare my final
patches against the ones submitted by David to see if anything got missed.

Help with testing would be great.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
