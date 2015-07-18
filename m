From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: rdma_getaddrinfo and GUID
Date: Sun, 19 Jul 2015 00:38:05 +0300
Message-ID: <CACaajQvVmaEMzFAsb9yg984uixHLdy=9KQx2A-_idiv7zVWiuw@mail.gmail.com>
References: <CACaajQsauS65K8tKwygPB03iyv87uy8s-jPn7_gihqbEU6np3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQsauS65K8tKwygPB03iyv87uy8s-jPn7_gihqbEU6np3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2015-07-19 0:15 GMT+03:00 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
> But getting INET6 address
> Also noted that i don't enable IPoIB, why address not IF_IB family ?


my mistake, i miss RAI_FAMILY append to flags ai_flags

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
