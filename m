From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/CMA: Fix initialization of hop_limit instead of
 hardcode to 1.
Date: Thu, 13 Feb 2014 15:05:09 -0800
Message-ID: <CAG4TOxOTU_0CcN-s_1R6XXfA8wHdZ0gKgst8-y9qmApV-ScPiA@mail.gmail.com>
References: <90ba6b41-2a1a-4419-bb49-4ed8c216e2a7@CMEXHTCAS2.ad.emulex.com>
 <7F44EA5110810A40B7DAFB605C41975D302A7842@CMEXMB1.ad.emulex.com>
 <CAG4TOxO=eovTf+ygZX7O1wfHy2FUU_zxv_vsZXx262bG=PLfuw@mail.gmail.com> <7F44EA5110810A40B7DAFB605C41975D302A94EC@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D302A94EC-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 12, 2014 at 9:44 PM, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Roland,
>
>              Yes you are correct, currently it is not routable , and this
> would probably be the first gentle step in enabling it to be so.
>
> Also, I did see that in ib_init_ah_from_wc() currently , it is already being
> set to 0xff , so this would add symmetry and enable it both ways Iff needed
> of course.
>
> Do you think this should go into for-next instead ?

I'm still trying to understand why this patch should go anywhere.
Repeating my previous question: is there any practical situation where
this makes a difference?

If not then wouldn't it make sense to design how routable IBoE will
work overall before tinkering with minor stuff like this?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
