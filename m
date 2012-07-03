From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Q] How to tranfer a file which is over 2GB(2^31) size in RDMA network?
Date: Wed, 4 Jul 2012 08:02:32 +0900
Message-ID: <CA+Tq-RqNUdmBL1ZYwKKeX3CB3OGiSzK3JO+LgttHBaR6HB4Bvg@mail.gmail.com>
References: <CA+Tq-Rpk-Q74k2z=ToCK+eeDKuF_84fU2t0LwMBM==QG4P8XgA@mail.gmail.com>
	<5D6C0ABE6A236946864C45679362BBE20ACA83E1@CMEXMB1.ad.emulex.com>
	<CA+Tq-Rqm0vVnnvd6Zvtazs=qdwxKuC+9NwPt0LdbVS5HJa8=Ww@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A4E8E9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A4E8E9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Sean

Thank you for your information.

I'll try it.

P.S.
I'm reading rockets(librdmacm) commit log for study Infiniband. :-)


2012/7/4 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
>> Hello Parav.Pandit
>>
>> Thank you for your advice.
>>
>> I'll try it.
>
> You can also look at rsockets in the latest librdmacm library.  You'd need to download and build the library yourself, since rsockets is not yet available in any release.  But there's a sample program (rcopy) that will copy a file between two systems over that API.
>
> I haven't tried using it to copy a very large files, but in theory it should work.  (Hey, maybe you'll get lucky!)  If you do try it and hit into any problems, please let me know.
>
> - Sean



-- 
Hiroyuki Sato
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
