From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: rdma_getaddrinfo and GUID
Date: Fri, 24 Jul 2015 11:08:07 +0300
Message-ID: <CACaajQv+GwDAk2AeY2SdYwkdGTXVzeEcU5H4QLStRjJL_OxOcA@mail.gmail.com>
References: <CACaajQsauS65K8tKwygPB03iyv87uy8s-jPn7_gihqbEU6np3Q@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9002987@ORSMSX109.amr.corp.intel.com>
 <CACaajQuvUO4LRym2Mt+dt1XeK6L-bjHVPE5v6Cj3oJdVoQQwuQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A901B918@ORSMSX109.amr.corp.intel.com>
 <CACaajQvfkb=roMub_uzpVZiTPKwF-XY_wqA35AaAAmN3EqZbOg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373A901CA3B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A901CA3B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2015-07-23 22:46 GMT+03:00 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> Ah, yes, the rdma_cm supports GIDs.  It does not support GUIDs.  Though it's usually trivial to convert a GUID into a GID.


in guid you mean node guid ? So using node guied bring something like
multipath (in case of able to via node guid get port guids)

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
