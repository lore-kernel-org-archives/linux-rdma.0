From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Thu, 9 Mar 2017 05:59:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0EF5FE@ORSMSX109.amr.corp.intel.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
 <20170307181738.GC2228@obsidianresearch.com>
 <6da2bd37-62c3-af73-fe81-5be57a327c2d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6da2bd37-62c3-af73-fe81-5be57a327c2d-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> That's why we want to prevent from new APIs when really not required.
> 
> I believe that we should get input from Doug and other people re the
> above discussion.
> 
> Doug,
> Can we get please your input here ?

I agree with Jason.  There are clear advantages to have type safe APIs.  The overloading that already occurs in the existing APIs (e.g. create/modify_qp, post_send) make them extremely difficult to use.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
