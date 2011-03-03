From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/cm: Cancel pending lap message when destroying an ID
Date: Thu, 3 Mar 2011 07:29:14 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC8C4F46@orsmsx501.amr.corp.intel.com>
References: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CC86C58E@orsmsx501.amr.corp.intel.com>
 <AANLkTi=HNbN7jcYPg+j4GUC+_owX=Eq3Ay0KRMkhwkHN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=HNbN7jcYPg+j4GUC+_owX=Eq3Ay0KRMkhwkHN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I tried this and it doesn't fix the issue in my test. It operates only
> in IB_CM_ESTABLISHED but in my tests the order of operations in client
> side is
> 1. rdma_connect() was called
> 2. lap was sent (for which apr will never be received - according to test case)
> 3. rdma_disconnect() was called

Let me think about the best way to handle this.  We may want ib_send_cm_dreq() to cancel any outstanding LAP message.  This should fix the destroy case as well, since it calls into disconnect.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
