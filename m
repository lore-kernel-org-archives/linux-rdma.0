From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: detect rdma capable devices
Date: Fri, 13 Mar 2015 11:46:37 +0300
Message-ID: <CACaajQs8x0TQFyxWgeWjhrWR_D00ZAn7DfiK6BZ_M0n7Nrmz1w@mail.gmail.com>
References: <CACaajQvKaZBmYN5YpJnawSxrUoJOvT+mVkt94oSOFWYT5iNO2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQvKaZBmYN5YpJnawSxrUoJOvT+mVkt94oSOFWYT5iNO2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2015-03-13 10:16 GMT+03:00 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
> I have software that can operate via rdma and via ethernet, what is
> right way to detect rdma devices?
> For example if system have rdma device i'm try to use
> rdma_getaddrinfo, if no rdma drivers/devices - i'm switch to
> getaddrinfo...


Now i'm try to get rdma_get_devices and check it for null, but does it
right solution ?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
