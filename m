From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Tue, 2 Dec 2014 14:14:51 +0200
Message-ID: <CAG9sBKNEF4nme4Hjc-8Ehg31QXrY2kRBnp-qCUeQ+UZ6d+YQ5A@mail.gmail.com>
References: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
	<CAG9sBKPGbHc49rLx+z3N+bgzMakFks2ihvgAkZpmjUz==2ZYDQ@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F40F4@CMEXMB1.ad.emulex.com>
	<CAG9sBKMDLNnO1Q8QRNNq9cAnTdEL3DXPhpUqwKqFaN1aMGyomw@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F4C7C@CMEXMB1.ad.emulex.com>
	<CAG9sBKNt0sKixnKj_8ANc3ef4kwEGgrH_5WcCWr3-VfSSf8Ldw@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F642B@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D312F642B-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Agree with all your points above , except for point# 2.  That IMHO would be more of a code refactoring/cleanup patch
> that can be taken up later once the baseline version is checked in as it's not really related to this patch ?
> Also, if we do that , then we also have to take care of  the IB case as well where GID is something that is obtained from the port/card(query_gid)
> as opposed to something that is pushed down from the stack as you are now proposing for IP-based GIDs.. i.e implications are much more than
> what this patch intends to address.
> So I'd rather do this at a later point in time and not club it with V2, sound good ?
>
> Thanks
> Som

Hi Som
I think that it can be done in 2 stages. Moving GID table management
to IB/core is indeed not mandatory for RoCEv2.
However, you might want to consider it anyway since RoCEv2 support is
going to add changes to GID table management anyhow.
So, instead of modifying each device driver sperately, do it once
centrally and add a plugin function in struct ib_device (e.g.
ib_write_gid(union ib_gid, struct ib_gid_info *info)). We can work in
parallel and implement the mlx4 function while you concentrate in
IB/core and ocrdma.

I leave it for you to decide how to proceed from here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
