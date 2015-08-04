From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] split struct ib_send_wr
Date: Tue, 4 Aug 2015 16:07:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A902272C@ORSMSX109.amr.corp.intel.com>
References: <20150804143447.GA22172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804143447.GA22172-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> please take a look at my RFC patch here:
> 
> 	http://git.infradead.org/users/hch/scsi.git/commitdiff/751774250b71d
> a83a26ba8584cff70f5e7bb7b1e
> 
> the commit contains my explanation, but apparently the patch is too
> large for the list limit and didn't make it through.

This looks like a reasonable start.  It may help with feedback if you could just post the changes to ib_verbs.h.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
